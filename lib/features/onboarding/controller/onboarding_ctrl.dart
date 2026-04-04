import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:personal_finance_companion_app/core/boxes/hive_boxes.dart';
import 'package:personal_finance_companion_app/features/add_transaction/controller/transaction_controller.dart';
import 'package:personal_finance_companion_app/models/transaction.dart';

final onboardingControllerProvider = Provider((ref) => OnboardingController(ref));

class OnboardingController {
  final Ref ref;
  OnboardingController(this.ref);

  bool get isFirstTime {
    final box = Hive.box(MyHiveBoxes.userSettingsBox);
    return box.get('userName') == null;
  }

  String get userName {
    final box = Hive.box(MyHiveBoxes.userSettingsBox);
    return box.get('userName', defaultValue: '') as String;
  }

  void saveSetup(String name, double initialBalance) {
    final box = Hive.box(MyHiveBoxes.userSettingsBox);
    box.put('userName', name);

    if (initialBalance > 0) {
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Initial Balance',
        amount: initialBalance,
        type: TransactionType.income,
        category: TransactionCategory.others,
        date: DateTime.now(),
        notes: 'Account seeded',
      );
      ref.read(transactionControllerProvider.notifier).addTransaction(transaction);
    }
  }
}
