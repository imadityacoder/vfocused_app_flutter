import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vfocused_app/services/notification_service.dart';
import 'package:vfocused_app/services/sound_service.dart';

enum PomodoroSession { focus, shortBreak, longBreak }

class PomodoroState {
  final Duration remaining;
  final bool isRunning;
  final PomodoroSession session;
  final Duration focusDuration;
  final int completedCycles;

  PomodoroState({
    required this.remaining,
    required this.isRunning,
    required this.session,
    required this.focusDuration,
    required this.completedCycles,
  });

  PomodoroState copyWith({
    Duration? remaining,
    bool? isRunning,
    PomodoroSession? session,
    Duration? focusDuration,
    int? completedCycles,
  }) {
    return PomodoroState(
      remaining: remaining ?? this.remaining,
      isRunning: isRunning ?? this.isRunning,
      session: session ?? this.session,
      focusDuration: focusDuration ?? this.focusDuration,
      completedCycles: completedCycles ?? this.completedCycles,
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
        ),
      );

  Timer? _timer;
  int _lastCompletedCycle = 0;

  void start() {
    _timer?.cancel();
    state = state.copyWith(isRunning: true);

    final totalDuration = _currentSessionDuration();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (state.remaining.inSeconds <= 1) {
        timer.cancel();
        await cancelPomodoroNotification(); // stop progress bar
        _nextSession();
      } else {
        final newRemaining = state.remaining - const Duration(seconds: 1);

        state = state.copyWith(remaining: newRemaining);

        await showPomodoroProgressNotification(
          sessionLabel: _sessionLabel(state.session),
          remaining: newRemaining,
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

  void _nextSession() async {
    switch (state.session) {
      case PomodoroSession.focus:
        int newCycles = state.completedCycles + 1;
        SoundService.playCycleCompleteSound();
        await showSessionDoneNotification("Time for a break!");

        // play sound on cycle complete
        if (newCycles > _lastCompletedCycle) {
          _lastCompletedCycle = newCycles;
        }

        bool isLongBreak = newCycles % 4 == 0;

        state = state.copyWith(
          session:
              isLongBreak
                  ? PomodoroSession.longBreak
                  : PomodoroSession.shortBreak,
          remaining:
              isLongBreak
                  ? const Duration(minutes: longBreakDuration)
                  : const Duration(minutes: shortBreakDuration),
          isRunning: false,
          completedCycles: newCycles,
        );
        break;

      case PomodoroSession.shortBreak:
      case PomodoroSession.longBreak:
        state = state.copyWith(
          session: PomodoroSession.focus,
          remaining: state.focusDuration,
          isRunning: false,
        );
        SoundService.playCycleBreakSound();
        await showSessionDoneNotification("Back to Focus!");
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

final focusedTodayProvider = Provider<int>((ref) {
  final state = ref.watch(pomodoroProvider);

  // Calculate total focused minutes from completed cycles
  final totalFocusedMinutes =
      state.completedCycles * state.focusDuration.inMinutes;

  return totalFocusedMinutes;
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
