import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_companion_app/models/transaction.dart';
import 'package:personal_finance_companion_app/core/appcolors.dart';

class TransactionReceiptWidget extends StatelessWidget {
  final Transaction transaction;

  const TransactionReceiptWidget({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final isExpense = transaction.type == TransactionType.expense;
    final color = isExpense ? Colors.red : Colors.green;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, color: Colors.white, size: 28),
                SizedBox(width: 8),
                Text('Transaction Receipt', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(formatter.format(transaction.amount), style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: color)),
                const SizedBox(height: 8),
                Text(transaction.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
                const SizedBox(height: 24),
                const Divider(color: Colors.grey, thickness: 0.5, height: 1),
                const SizedBox(height: 24),
                _buildRow('Status', 'Completed', Icons.check_circle, Colors.green),
                const SizedBox(height: 16),
                _buildRow('Category', transaction.category.name[0].toUpperCase() + transaction.category.name.substring(1), Icons.category, Colors.grey.shade700),
                const SizedBox(height: 16),
                _buildRow('Date', DateFormat('MMM dd, yyyy').format(transaction.date), Icons.calendar_today, Colors.grey.shade700),
                const SizedBox(height: 16),
                _buildRow('Time', DateFormat('hh:mm a').format(transaction.date), Icons.access_time, Colors.grey.shade700),
                const SizedBox(height: 24),
                const Divider(color: Colors.grey, thickness: 0.5, height: 1),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.notes, size: 18, color: Colors.grey.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Notes', style: TextStyle(fontSize: 14, color: Colors.black54)),
                          const SizedBox(height: 4),
                          Text(
                            transaction.notes ?? 'No notes added.',
                            style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, IconData icon, Color iconColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          ],
        ),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }
}
