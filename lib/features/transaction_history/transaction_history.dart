import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance_companion_app/core/appcolors.dart';
import 'package:personal_finance_companion_app/features/add_transaction/controller/transaction_controller.dart';
import 'package:personal_finance_companion_app/models/transaction.dart';
import 'package:personal_finance_companion_app/widgets/transaction_view_card.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends ConsumerState<TransactionHistoryScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final allTransactions = ref.watch(allTransactionsProvider);

    final filteredTransactions = allTransactions.where((t) {
      if (_selectedFilter == 'Income' && t.type != TransactionType.income) return false;
      if (_selectedFilter == 'Expense' && t.type != TransactionType.expense) return false;
      return true;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    final grouped = <String, List<Transaction>>{};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (final t in filteredTransactions) {
      final date = DateTime(t.date.year, t.date.month, t.date.day);
      final key = date == today
          ? 'TODAY'
          : date == yesterday
              ? 'YESTERDAY'
              : 'EARLIER';
      grouped.putIfAbsent(key, () => []).add(t);
    }

    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.black87,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
            SizedBox(width: 12),
            Text('Transaction History', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                _buildFilterChip('All'),
                const SizedBox(width: 8),
                _buildFilterChip('Income'),
                const SizedBox(width: 8),
                _buildFilterChip('Expense'),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tune, color: Colors.black87, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: grouped.keys.length,
                itemBuilder: (context, index) {
                  final key = grouped.keys.elementAt(index);
                  final items = grouped[key]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          key,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.black54, letterSpacing: 1.2),
                        ),
                      ),
                      ...items.map((t) => Dismissible(
                            key: Key(t.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFB91C1C),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 24),
                              child: const Icon(Icons.delete, color: Colors.white, size: 32),
                            ),
                            onDismissed: (_) {
                              ref.read(transactionControllerProvider.notifier).deleteTransaction(t.id);
                            },
                            child: TransactionViewCard(transaction: t),
                          )),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? switch (label) {
                  'Expense' => Colors.red,
                  'Income' => Colors.green,
                  _ => Colors.deepPurpleAccent,
                }
              : AppColors.neutral,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : Colors.black87),
        ),
      ),
    );
  }
}
