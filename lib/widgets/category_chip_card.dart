import 'package:flutter/material.dart';
import '../models/transaction.dart';

class CategoryIconWidget extends StatelessWidget {
  final TransactionCategory category;
  final double size;
  final bool isSelected;

  const CategoryIconWidget({
    super.key,
    required this.category,
    this.size = 64,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _categoryConfig[category]!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isSelected ? config.color : Colors.white,
            borderRadius: BorderRadius.circular(size * 0.28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              config.icon,
              color: isSelected ? Colors.white : config.color,
              size: size * 0.45,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          config.label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}

class _CategoryConfig {
  final IconData icon;
  final Color color;
  final String label;

  const _CategoryConfig({
    required this.icon,
    required this.color,
    required this.label,
  });
}

const _categoryConfig = <TransactionCategory, _CategoryConfig>{
  TransactionCategory.food: _CategoryConfig(
    icon: Icons.restaurant,
    color: Color(0xFFF97316),
    label: 'Food',
  ),
  TransactionCategory.transport: _CategoryConfig(
    icon: Icons.directions_car,
    color: Color(0xFF3B82F6),
    label: 'Transport',
  ),
  TransactionCategory.shopping: _CategoryConfig(
    icon: Icons.shopping_bag,
    color: Color(0xFFEC4899),
    label: 'Shopping',
  ),
  TransactionCategory.health: _CategoryConfig(
    icon: Icons.favorite,
    color: Color(0xFF10B981),
    label: 'Health',
  ),
  TransactionCategory.entertainment: _CategoryConfig(
    icon: Icons.movie,
    color: Color(0xFF8B5CF6),
    label: 'Entertainment',
  ),
  TransactionCategory.bills: _CategoryConfig(
    icon: Icons.receipt,
    color: Color(0xFFF59E0B),
    label: 'Bills',
  ),
  TransactionCategory.savings: _CategoryConfig(
    icon: Icons.account_balance_wallet,
    color: Color(0xFF06B6D4),
    label: 'Savings',
  ),
  TransactionCategory.others: _CategoryConfig(
    icon: Icons.category,
    color: Color(0xFF6B7280),
    label: 'Others',
  ),
};