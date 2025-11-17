import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vfocused_app/core/constants.dart';
import 'package:vfocused_app/providers/statistics_provider.dart';

class AIInsights extends ConsumerWidget {
  const AIInsights({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statisticsProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.card.withValues(alpha: 0.95),
            AppColors.card.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.neonPurple.withValues(alpha: 0.4),
          width: 1.6,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonPurple.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Neon Left Bar
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

          // Dynamic Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "🧠 AI Insights",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                _InsightBullet(
                  text:
                      "Your peak focus time is between **${stats.peakFocusStart.format(context)} – ${stats.peakFocusEnd.format(context)}**.",
                ),

                const SizedBox(height: 6),

                _InsightBullet(
                  text:
                      "Your break habits improve productivity by **${stats.shortBreakBoost}%**.",
                ),

                const SizedBox(height: 6),

                _InsightBullet(
                  text:
                      "Your longest focus streak is **${stats.longestStreak} days**. Keep chasing higher consistency!",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
