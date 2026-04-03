import 'package:hive_ce/hive.dart';

import '../../../models/transaction.dart';

class TransactionRepository {
  static const _boxName = 'transactions';

  Box<Transaction> get _box => Hive.box<Transaction>(_boxName);

  static Future<void> init() async {
    await Hive.openBox<Transaction>(_boxName);
  }

  // ── Write ──────────────────────────────────────────────

  Future<void> add(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  Future<void> update(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  // ── Read ───────────────────────────────────────────────

  List<Transaction> getAll() {
    return _box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Transaction? getById(String id) {
    return _box.get(id);
  }

  List<Transaction> getByType(TransactionType type) {
    return _box.values
        .where((t) => t.type == type)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<Transaction> getByCategory(TransactionCategory category) {
    return _box.values
        .where((t) => t.category == category)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<Transaction> getByDateRange(DateTime from, DateTime to) {
    return _box.values
        .where((t) => t.date.isAfter(from) && t.date.isBefore(to))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<Transaction> getByMonth(int year, int month) {
    return _box.values.where((t) {
      return t.date.year == year && t.date.month == month;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<Transaction> search(String query) {
    final q = query.toLowerCase();
    return _box.values
        .where((t) =>
            t.title.toLowerCase().contains(q) ||
            (t.notes?.toLowerCase().contains(q) ?? false))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // ── Aggregates ─────────────────────────────────────────

  double getTotalIncome() {
    return _box.values
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getTotalExpenses() {
    return _box.values
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getBalance() => getTotalIncome() - getTotalExpenses();

  double getSpentByCategory(TransactionCategory category, {int? year, int? month}) {
    return _box.values.where((t) {
      if (t.type != TransactionType.expense) return false;
      if (t.category != category) return false;
      if (year != null && t.date.year != year) return false;
      if (month != null && t.date.month != month) return false;
      return true;
    }).fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Returns a map of category → total spent for the given month.
  Map<TransactionCategory, double> getMonthlySpendingByCategory(int year, int month) {
    final result = <TransactionCategory, double>{};
    for (final t in _box.values) {
      if (t.type != TransactionType.expense) continue;
      if (t.date.year != year || t.date.month != month) continue;
      result[t.category] = (result[t.category] ?? 0.0) + t.amount;
    }
    return result;
  }

  /// Returns daily totals for a given week as a list of 7 doubles (Mon–Sun).
  List<double> getWeeklyExpenses(DateTime weekStart) {
    final totals = List<double>.filled(7, 0.0);
    for (final t in _box.values) {
      if (t.type != TransactionType.expense) continue;
      final diff = t.date.difference(weekStart).inDays;
      if (diff >= 0 && diff < 7) {
        totals[diff] += t.amount;
      }
    }
    return totals;
  }

  /// Returns monthly totals for the last [months] months as a list.
  List<double> getMonthlyTrend({int months = 6}) {
    final now = DateTime.now();
    return List.generate(months, (i) {
      final target = DateTime(now.year, now.month - (months - 1 - i));
      return _box.values.where((t) {
        return t.type == TransactionType.expense &&
            t.date.year == target.year &&
            t.date.month == target.month;
      }).fold(0.0, (sum, t) => sum + t.amount);
    });
  }

  // ── Stream ─────────────────────────────────────────────

  Stream<BoxEvent> watch() => _box.watch();
}