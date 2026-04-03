import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_companion_app/core/appcolors.dart';
import 'package:personal_finance_companion_app/features/goals/controller/goals_controller.dart';
import 'package:personal_finance_companion_app/models/goal.dart';
import 'create_goal_screen.dart';

class GoalView extends ConsumerWidget {
  const GoalView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeGoals = ref.watch(activeGoalsProvider);
    Goal? primaryGoal;
    List<Goal> secondaryGoals = [];

    if (activeGoals.isNotEmpty) {
      primaryGoal = activeGoals.first;
      if (activeGoals.length > 1) {
        secondaryGoals = activeGoals.sublist(1);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.neutral,
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
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Text(
              'Savings Goals',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.black87),
            ),
            SizedBox(height: 8),
            Text(
              'Tracking your progress toward a brighter future.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            SizedBox(height: 32),
            if (primaryGoal != null) _buildPrimaryGoal(context, ref, primaryGoal),
            if (primaryGoal != null) SizedBox(height: 24),
            if (secondaryGoals.isNotEmpty) SizedBox(height: 24),
            ...secondaryGoals.map((g) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _buildSecondaryGoal(g),
            )),
            SizedBox(height: 32),
            _buildEmptyState(context),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryGoal(BuildContext context, WidgetRef ref, Goal goal) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final percent = (goal.progress * 100).toInt().clamp(0, 100);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'MONTHLY SAVINGS\nGOAL',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.black54, letterSpacing: 1.2),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$percent% COMPLETE',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.black87),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            goal.title,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.black87, height: 1.1),
          ),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TARGET AMOUNT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.black54, letterSpacing: 1.0)),
                  SizedBox(height: 4),
                  Text(formatter.format(goal.targetAmount), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black87)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CURRENT SAVED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.black54, letterSpacing: 1.0)),
                  SizedBox(height: 4),
                  Text(formatter.format(goal.savedAmount), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primary)),
                ],
              ),
            ],
          ),
          SizedBox(height: 24),
          Stack(
            children: [
              Container(
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              FractionallySizedBox(
                widthFactor: goal.progress.clamp(0.0, 1.0),
                child: Container(
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            '"You are $percent% there! Almost to your ${goal.title.toLowerCase()} goal."',
            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showAddFundsDialog(context, ref, goal),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text('Add\nFunds', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white, height: 1.2)),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showEditGoalDialog(context, ref, goal),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text('Edit\nGoal', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87, height: 1.2)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddFundsDialog(BuildContext context, WidgetRef ref, Goal goal) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Funds', style: TextStyle(color: Colors.black87)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Amount',
            prefixText: '\$ ',
            filled: true,
            fillColor: AppColors.neutral,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text) ?? 0.0;
              if (amount > 0) {
                ref.read(goalControllerProvider.notifier).contribute(goal.id, amount);
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditGoalDialog(BuildContext context, WidgetRef ref, Goal goal) {
    final titleController = TextEditingController(text: goal.title);
    final targetController = TextEditingController(text: goal.targetAmount.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit Goal', style: TextStyle(color: Colors.black87)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Goal Title',
                filled: true,
                fillColor: AppColors.neutral,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: targetController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                label: Text("Target"),
                prefixText: '\$ ',
                filled: true,
                fillColor: AppColors.neutral,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              final target = double.tryParse(targetController.text) ?? 0.0;
              if (title.isNotEmpty && target > 0) {
                ref.read(goalControllerProvider.notifier).updateGoal(
                  goal.copyWith(title: title, targetAmount: target),
                );
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryGoal(Goal goal) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(goal.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
          SizedBox(height: 4),
          Text('SECONDARY GOAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 1.0)),
          SizedBox(height: 24),
          Text(formatter.format(goal.savedAmount), style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.black87)),
          SizedBox(height: 4),
          Text('Saved so far', style: TextStyle(fontSize: 13, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: DashedRectPainter(color: Colors.grey[300]!),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 32),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                child: Icon(Icons.flag, color: Colors.grey[400], size: 32),
              ),
              SizedBox(height: 24),
              Text('No active goals yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87)),
              SizedBox(height: 12),
              Text(
                'Looking for a new challenge? Create a savings target to see your progress here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
              ),
              SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => CreateGoalScreen.show(context),
                icon: Icon(Icons.add, color: Colors.white, size: 20),
                label: Text('Create New Goal', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  elevation: 0,
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  DashedRectPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final rRect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(32));
    final path = Path()..addRRect(rRect);
    final dashedPath = _createDashedPath(path);
    canvas.drawPath(dashedPath, paint);
  }

  Path _createDashedPath(Path source) {
    final Path path = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double len = draw ? 10.0 : 8.0;
        if (draw) {
          path.addPath(metric.extractPath(distance, distance + len), Offset.zero);
        }
        distance += len;
        draw = !draw;
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
