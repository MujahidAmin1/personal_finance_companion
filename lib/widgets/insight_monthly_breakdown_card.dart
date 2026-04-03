import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_companion_app/core/appcolors.dart';
import 'package:personal_finance_companion_app/models/transaction.dart';

class InsightMonthlyBreakdownCard extends StatelessWidget {
  final Map<TransactionCategory, double> categorySpending;
  final double totalSpent;

  const InsightMonthlyBreakdownCard({
    super.key,
    required this.categorySpending,
    required this.totalSpent,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final sorted = categorySpending.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final top4 = sorted.take(4).toList();
    
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.tertiary,
      Colors.grey[300]!,
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.neutral,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Monthly Breakdown', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 12),
          const Text(
            'Your spending habits show a significant lean towards lifestyle choices this month. Essential costs remain stable at 35% of your total outflow.',
            style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.5),
          ),
          const SizedBox(height: 24),
          ...List.generate(top4.length, (index) {
            final entry = top4[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  CircleAvatar(radius: 4, backgroundColor: colors[index % colors.length]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.key.name[0].toUpperCase() + entry.key.name.substring(1),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                  ),
                  Text(
                    formatter.format(entry.value),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 32),
          Center(
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[200]!, width: 8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('TOTAL SPENT', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 1.0)),
                  const SizedBox(height: 4),
                  Text(formatter.format(totalSpent), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
