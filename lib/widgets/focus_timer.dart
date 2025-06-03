import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:vfocused_app/core/constants.dart';
import 'package:vfocused_app/providers/pomodoro_provider.dart';

class FocusTimer extends ConsumerWidget {
  const FocusTimer({super.key});

  String formatTime(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pomodoroProvider);
    final notifier = ref.read(pomodoroProvider.notifier);

    final maxSeconds = switch (state.session) {
      PomodoroSession.focus => state.focusDuration.inSeconds,
      PomodoroSession.shortBreak => 5 * 60,
      PomodoroSession.longBreak => 15 * 60,
    };

    final progress = state.remaining.inSeconds / maxSeconds;

    final sessionLabel = switch (state.session) {
      PomodoroSession.focus => 'Focus',
      PomodoroSession.shortBreak => 'Short Break',
      PomodoroSession.longBreak => 'Long Break',
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 280,
              height: 280,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 18,
                year2023: false,
                backgroundColor: Colors.grey.shade900,
                valueColor: const AlwaysStoppedAnimation(AppColors.neonGreen),
              ),
            ),
            if (!state.isRunning && state.session == PomodoroSession.focus)
              SleekCircularSlider(
                initialValue: state.focusDuration.inMinutes.toDouble(),
                max: 120,
                min: 1,
                onChange: (value) => notifier.setFocusDuration(value.toInt()),
                innerWidget:
                    (value) => Center(
                      child: Text(
                        '${value.toInt()} min',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                appearance: CircularSliderAppearance(
                  angleRange: 360,
                  startAngle: -90,
                  customColors: CustomSliderColors(
                    dotColor: AppColors.neonBlue,
                    progressBarColor: AppColors.neonBlue,
                    trackColor: Colors.grey.shade900,
                  ),
                  size: 220,
                  customWidths: CustomSliderWidths(
                    progressBarWidth: 18,
                    trackWidth: 14,
                    handlerSize: 20,
                  ),
                ),
              )
            else
              Center(
                child: Text(
                  formatTime(state.remaining),
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(
              height: 120,
              child: Positioned(
                top: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sessionLabel.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Cycle: ${state.completedCycles}",
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                if (state.isRunning) {
                  notifier.pause();
                } else {
                  notifier.start();
                }
              },
              iconSize: 80,
              splashRadius: 90,
              icon: Icon(
                state.isRunning ? Icons.pause_circle : Icons.play_circle,
                color: AppColors.neonGreen,
              ),
            ),

            if (!state.isRunning)
              IconButton(
                iconSize: 40,
                splashRadius: 90,
                onPressed: notifier.reset,
                icon: const Icon(
                  Icons.restart_alt_sharp,
                  color: AppColors.neonBlue,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
