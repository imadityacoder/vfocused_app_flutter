import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vfocused_app/core/constants.dart';
import 'package:vfocused_app/providers/pomodoro_provider.dart';

class FullscreenPomodoroClock extends ConsumerStatefulWidget {
  const FullscreenPomodoroClock({super.key});

  @override
  ConsumerState<FullscreenPomodoroClock> createState() =>
      _FullscreenPomodoroClockState();
}

class _FullscreenPomodoroClockState
    extends ConsumerState<FullscreenPomodoroClock> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    super.initState();
    // Lock to landscape mode only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final pomodoroState = ref.watch(pomodoroProvider);
    final pomodoroNotifier = ref.read(pomodoroProvider.notifier);

    final sessionLabel =
        pomodoroState.session == PomodoroSession.focus
            ? 'FOCUS'
            : pomodoroState.session == PomodoroSession.shortBreak
            ? 'SHORT BREAK'
            : 'LONG BREAK';

    final timeRemaining = formatDuration(pomodoroState.remaining);
    final icon =
        pomodoroState.isRunning ? Icons.pause_circle : Icons.play_circle;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                sessionLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  letterSpacing: 1.5,
                ),
              ),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  timeRemaining,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 40,
                    splashRadius: 50,
                    icon: Icon(icon, color: AppColors.button),
                    onPressed: () {
                      pomodoroState.isRunning
                          ? pomodoroNotifier.pause()
                          : pomodoroNotifier.start();
                    },
                  ),
                  IconButton(
                    iconSize: 40,
                    splashRadius: 50,
                    icon: const Icon(
                      Icons.fullscreen_exit_rounded,
                      color: AppColors.neonBlue,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
