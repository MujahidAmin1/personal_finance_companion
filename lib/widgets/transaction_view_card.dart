import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionViewCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionViewCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    IconData getIcon(TransactionCategory category) {
      switch (category) {
        case TransactionCategory.food:
          return Icons.restaurant;
        case TransactionCategory.transport:
          return Icons.directions_car;
        case TransactionCategory.shopping:
          return Icons.shopping_bag;
        case TransactionCategory.health:
          return Icons.favorite;
        case TransactionCategory.entertainment:
          return Icons.movie;
        case TransactionCategory.bills:
          return Icons.receipt;
        case TransactionCategory.savings:
          return Icons.account_balance_wallet;
        case TransactionCategory.others:
          return Icons.category_rounded;
      }
    }

    final isExpense = transaction.type == TransactionType.expense;
    final amountPrefix = isExpense ? '-' : '+';
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final formattedAmount = formatter.format(transaction.amount);
    // formattedAmount will have $ already, e.g. $12.50
    // so we combine amountPrefix with formattedAmount
    final displayAmount = '$amountPrefix$formattedAmount';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6FC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              getIcon(transaction.category),
              color: const Color(0xFF1F2937),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${transaction.category.name.toUpperCase()} • ${DateFormat('MMM d').format(transaction.date).toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Text(
            displayAmount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isExpense ? const Color(0xFF1F2937) : const Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }
}
