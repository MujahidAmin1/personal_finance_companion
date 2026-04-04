import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_companion_app/core/appcolors.dart';

class InsightWeeklyShiftCard extends StatelessWidget {
  final double shiftAmount;

  const InsightWeeklyShiftCard({super.key, required this.shiftAmount});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final isLess = shiftAmount <= 0;
    final color = isLess ? const Color(0xFF059669) : const Color(0xFFDC2626);
    final icon = isLess ? Icons.trending_down : Icons.trending_up;
    final text = isLess ? 'LESS THAN LAST WEEK' : 'MORE THAN LAST WEEK';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 16),
          const Text('Weekly Shift', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 4),
          const Text('How you compare to the previous 7 days.', style: TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 16),
          Text(
            '${isLess ? '-' : '+'}${formatter.format(shiftAmount.abs())}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 1.0)),
        ],
      ),
    );
  }
}
