import 'package:flutter/material.dart';
import 'package:vfocused_app/core/constants.dart';

class AIInsights extends StatelessWidget {
  const AIInsights({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.card.withOpacity(0.95),
            AppColors.card.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.neonPurple.withOpacity(0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonPurple.withOpacity(0.45),
            blurRadius: 25,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Decorative left neon bar
          Container(
            width: 5,
            height: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [AppColors.neonPurple, AppColors.neonBlue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "🧠 AI Insights",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),

                // ✨ Bullet insights
                _InsightBullet(
                  text:
                      "Your **peak focus window** is between **4 PM – 7 PM**. Perfect time for deep-work sessions.",
                ),
                SizedBox(height: 6),
                _InsightBullet(
                  text:
                      "You take frequent short breaks, which boosts average productivity by **9%**.",
                ),
                SizedBox(height: 6),
                _InsightBullet(
                  text:
                      "Your longest streak was **4 days**. Try hitting **6 days** for a performance boost.",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------
// Reusable insight bullet widget
// ----------------------------------------------
class _InsightBullet extends StatelessWidget {
  final String text;
  const _InsightBullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("• ", style: TextStyle(color: Colors.white70, fontSize: 15)),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
