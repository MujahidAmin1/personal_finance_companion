import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance_companion_app/core/appcolors.dart';

class InsightSpendingTrendCard extends StatelessWidget {
  final List<double> weeklyData;
  const InsightSpendingTrendCard({super.key, required this.weeklyData});

  @override
  Widget build(BuildContext context) {
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                  child: const Text('DAILY', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                  child: const Text('WEEKLY', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black87)),
                ),
              ],
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
              maxX: 4,
              minY: 0,
              maxY: 10,
              lineBarsData: [
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 3),
                    FlSpot(1, 5),
                    FlSpot(2, 3),
                    FlSpot(3, 8),
                    FlSpot(4, 2),
                  ],
                  isCurved: true,
                  color: AppColors.primary,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.3),
                        AppColors.primary.withOpacity(0.0),
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
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('OCT 1', style: TextStyle(fontSize: 8, color: Colors.black54)),
            Text('OCT 8', style: TextStyle(fontSize: 8, color: Colors.black54)),
            Text('OCT 15', style: TextStyle(fontSize: 8, color: Colors.black54)),
            Text('OCT 22', style: TextStyle(fontSize: 8, color: Colors.black54)),
            Text('OCT 29', style: TextStyle(fontSize: 8, color: Colors.black54)),
          ],
        ),
      ],
    );
  }
}
