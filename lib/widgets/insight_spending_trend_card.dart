import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance_companion_app/core/appcolors.dart';

class InsightSpendingTrendCard extends StatelessWidget {
  final List<double> weeklyData;
  const InsightSpendingTrendCard({super.key, required this.weeklyData});

  @override
  Widget build(BuildContext context) {
    final maxY = weeklyData.isEmpty ? 10.0 : (weeklyData.reduce((a, b) => a > b ? a : b) * 1.2).clamp(1.0, double.infinity);
    final spots = List.generate(
      weeklyData.length,
      (i) => FlSpot(i.toDouble(), weeklyData[i]),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Spending Trend', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                SizedBox(height: 4),
                Text('Visualizing your cash outflow\nover 30 days', style: TextStyle(fontSize: 10, color: Colors.black54)),
              ],
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
              child: const Text('WEEKLY', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 120,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: (weeklyData.length - 1).toDouble().clamp(1, double.infinity),
              minY: 0,
              maxY: maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: spots.isEmpty ? [const FlSpot(0, 0)] : spots,
                  isCurved: true,
                  color: AppColors.primary,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.3),
                        AppColors.primary.withValues(alpha: 0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
              .map((d) => Text(d, style: const TextStyle(fontSize: 8, color: Colors.black54)))
              .toList(),
        ),
      ],
    );
  }
}
