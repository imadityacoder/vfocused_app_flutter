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
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/logo.png', height: 24),
                      Text(
                        'Focused',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Orbitron',
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded),
                  ),
                ],
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
            icon: Icons.screen_lock_landscape_rounded,
            title: 'FullScreen Mode',
            route: AppRoutes.fullscreenTimer,
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.analytics,
            title: 'Statistics',
            route: AppRoutes.statistics,
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
            route: AppRoutes.helpFeedback,
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
