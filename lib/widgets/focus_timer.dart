import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:vfocused_app/core/constants.dart';
import 'package:vfocused_app/providers/pomodoro_provider.dart';
import 'package:vfocused_app/routes/app_routes.dart';

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
              width: 310,
              height: 310,
              child: CircularProgressIndicator(
                year2023: false,
                value: progress,
                strokeWidth: 22,
                backgroundColor:
                    state.session != PomodoroSession.focus
                        ? AppColors.neonPurple.withValues(alpha: 0.1)
                        : AppColors.neonGreen.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation(
                  state.isRunning && state.session == PomodoroSession.focus
                      ? AppColors.neonGreen
                      : state.session != PomodoroSession.focus
                      ? AppColors.neonPurple
                      : AppColors.neonGreen.withValues(alpha: 0.95),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 160,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sessionLabel.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white60,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Cycle: ${state.completedCycles}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white60,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child:
                  !state.isRunning && state.session == PomodoroSession.focus
                      ? SizedBox(
                        key: const ValueKey(
                          'slider',
                        ), // Important for transition!
                        height: 240,
                        width: 240,
                        child: SleekCircularSlider(
                          initialValue:
                              state.focusDuration.inMinutes.toDouble(),
                          min: 1,
                          max: 60,
                          onChange: (value) {
                            final steppedValue = value.round();
                            notifier.setFocusDuration(steppedValue);
                          },
                          innerWidget: (value) {
                            final steppedValue = value.round();
                            return Center(
                              child: Text(
                                '$steppedValue min',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                          appearance: CircularSliderAppearance(
                            angleRange: 360,
                            startAngle: 270,
                            size: 220,
                            customColors: CustomSliderColors(
                              dotColor: AppColors.neonBlue,
                              progressBarColor: AppColors.neonBlue,
                              trackColor: AppColors.neonBlue.withValues(
                                alpha: 0.1,
                              ),
                            ),
                            customWidths: CustomSliderWidths(
                              progressBarWidth: 18,
                              trackWidth: 14,
                              handlerSize: 14,
                            ),
                          ),
                        ),
                      )
                      : Center(
                        key: const ValueKey(
                          'timer',
                        ), // Different key for other widget
                        child: Text(
                          formatTime(state.remaining),
                          style: const TextStyle(
                            fontSize: 52,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton.icon(
              onPressed: () {
                if (state.isRunning) {
                  notifier.pause();
                } else {
                  notifier.start();
                }
              },

              label: Text(
                state.isRunning ? 'Pause' : 'Start',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              icon: Icon(
                state.isRunning
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color:
                    state.session != PomodoroSession.focus
                        ? AppColors.neonPurple
                        : AppColors.neonGreen,
                size: 28,
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 12,
                ),
                backgroundColor:
                    state.session != PomodoroSession.focus
                        ? AppColors.neonPurple.withValues(alpha: 0.2)
                        : AppColors.neonGreen.withValues(alpha: 0.2),
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              iconSize: 36,
              splashRadius: 90,
              onPressed: () {
                if (state.isRunning) {
                  Navigator.pushNamed(context, AppRoutes.fullscreenTimer);
                } else {
                  notifier.reset();
                }
              },
              icon: Icon(
                state.isRunning
                    ? Icons.fullscreen_rounded
                    : Icons.replay_rounded,
                color: AppColors.neonBlue,
              ),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.neonBlue.withValues(alpha: 0.2),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
