import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vfocused_app/core/constants.dart';
import 'package:vfocused_app/providers/statistics_provider.dart';

class SummaryRow extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dailyStatsProvider);

    final totalBreakMinutes = (stats.shortBreaks * 5) + (stats.longBreaks * 15);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _item("Total Focus", "${stats.focusedMinutes}m", Icons.access_time),
        _item("Sessions", "${stats.completedCycles}", Icons.timer_outlined),
        _item("Break", "${totalBreakMinutes}m", Icons.coffee),
      ],
    );
  }
}
