import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_companion_app/features/add_transaction/controller/transaction_controller.dart';
import 'package:personal_finance_companion_app/widgets/insight_top_category_card.dart';
import 'package:personal_finance_companion_app/widgets/insight_weekly_shift_card.dart';
import 'package:personal_finance_companion_app/widgets/insight_monthly_breakdown_card.dart';
import 'package:personal_finance_companion_app/widgets/insight_spending_trend_card.dart';
import 'package:personal_finance_companion_app/widgets/insight_weekly_comparison_card.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(transactionControllerProvider);
    final controller = ref.read(transactionControllerProvider.notifier);
    final now = DateTime.now();

    final thisMonthSpending = controller.getMonthlySpendingByCategory(now.year, now.month);
    final totalMonthSpent = thisMonthSpending.values.fold(0.0, (sum, val) => sum + val);

    final weekStart = now.subtract(Duration(days: now.weekday % 7));
    final thisWeekData = controller.getWeeklyExpenses(weekStart);
    final thisWeekSpent = thisWeekData.fold<double>(0.0, (sum, val) => sum + val);

    final lastWeekStart = weekStart.subtract(const Duration(days: 7));
    final lastWeekSpent = controller.getWeeklyExpenses(lastWeekStart).fold<double>(0.0, (sum, val) => sum + val);

    String topCategoryName = 'None';
    double topCategoryPercent = 0.0;
    if (thisMonthSpending.isNotEmpty) {
      final sorted = thisMonthSpending.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
      final top = sorted.first;
      topCategoryName = top.key.name[0].toUpperCase() + top.key.name.substring(1);
      topCategoryPercent = (top.value / totalMonthSpent) * 100;
    }

    final weeklyShift = thisWeekSpent - lastWeekSpent;
    final diffPercent = lastWeekSpent > 0 ? (weeklyShift / lastWeekSpent) * 100 : 0.0;

    return Scaffold(
      backgroundColor: Colors.white,
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
            Text('Finsight', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 25)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Text(
              '${DateFormat('MMMM').format(now).toUpperCase()} ANALYSIS',
              style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.black54, letterSpacing: 1.2),
            ),
            const SizedBox(height: 8),
            const Text(
              'Financial Insights',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.black87, height: 1.1),
            ),
            const SizedBox(height: 32),
            InsightTopCategoryCard(categoryName: topCategoryName, percentage: topCategoryPercent),
            const SizedBox(height: 24),
            InsightWeeklyShiftCard(shiftAmount: weeklyShift),
            const SizedBox(height: 32),
            InsightMonthlyBreakdownCard(categorySpending: thisMonthSpending, totalSpent: totalMonthSpent),
            const SizedBox(height: 48),
            InsightSpendingTrendCard(weeklyData: thisWeekData),
            const SizedBox(height: 32),
            InsightWeeklyComparisonCard(thisWeek: thisWeekSpent, lastWeek: lastWeekSpent, percentageDiff: diffPercent),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
