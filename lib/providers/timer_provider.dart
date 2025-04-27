import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stores selected duration
final timerDurationProvider = StateProvider<Duration>((ref) {
  return const Duration(minutes: 25);
});

/// Stores remaining countdown
final timerCountdownProvider = StateProvider<Duration>((ref) {
  return ref.watch(timerDurationProvider);
});

/// Tracks whether timer is running
final timerRunningProvider = StateProvider<bool>((ref) => false);

/// Timer Logic Controller
final timerControllerProvider = Provider<TimerController>((ref) {
  return TimerController(ref);
});

class TimerController {
  final Ref ref;
  Timer? _timer;

  TimerController(this.ref);

  void start() {
    if (_timer != null) return;

    ref.read(timerRunningProvider.notifier).state = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final current = ref.read(timerCountdownProvider);
      if (current.inSeconds <= 1) {
        pause();
        ref.read(timerCountdownProvider.notifier).state = Duration.zero;
        return;
      }
      ref.read(timerCountdownProvider.notifier).state =
          current - const Duration(seconds: 1);
    });
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
    ref.read(timerRunningProvider.notifier).state = false;
  }

  void reset() {
    pause();
    final original = ref.read(timerDurationProvider);
    ref.read(timerCountdownProvider.notifier).state = original;
  }
}
