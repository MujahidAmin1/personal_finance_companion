import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_companion_app/core/appcolors.dart';

class InsightWeeklyComparisonCard extends StatelessWidget {
  final double thisWeek;
  final double lastWeek;
  final double percentageDiff;

  const InsightWeeklyComparisonCard({
    super.key,
    required this.thisWeek,
    required this.lastWeek,
    required this.percentageDiff,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final isLower = percentageDiff <= 0;
    final color = isLower ? const Color(0xFF059669) : const Color(0xFFDC2626);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.neutral,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.balance, color: Color(0xFF064E3B), size: 24),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Weekly Comparison', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                    SizedBox(height: 4),
                    Text('Your spending is 12% lower than your 3-month average.', style: TextStyle(fontSize: 10, color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('THIS WEEK', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 1.0)),
                  const SizedBox(height: 4),
                  Text(formatter.format(thisWeek), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('LAST WEEK', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 1.0)),
                  const SizedBox(height: 4),
                  Text(formatter.format(lastWeek), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54)),
                ],
              ),
              Text(
                '${isLower ? '↓' : '↑'} ${percentageDiff.abs().toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
