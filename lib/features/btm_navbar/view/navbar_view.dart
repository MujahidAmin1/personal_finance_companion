import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance_companion_app/features/dashboard/view/dashboard_screen.dart';
import 'package:personal_finance_companion_app/features/goals/view/goal_view.dart';
import 'package:personal_finance_companion_app/features/insights/view/insights_screen.dart';
import 'package:personal_finance_companion_app/features/transaction_history/transaction_history.dart';
import 'package:personal_finance_companion_app/widgets/transaction_view_card.dart';

import '../controller/navbar_ctrl.dart';

class BtmNavBarScreen extends ConsumerWidget {
  const BtmNavBarScreen({super.key});

  @override
 
  Widget build(BuildContext context, WidgetRef ref) {
    var currentScreen = ref.watch(currentScreenProvider);
    List<Widget> screens = [
      DashboardScreen(),
      TransactionHistoryScreen(),
      GoalView(),
      InsightsScreen(),
    ];
    return Scaffold(
      body: IndexedStack(
        index: currentScreen,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentScreen ?? 0,
        onDestinationSelected: (value) {
          navigateTo(ref, value);
        },
        destinations: const [
           NavigationDestination(
            selectedIcon: Icon(Icons.home_filled),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
           NavigationDestination(
            selectedIcon: Icon(Icons.receipt_long),
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Transaction',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.hourglass_top_outlined),
            icon: Icon(Icons.hourglass_top),
            label: 'Goals',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.insights),
            icon: Icon(Icons.insights_outlined),
            label: 'Insights',
          ),
        ]
        ),
    );
  }
}


