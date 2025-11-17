import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vfocused_app/services/notification_service.dart';
import 'package:vfocused_app/services/sound_service.dart';

enum PomodoroSession { focus, shortBreak, longBreak }

class PomodoroState {
  final Duration remaining;
  final bool isRunning;
  final PomodoroSession session;
  final Duration focusDuration;
  final int completedCycles;
  final int shortBreaks;
  final int longBreaks;
  final int focusedToday;

  PomodoroState({
    required this.remaining,
    required this.isRunning,
    required this.session,
    required this.focusDuration,
    required this.completedCycles,
    required this.shortBreaks,
    required this.longBreaks,
    required this.focusedToday,
  });

  PomodoroState copyWith({
    Duration? remaining,
    bool? isRunning,
    PomodoroSession? session,
    Duration? focusDuration,
    int? completedCycles,
    int? shortBreaks,
    int? longBreaks,
    int? focusedToday,
  }) {
    return PomodoroState(
      remaining: remaining ?? this.remaining,
      isRunning: isRunning ?? this.isRunning,
      session: session ?? this.session,
      focusDuration: focusDuration ?? this.focusDuration,
      completedCycles: completedCycles ?? this.completedCycles,
      shortBreaks: shortBreaks ?? this.shortBreaks,
      longBreaks: longBreaks ?? this.longBreaks,
      focusedToday: focusedToday ?? this.focusedToday,
    );
  }
}

const shortBreakDuration = 5;
const longBreakDuration = 15;

class PomodoroNotifier extends StateNotifier<PomodoroState> {
  PomodoroNotifier()
    : super(
        PomodoroState(
          remaining: const Duration(minutes: 25),
          isRunning: false,
          session: PomodoroSession.focus,
          focusDuration: const Duration(minutes: 25),
          completedCycles: 0,
          shortBreaks: 0,
          longBreaks: 0,
          focusedToday: 0,
        ),
      ) {
    _loadData();
  }

  Timer? _timer;
  final int _lastCompletedCycle = 0;

  // --------------------------
  // LOAD & SAVE FUNCTIONS
  // --------------------------
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final today = DateTime.now().day;
    final savedDay = prefs.getInt("saved_day") ?? today;

    if (savedDay != today) {
      // new day → reset all counters
      await prefs.clear();
      await prefs.setInt("saved_day", today);
      return;
    }

    state = state.copyWith(
      completedCycles: prefs.getInt("completedCycles") ?? 0,
      shortBreaks: prefs.getInt("shortBreaks") ?? 0,
      longBreaks: prefs.getInt("longBreaks") ?? 0,
      focusedToday: prefs.getInt("focusedToday") ?? 0,
    );
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("completedCycles", state.completedCycles);
    await prefs.setInt("shortBreaks", state.shortBreaks);
    await prefs.setInt("longBreaks", state.longBreaks);
    await prefs.setInt("focusedToday", state.focusedToday);
    await prefs.setInt("saved_day", DateTime.now().day);
  }

  // --------------------------
  // POMODORO LOGIC
  // --------------------------

  void start() {
    _timer?.cancel();
    state = state.copyWith(isRunning: true);

    final totalDuration = _currentSessionDuration();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (state.remaining.inSeconds <= 1) {
        timer.cancel();
        await cancelPomodoroNotification();
        _nextSession();
      } else {
        state = state.copyWith(
          remaining: state.remaining - const Duration(seconds: 1),
        );

        await showPomodoroProgressNotification(
          sessionLabel: _sessionLabel(state.session),
          remaining: state.remaining,
          total: totalDuration,
        );
      }
    });
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() async {
    _timer?.cancel();
    state = state.copyWith(
      isRunning: false,
      remaining: _currentSessionDuration(),
    );
    await cancelPomodoroNotification();
  }

  void setFocusDuration(int minutes) {
    final newDuration = Duration(minutes: minutes);
    state = state.copyWith(focusDuration: newDuration, remaining: newDuration);
  }

  Duration _currentSessionDuration() {
    switch (state.session) {
      case PomodoroSession.focus:
        return state.focusDuration;
      case PomodoroSession.shortBreak:
        return const Duration(minutes: shortBreakDuration);
      case PomodoroSession.longBreak:
        return const Duration(minutes: longBreakDuration);
    }
  }

  // --------------------------
  // STATE TRANSITIONS
  // --------------------------

  void _nextSession() async {
    switch (state.session) {
      // --------------------------
      // FOCUS → BREAK
      // --------------------------
      case PomodoroSession.focus:
        final newCycles = state.completedCycles + 1;

        SoundService.playCycleCompleteSound();
        await showSessionDoneNotification("Time for a break!");

        final isLongBreak = newCycles % 4 == 0;

        final addedMinutes = state.focusDuration.inMinutes;

        state = state.copyWith(
          completedCycles: newCycles,
          focusedToday: state.focusedToday + addedMinutes,
          session:
              isLongBreak
                  ? PomodoroSession.longBreak
                  : PomodoroSession.shortBreak,
          remaining: Duration(
            minutes: isLongBreak ? longBreakDuration : shortBreakDuration,
          ),
          isRunning: false,
        );
        await _saveData();
        break;

      // --------------------------
      // BREAK → FOCUS
      // --------------------------
      case PomodoroSession.shortBreak:
        state = state.copyWith(
          shortBreaks: state.shortBreaks + 1,
          session: PomodoroSession.focus,
          remaining: state.focusDuration,
          isRunning: false,
        );
        SoundService.playCycleBreakSound();
        await showSessionDoneNotification("Back to Focus!");
        await _saveData();
        break;

      case PomodoroSession.longBreak:
        state = state.copyWith(
          longBreaks: state.longBreaks + 1,
          session: PomodoroSession.focus,
          remaining: state.focusDuration,
          isRunning: false,
        );
        SoundService.playCycleBreakSound();
        await showSessionDoneNotification("Back to Focus!");
        await _saveData();
        break;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final pomodoroProvider = StateNotifierProvider<PomodoroNotifier, PomodoroState>(
  (ref) => PomodoroNotifier(),
);

// Expose focusedToday cleanly
final focusedTodayProvider = Provider<int>((ref) {
  return ref.watch(pomodoroProvider).focusedToday;
});

String _sessionLabel(PomodoroSession session) {
  switch (session) {
    case PomodoroSession.focus:
      return "Focus";
    case PomodoroSession.shortBreak:
      return "Short Break";
    case PomodoroSession.longBreak:
      return "Long Break";
  }
}
