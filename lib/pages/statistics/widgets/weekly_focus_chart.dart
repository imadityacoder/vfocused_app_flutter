import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vfocused_app/core/constants.dart';

class WeeklyFocusChart extends StatelessWidget {
  const WeeklyFocusChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neonPurple.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          // -------------------------
          // THE ACTUAL CHART
          // -------------------------
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ["M", "T", "W", "T", "F", "S", "S"];
                        return Text(
                          days[value.toInt()],
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget:
                          (value, _) => Text(
                            "${value.toInt()}m",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white70,
                            ),
                          ),
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: AppColors.neonGreen,
                    dotData: const FlDotData(show: true),
                    spots: const [
                      FlSpot(0, 20),
                      FlSpot(1, 32),
                      FlSpot(2, 45),
                      FlSpot(3, 52),
                      FlSpot(4, 61),
                      FlSpot(5, 73),
                      FlSpot(6, 85),
                    ],
                  ),
                  LineChartBarData(
                    isCurved: true,
                    color: AppColors.neonBlue,
                    dotData: const FlDotData(show: true),
                    spots: const [
                      FlSpot(0, 18),
                      FlSpot(1, 28),
                      FlSpot(2, 35),
                      FlSpot(3, 33),
                      FlSpot(4, 47),
                      FlSpot(5, 55),
                      FlSpot(6, 68),
                    ],
                  ),
                  LineChartBarData(
                    isCurved: true,
                    color: AppColors.neonPink,
                    dotData: const FlDotData(show: true),
                    spots: const [
                      FlSpot(0, 25),
                      FlSpot(1, 40),
                      FlSpot(2, 58),
                      FlSpot(3, 72),
                      FlSpot(4, 65),
                      FlSpot(5, 60),
                      FlSpot(6, 50),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // -------------------------
          // LEGEND
          // -------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _LegendDot(color: AppColors.neonGreen, label: "Focus Time"),
              _LegendDot(color: AppColors.neonBlue, label: "Break Quality"),
              _LegendDot(color: AppColors.neonPink, label: "Deep Work"),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
