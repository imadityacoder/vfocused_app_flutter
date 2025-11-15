import 'package:flutter/material.dart';
import 'package:vfocused_app/core/constants.dart';

class SummaryRow extends StatelessWidget {
  const SummaryRow({super.key});

  Widget _item(String label, String value, IconData icon) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neonPurple.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.neonPurple),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 22),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _item("Total Focus", "128m", Icons.access_time),
        _item("Sessions", "14", Icons.timer_outlined),
        _item("Break", "32m", Icons.coffee),
      ],
    );
  }
}
