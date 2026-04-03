import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance_companion_app/models/transaction.dart';
import '../../../models/goal.dart';
import '../repo/goals_repo.dart';

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  return GoalRepository();
});

class GoalState {
  final List<Goal> goals;

  const GoalState({
    this.goals = const [],
  });

  GoalState copyWith({
    List<Goal>? goals,
  }) {
    return GoalState(
      goals: goals ?? this.goals,
    );
  }
}

class GoalController extends Notifier<GoalState> {
  GoalRepository get _repo => ref.read(goalRepositoryProvider);

  @override
  GoalState build() {
    final sub = _repo.watch().listen((_) {
      state = state.copyWith(goals: _repo.getAll());
    });
    ref.onDispose(sub.cancel);

    return GoalState(goals: _repo.getAll());
  }

  Future<void> addGoal(Goal goal) async {
    await _repo.add(goal);
  }

  Future<void> updateGoal(Goal goal) async {
    await _repo.update(goal);
  }

  Future<void> deleteGoal(String id) async {
    await _repo.delete(id);
  }

  Future<void> contribute(String id, double amount) async {
    await _repo.contribute(id, amount);
  }

  Future<void> updateCategoryBudget(
    String goalId,
    String category,
    double newLimit,
  ) async {
    await _repo.updateCategoryBudget(goalId, category, newLimit);
  }

  List<Goal> getActive() {
    return _repo.getActive();
  }

  List<Goal> getCompleted() {
    return _repo.getCompleted();
  }

  Goal? getActiveForMonth(int year, int month) {
    try {
      return _repo.getActiveForMonth(year, month);
    } catch (e) {
      return null;
    }
  }

  double? getBudgetForCategory(String goalId, TransactionCategory category) {
    return _repo.getBudgetForCategory(goalId, category);
  }
}

final goalControllerProvider = NotifierProvider<GoalController, GoalState>(
  GoalController.new,
);

final allGoalsProvider = Provider<List<Goal>>((ref) {
  return ref.watch(goalControllerProvider).goals;
});

final activeGoalsProvider = Provider<List<Goal>>((ref) {
  ref.watch(goalControllerProvider);
  return ref.read(goalControllerProvider.notifier).getActive();
});

final completedGoalsProvider = Provider<List<Goal>>((ref) {
  ref.watch(goalControllerProvider);
  return ref.read(goalControllerProvider.notifier).getCompleted();
});
