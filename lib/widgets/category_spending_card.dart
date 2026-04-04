import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_companion_app/core/appcolors.dart';
import 'package:personal_finance_companion_app/models/transaction.dart';

class CategorySpendingCard extends StatelessWidget {
  final TransactionCategory category;
  final double amount;
  final double totalExpenses;

  const CategorySpendingCard({
    super.key,
    required this.category,
    required this.amount,
    required this.totalExpenses,
  });

  IconData _getIcon() {
    return switch (category) {
      TransactionCategory.food => Icons.restaurant,
      TransactionCategory.transport => Icons.directions_car,
      TransactionCategory.shopping => Icons.shopping_bag,
      TransactionCategory.health => Icons.favorite,
      TransactionCategory.entertainment => Icons.movie,
      TransactionCategory.bills => Icons.receipt,
      TransactionCategory.savings => Icons.account_balance_wallet,
      TransactionCategory.others => Icons.category_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final percentage = totalExpenses > 0 ? (amount / totalExpenses).clamp(0.0, 1.0) : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(_getIcon(), color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name.toUpperCase(),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatter.format(amount),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              Text(
                '${(percentage * 100).toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: AppColors.neutral,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
