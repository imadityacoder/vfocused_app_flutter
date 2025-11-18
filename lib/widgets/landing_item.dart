import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vfocused_app/core/constants.dart';
import 'package:vfocused_app/routes/app_routes.dart';
import 'package:vfocused_app/widgets/api_key_dialog.dart';

class LandingItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final bool showButton;

  const LandingItem({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.showButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      color: AppColors.card,
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: width * 0.8, child: Image.asset(imagePath)),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: AppColors.neonPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: width * 0.8,
              height: 70,
              child: Center(
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            if (showButton) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('hasSeenLanding', true);

                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                  Future.microtask(() {
                    showApiKeyDialog(context);
                  });
                },
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  padding: WidgetStatePropertyAll(
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  backgroundColor: WidgetStatePropertyAll(AppColors.button),
                ),
                child: Text(
                  "Get Started",
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
