import 'package:flutter/material.dart';
import 'package:vfocused_app/pages/home/home_page.dart';
import 'package:vfocused_app/pages/landing/landing_page.dart';
import 'package:vfocused_app/pages/settings/settings_page.dart';
import 'package:vfocused_app/pages/tasks/tasks_page.dart';

/// AppRoutes class containing all route names and route generation logic
class AppRoutes {
  /// Route constants
  static const String landing = '/';
  static const String home = '/home';
  static const String tasks = '/tasks';
  static const String settings = '/settings';

  /// Route generator method
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case landing:
        return MaterialPageRoute(builder: (_) => const LandingPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case tasks:
        return MaterialPageRoute(builder: (_) => const TasksPage());
      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(String? routeName) {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            appBar: AppBar(title: const Text('Route Error')),
            body: Center(child: Text('No route defined for "$routeName"')),
          ),
    );
  }
}
