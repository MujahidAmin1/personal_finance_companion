import 'package:hive_ce/hive.dart';
import 'package:personal_finance_companion_app/models/transaction.dart';
import '../../../models/goal.dart';

class GoalRepository {
  static const _boxName = 'goals';

  Box<Goal> get _box => Hive.box<Goal>(_boxName);

  static Future<void> init() async {
    await Hive.openBox<Goal>(_boxName);
  }

  // ── Write ──────────────────────────────────────────────

  Future<void> add(Goal goal) async {
    await _box.put(goal.id, goal);
  }

  Future<void> update(Goal goal) async {
    await _box.put(goal.id, goal);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Future<void> contribute(String id, double amount) async {
    final goal = _box.get(id);
    if (goal == null) return;
    final updated = goal.copyWith(
      savedAmount: (goal.savedAmount + amount).clamp(0, goal.targetAmount),
    );
    await _box.put(id, updated);
  }

  // ── Read ───────────────────────────────────────────────

  List<Goal> getAll() {
    return _box.values.toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
  }

  Goal? getById(String id) => _box.get(id);

  List<Goal> getActive() {
    final now = DateTime.now();
    return _box.values
        .where((g) => now.isBefore(g.endDate) && !g.isCompleted)
        .toList()
      ..sort((a, b) => a.endDate.compareTo(b.endDate));
  }

  List<Goal> getCompleted() {
    return _box.values.where((g) => g.isCompleted).toList()
      ..sort((a, b) => b.endDate.compareTo(a.endDate));
  }

  Goal? getActiveForMonth(int year, int month) {
    return _box.values.firstWhere(
      (g) =>
          g.startDate.year == year &&
          g.startDate.month == month &&
          g.isActive,
      orElse: () => throw StateError('No active goal for $month/$year'),
    );
  }

  // ── Category budget helpers ────────────────────────────

  /// Returns the budget limit for a category in a given goal.
  /// Returns null if no budget is set for that category.
  double? getBudgetForCategory(String goalId, TransactionCategory category) {
    final goal = _box.get(goalId);
    if (goal == null) return null;
    try {
      return goal.categoryBudgets
          .firstWhere((b) => b.category == category.name)
          .limit;
    } catch (_) {
      return null;
    }
  }

  Future<void> updateCategoryBudget(
    String goalId,
    String category,
    double newLimit,
  ) async {
    final goal = _box.get(goalId);
    if (goal == null) return;

    final updatedBudgets = goal.categoryBudgets.map((b) {
      return b.category == category ? b.copyWith(limit: newLimit) : b;
    }).toList();

    // Add new category if it didn't exist
    final exists = goal.categoryBudgets.any((b) => b.category == category);
    if (!exists) {
      updatedBudgets.add(CategoryBudget(category: category, limit: newLimit));
    }

    await _box.put(goalId, goal.copyWith(categoryBudgets: updatedBudgets));
  }

  // ── Stream ─────────────────────────────────────────────

  Stream<BoxEvent> watch() => _box.watch();
}