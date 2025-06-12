import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vfocused_app/routes/app_routes.dart';
import 'package:vfocused_app/services/notification_service.dart';
import 'core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeNotifications();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'v_focused',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
