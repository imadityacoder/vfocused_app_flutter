import 'package:flutter/material.dart';
import 'package:vfocused_app/core/constants.dart';
import 'package:vfocused_app/routes/app_routes.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Image.asset('assets/images/landing_img.png'),
            ),

            // Title
            Text(
              'Welcome to \nVFocused App',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: AppColors.neonPurple,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Subtitle
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 70,
              child: Center(
                child: Text(
                  'Minutes count, make every one lit. Focus, pause, repeat — success unlocked.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),

            // Get Started Button
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              },
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                backgroundColor: WidgetStatePropertyAll(AppColors.button),
              ),
              child: Text(
                "Get Started",
                style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
