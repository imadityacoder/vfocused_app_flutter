import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vfocused_app/core/constants.dart';
import 'package:vfocused_app/providers/pomodoro_provider.dart';
import 'package:vfocused_app/widgets/app_drawer.dart';
import 'package:vfocused_app/widgets/focus_timer.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusedToday = ref.watch(focusedTodayProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Builder(
          builder:
              (context) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    if (Scaffold.of(context).hasDrawer) {
                      Scaffold.of(context).openDrawer();
                    } else {
                      print("No drawer found.");
                    }
                  },
                  radius: 30,
                  child: SvgPicture.asset('assets/icons/Menu.svg'),
                ),
              ),
        ),

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
