import 'package:flutter/material.dart';
import 'package:vfocused_app/core/constants.dart';
import 'package:vfocused_app/routes/app_routes.dart';

/// App drawer for main navigation
class AppDrawer extends StatelessWidget {
  /// Constructor
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 1,
      backgroundColor: AppColors.background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 120,
            child: Center(
              child: Text(
                'VFocused',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Orbitron',
                ),
              ),
            ),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.timer,
            title: 'Pomodoro Timer',
            route: AppRoutes.home,
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.task_alt,
            title: 'Tasks',
            route: AppRoutes.tasks,
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.analytics,
            title: 'Statistics',
            onTap: () {
              // TODO: Implement statistics page
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Statistics coming soon!')),
              );
            },
          ),

          _buildDrawerItem(
            context: context,
            icon: Icons.settings,
            title: 'Settings',
            route: AppRoutes.settings,
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.help_outline,
            title: 'Help & Feedback',
            onTap: () {
              // TODO: Implement help page
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help page coming soon!')),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Build a drawer list item
  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? route,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: AppColors.textPrimary)),
      onTap:
          onTap ??
          () {
            Navigator.pop(context);
            if (route != null) {
              Navigator.pushNamed(context, route);
            }
          },
    );
  }
}
