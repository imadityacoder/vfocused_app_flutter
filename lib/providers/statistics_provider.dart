import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ------------------------------------------------------------
/// 🟦 DAILY STATS MODEL (for SharedPreferences)
/// ------------------------------------------------------------
class DailyStats {
  final int focusedMinutes;
  final int completedCycles;
  final int shortBreaks;
  final int longBreaks;

  DailyStats({
    required this.focusedMinutes,
    required this.completedCycles,
    required this.shortBreaks,
    required this.longBreaks,
  });

  // Productivity score out of 100
  int get productivityScore {
    final score =
        (focusedMinutes * 1.5) +
        (completedCycles * 5) +
        (shortBreaks * 1) +
        (longBreaks * 2);

    return score.clamp(0, 100).toInt();
  }

  double get focusRatio {
    final total = completedCycles + shortBreaks + longBreaks;
    if (total == 0) return 0;
    return completedCycles / total;
  }

  double get breakRatio {
    final total = completedCycles + shortBreaks + longBreaks;
    if (total == 0) return 0;
    return (shortBreaks + longBreaks) / total;
  }
}

/// ------------------------------------------------------------
/// 🟦 DAILY STATS NOTIFIER (loads stats from SharedPreferences)
/// ------------------------------------------------------------
class StatisticsNotifier extends StateNotifier<DailyStats> {
  StatisticsNotifier()
    : super(
        DailyStats(
          focusedMinutes: 0,
          completedCycles: 0,
          shortBreaks: 0,
          longBreaks: 0,
        ),
      ) {
    _loadStats();
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();

    state = DailyStats(
      focusedMinutes: prefs.getInt("focusedToday") ?? 0,
      completedCycles: prefs.getInt("completedCycles") ?? 0,
      shortBreaks: prefs.getInt("shortBreaks") ?? 0,
      longBreaks: prefs.getInt("longBreaks") ?? 0,
    );
  }

  Future<void> refresh() async {
    await _loadStats();
  }
}

/// Riverpod Provider for Daily Stats
final dailyStatsProvider =
    StateNotifierProvider<StatisticsNotifier, DailyStats>(
      (ref) => StatisticsNotifier(),
    );

/// ------------------------------------------------------------
/// 🟪 AI INSIGHTS MODEL — STATIC / ANALYTICAL DATA
/// ------------------------------------------------------------
class FocusStatistics {
  final TimeOfDay peakFocusStart;
  final TimeOfDay peakFocusEnd;
  final int shortBreakBoost;
  final int longestStreak;

  FocusStatistics({
    required this.peakFocusStart,
    required this.peakFocusEnd,
    required this.shortBreakBoost,
    required this.longestStreak,
  });
}

/// ------------------------------------------------------------
/// 🟪 STATIC INSIGHTS PROVIDER (NO CIRCULARITY)
/// ------------------------------------------------------------
final statisticsProvider = Provider<FocusStatistics>((ref) {
  return FocusStatistics(
    peakFocusStart: const TimeOfDay(hour: 16, minute: 0), // 4 PM
    peakFocusEnd: const TimeOfDay(hour: 19, minute: 0), // 7 PM
    shortBreakBoost: 9,
    longestStreak: 4,
  );
});
