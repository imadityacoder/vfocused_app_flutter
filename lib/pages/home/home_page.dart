import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vfocused_app/core/constants.dart';
import 'package:vfocused_app/providers/pomodoro_provider.dart';
import 'package:vfocused_app/widgets/app_drawer.dart';
import 'package:vfocused_app/widgets/focus_timer.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusedToday = ref.watch(pomodoroProvider.notifier).focusedToday();
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              "Focused Today: ${focusedToday}min",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Orbitron',
              ),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title Text
                const Text(
                  "Pomodoro Timer",
                  style: TextStyle(fontSize: 32, color: AppColors.textPrimary),
                ),

                const SizedBox(height: 30),

                // Timer Widget
                const FocusTimer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
