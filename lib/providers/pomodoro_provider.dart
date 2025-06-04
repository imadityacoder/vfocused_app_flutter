import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  void start() {
    _timer?.cancel();

    state = state.copyWith(isRunning: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remaining.inSeconds <= 1) {
        timer.cancel();
        _nextSession();
      } else {
        state = state.copyWith(
          remaining: state.remaining - const Duration(seconds: 1),
        );
      }
    });
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();
    state = state.copyWith(
      isRunning: false,
      remaining: _currentSessionDuration(),
    );
  }

  void setFocusDuration(int minutes) {
    final newDuration = Duration(minutes: minutes);
    state = state.copyWith(focusDuration: newDuration, remaining: newDuration);
  }

  int focusedToday() {
    final total = state.completedCycles * state.focusDuration.inMinutes;
    return total;
  }

  Duration _currentSessionDuration() {
    switch (state.session) {
      case PomodoroSession.focus:
        return state.focusDuration;
      case PomodoroSession.shortBreak:
        return const Duration(minutes: 5);
      case PomodoroSession.longBreak:
        return const Duration(minutes: 15);
    }
  }

  void _nextSession() {
    switch (state.session) {
      case PomodoroSession.focus:
        int newCycles = state.completedCycles + 1;
        bool isLongBreak = newCycles % 4 == 0;

        state = state.copyWith(
          session:
              isLongBreak
                  ? PomodoroSession.longBreak
                  : PomodoroSession.shortBreak,
          remaining:
              isLongBreak
                  ? const Duration(minutes: 15)
                  : const Duration(minutes: 5),
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
