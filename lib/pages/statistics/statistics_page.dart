import 'package:flutter/material.dart';
import 'package:vfocused_app/core/constants.dart';
import 'package:vfocused_app/pages/statistics/widgets/ai_insights.dart';
import 'package:vfocused_app/pages/statistics/widgets/comparison_section.dart';
import 'package:vfocused_app/pages/statistics/widgets/focus_break_pie_chart.dart';
import 'package:vfocused_app/pages/statistics/widgets/scroll_arrows.dart';
import 'package:vfocused_app/pages/statistics/widgets/summary_row.dart';
import 'package:vfocused_app/pages/statistics/widgets/weekly_focus_chart.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final ScrollController _chartScrollController = ScrollController();
  double scrollProgress = 0;

  @override
  void initState() {
    super.initState();
    _chartScrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _chartScrollController.position.maxScrollExtent;
    final position = _chartScrollController.position.pixels;
    setState(() {
      scrollProgress = maxScroll == 0 ? 0 : (position / maxScroll);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Statistics"),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              SummaryRow(), // ❌ removed const

              const SizedBox(height: 18),
              const Text(
                "This Week",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              SizedBox(
                height: 290,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      controller: _chartScrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      child: Row(
                        children: const [
                          WeeklyFocusChart(),
                          SizedBox(width: 16),

                          FocusBreakPieChart(),
                          // Right padding for clean scroll finish
                        ],
                      ),
                    ),

                    ScrollArrows(progress: scrollProgress),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              ComparisonSection(), // ❌ no const

              const SizedBox(height: 20),

              const Text(
                "A.I. Insights Report",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              AIInsights(),
            ],
          ),
        ),
      ),
    );
  }
}
