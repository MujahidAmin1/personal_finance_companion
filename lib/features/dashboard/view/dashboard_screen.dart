import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance_companion_app/core/appcolors.dart';
import 'package:personal_finance_companion_app/core/knavigate.dart';
import 'package:personal_finance_companion_app/core/ktextStyle.dart';
import 'package:personal_finance_companion_app/features/add_transaction/controller/transaction_controller.dart';
import 'package:personal_finance_companion_app/features/add_transaction/view/add_transaction_screen.dart';
import 'package:personal_finance_companion_app/widgets/balance_card_widget.dart';
import 'package:personal_finance_companion_app/widgets/transaction_view_card.dart';
import 'package:personal_finance_companion_app/features/onboarding/controller/onboarding_ctrl.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var allTransactions = ref.watch(allTransactionsProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.black87,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
            SizedBox(width: 12),
            Text(
              'Finsight',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome, ${ref.watch(onboardingControllerProvider).userName}", style: kTextStyle(fontSize: 17)),
            BalanceCard(
              totalBalance: ref.watch(balanceProvider),
              income: ref.watch(totalIncomeProvider),
              expenses: ref.watch(totalExpensesProvider),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Transactions",
                  style: kTextStyle(fontSize: 20, isBold: true),
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    "View All",
                    style: kTextStyle(fontColor: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: allTransactions.isEmpty
                  ? Center(
                      child: Text(
                        "No transactions yet. Add one!",
                        style: kTextStyle(fontColor: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: allTransactions.length > 6 ? 6 : allTransactions.length,
                      itemBuilder: (context, index) {
                        return TransactionViewCard(
                          transaction: allTransactions[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add),
        onPressed: () => context.push(AddTransactionScreen()),
      ),
    );
  }
}
