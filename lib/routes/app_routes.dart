import 'package:flutter/material.dart';
import 'package:vfocused_app/pages/home/home_page.dart';
import 'package:vfocused_app/pages/landing/landing_page.dart';
import 'package:vfocused_app/pages/settings/settings_page.dart';
import 'package:vfocused_app/pages/statistics/statistics_page.dart';
import 'package:vfocused_app/widgets/fullscreen_timer.dart';

/// AppRoutes class containing all route names and route generation logic
class AppRoutes {
  /// Route constants
  static const String landing = '/';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String statistics = '/statistics';
  static const String helpFeedback = '/help-feedback';
  static const String fullscreenTimer = '/fullscreen-timer';

  /// Route generator method
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case landing:
        return MaterialPageRoute(builder: (_) => const LandingPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case statistics:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case helpFeedback:
        return MaterialPageRoute(builder: (_) => const StatisticsPage());
      case fullscreenTimer:
        return MaterialPageRoute(
          builder: (_) => const FullscreenPomodoroClock(),
        );
      default:
        return _errorRoute(routeSettings.name);
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
