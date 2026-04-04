import 'package:flutter/material.dart';
import 'package:personal_finance_companion_app/core/appcolors.dart';

class InsightTopCategoryCard extends StatelessWidget {
  final String categoryName;
  final double percentage;

  const InsightTopCategoryCard({super.key, required this.categoryName, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.tertiary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shopping_bag, color: AppColors.primary, size: 24),
          const SizedBox(height: 16),
          const Text('Top Category', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 4),
          const Text('Most of your spending is directed here.', style: TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(categoryName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
              Text('${percentage.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
        ],
      ),
    );
  }
}
