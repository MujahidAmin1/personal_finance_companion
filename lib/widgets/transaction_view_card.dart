import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_companion_app/features/transaction_history/transaction_detail_screen.dart';
import '../models/transaction.dart';

class TransactionViewCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionViewCard({super.key, required this.transaction});

  static IconData _getIcon(TransactionCategory category) {
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
    final isExpense = transaction.type == TransactionType.expense;
    final prefix = isExpense ? '-' : '+';
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final displayAmount = '$prefix${formatter.format(transaction.amount)}';

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => TransactionDetailScreen(transaction: transaction)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6FC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(_getIcon(transaction.category), color: const Color(0xFF1F2937), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    transaction.notes ?? transaction.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1F2937)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${transaction.category.name.toUpperCase()} • ${DateFormat('MMM d').format(transaction.date).toUpperCase()}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6B7280), letterSpacing: 0.5),
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
      ),
    );
  }
}
