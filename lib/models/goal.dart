

import 'package:hive_ce/hive.dart';

part 'goal.g.dart';

@HiveType(typeId: 3)
class CategoryBudget extends HiveObject {
  @HiveField(0)
  final String category; // matches TransactionCategory.name

  @HiveField(1)
  final double limit;

  CategoryBudget({
    required this.category,
    required this.limit,
  });

  CategoryBudget copyWith({
    String? category,
    double? limit,
  }) {
    return CategoryBudget(
      category: category ?? this.category,
      limit: limit ?? this.limit,
    );
  }
}

@HiveType(typeId: 4)
class Goal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double targetAmount;

  @HiveField(3)
  final double savedAmount;

  @HiveField(4)
  final DateTime startDate;

  @HiveField(5)
  final DateTime endDate;

  @HiveField(6)
  final List<CategoryBudget> categoryBudgets;

  Goal({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.startDate,
    required this.endDate,
    required this.categoryBudgets,
  });

  double get progress => savedAmount / targetAmount;

  bool get isCompleted => savedAmount >= targetAmount;

  bool get isActive => DateTime.now().isBefore(endDate);

  Goal copyWith({
    String? id,
    String? title,
    double? targetAmount,
    double? savedAmount,
    DateTime? startDate,
    DateTime? endDate,
    List<CategoryBudget>? categoryBudgets,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      categoryBudgets: categoryBudgets ?? this.categoryBudgets,
    );
  }
}