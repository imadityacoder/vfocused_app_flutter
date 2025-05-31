import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vfocused_app/core/constants.dart';

/// Tasks page to display and manage user tasks
class TasksPage extends ConsumerWidget {
  /// Constructor
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Tasks'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.task_alt, size: 80, color: AppColors.neonPurple),
            const SizedBox(height: 20),
            Text(
              'Tasks Coming Soon',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Track your tasks and productivity',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      // Set currentIndex to 1 because this is the tasks page (index 1 in the bottom nav)
    );
  }
}
