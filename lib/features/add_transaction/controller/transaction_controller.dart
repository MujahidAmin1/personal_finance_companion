import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance_companion_app/features/add_transaction/repo/transaction_repo.dart';
import '../../../models/transaction.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository();
});

class TransactionState {
  final List<Transaction> transactions;
  final String searchQuery;
  final TransactionCategory? selectedCategory;
  final TransactionType? selectedType;

  const TransactionState({
    this.transactions = const [],
    this.searchQuery = '',
    this.selectedCategory,
    this.selectedType,
  });

  List<Transaction> get filtered {
    var list = transactions;

    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list
          .where((t) =>
              t.title.toLowerCase().contains(q) ||
              (t.notes?.toLowerCase().contains(q) ?? false))
          .toList();
    }

    if (selectedCategory != null) {
      list = list.where((t) => t.category == selectedCategory).toList();
    }

    if (selectedType != null) {
      list = list.where((t) => t.type == selectedType).toList();
    }

    return list;
  }

  TransactionState copyWith({
    List<Transaction>? transactions,
    String? searchQuery,
    TransactionCategory? selectedCategory,
    TransactionType? selectedType,
    bool clearCategory = false,
    bool clearType = false,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      selectedType: clearType ? null : (selectedType ?? this.selectedType),
    );
  }
}

class TransactionController extends Notifier<TransactionState> {
  TransactionRepository get _repo => ref.read(transactionRepositoryProvider);

  @override
  TransactionState build() {
    final sub = _repo.watch().listen((_) {
      state = state.copyWith(transactions: _repo.getAll());
    });
    ref.onDispose(sub.cancel);

    return TransactionState(transactions: _repo.getAll());
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _repo.add(transaction);
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _repo.update(transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _repo.delete(id);
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void filterByCategory(TransactionCategory category) {
    if (state.selectedCategory == category) {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(selectedCategory: category);
    }
  }

  void filterByType(TransactionType type) {
    if (state.selectedType == type) {
      state = state.copyWith(clearType: true);
    } else {
      state = state.copyWith(selectedType: type);
    }
  }

  void clearFilters() {
    state = state.copyWith(
      searchQuery: '',
      clearCategory: true,
      clearType: true,
    );
  }

  double get balance => _repo.getBalance();
  double get totalIncome => _repo.getTotalIncome();
  double get totalExpenses => _repo.getTotalExpenses();

  List<double> getWeeklyExpenses(DateTime weekStart) {
    return _repo.getWeeklyExpenses(weekStart);
  }

  List<double> getMonthlyTrend({int months = 6}) {
    return _repo.getMonthlyTrend(months: months);
  }

  Map<TransactionCategory, double> getMonthlySpendingByCategory(
      int year, int month) {
    return _repo.getMonthlySpendingByCategory(year, month);
  }

  double getSpentByCategory(
    TransactionCategory category, {
    int? year,
    int? month,
  }) {
    return _repo.getSpentByCategory(category, year: year, month: month);
  }

  List<Transaction> getByMonth(int year, int month) {
    return _repo.getByMonth(year, month);
  }
}

final transactionControllerProvider =
    NotifierProvider<TransactionController, TransactionState>(
  TransactionController.new,
);


// for convenience
final allTransactionsProvider = Provider<List<Transaction>>((ref) {
  return ref.watch(transactionControllerProvider).transactions;
});

final filteredTransactionsProvider = Provider<List<Transaction>>((ref) {
  return ref.watch(transactionControllerProvider).filtered;
});

final balanceProvider = Provider<double>((ref) {
  ref.watch(transactionControllerProvider);
  return ref.read(transactionControllerProvider.notifier).balance;
});

final totalIncomeProvider = Provider<double>((ref) {
  ref.watch(transactionControllerProvider);
  return ref.read(transactionControllerProvider.notifier).totalIncome;
});

final totalExpensesProvider = Provider<double>((ref) {
  ref.watch(transactionControllerProvider);
  return ref.read(transactionControllerProvider.notifier).totalExpenses;
});