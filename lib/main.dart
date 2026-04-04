import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:personal_finance_companion_app/core/appcolors.dart';
import 'package:personal_finance_companion_app/features/add_transaction/repo/transaction_repo.dart';
import 'package:personal_finance_companion_app/features/goals/repo/goals_repo.dart';
import 'package:personal_finance_companion_app/features/onboarding/onboarding_screen.dart';
import 'package:personal_finance_companion_app/hive_registrar.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapters();
  await TransactionRepository.init();
  await GoalRepository.init();
  await Hive.openBox('settings');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finsight',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.neutral),
      ),
      home: const OnboardingScreen(),
    );
  }
}
