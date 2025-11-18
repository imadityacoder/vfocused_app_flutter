import 'package:flutter/material.dart';
import 'package:vfocused_app/core/constants.dart';

class ComparisonSection extends StatelessWidget {
  const ComparisonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.neonPurple.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            "Weekly Comparison",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          // Focus %
          _trendRow(
            label: "Focus Time",
            emoji: "🔥",
            changeText: "+14%",
            positive: true,
          ),

          const SizedBox(height: 10),

          _progressBar(0.72, Colors.greenAccent.shade200),

          const SizedBox(height: 20),

          // Break time %
          _trendRow(
            label: "Break Duration",
            emoji: "☕",
            changeText: "-9%",
            positive: false,
          ),

          const SizedBox(height: 10),

          _progressBar(0.32, Colors.redAccent.shade200),
        ],
      ),
    );
  }

  // ------------------------------------
  // Trend Row Component
  // ------------------------------------
  Widget _trendRow({
    required String label,
    required String emoji,
    required String changeText,
    required bool positive,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$emoji  $label",
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        Text(
          changeText,
          style: TextStyle(
            color: positive ? Colors.greenAccent : Colors.redAccent,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ------------------------------------
  // Progress Bar Component
  // ------------------------------------
  Widget _progressBar(double value, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 8,
        backgroundColor: Colors.white12,
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }
}
