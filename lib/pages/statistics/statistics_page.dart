import 'package:flutter/material.dart';
import 'package:vfocused_app/core/constants.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Statistics'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bar_chart_rounded,
              size: 80,
              color: AppColors.neonPurple,
            ),
            const SizedBox(height: 20),
            Text(
              'Statistics Coming Soon',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Track your Statistics and productivity',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      // Set currentIndex to 1 because this is the tasks page (index 1 in the bottom nav)
    );
  }
}
