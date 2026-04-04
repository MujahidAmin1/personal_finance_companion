import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_companion_app/core/appcolors.dart';
import '../../../models/transaction.dart';
import '../../../widgets/category_chip_card.dart';
import '../controller/transaction_controller.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  TransactionCategory? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final amountText = _amountController.text.replaceAll(',', '');
    final amount = double.tryParse(amountText) ?? 0.0;

    if (amount <= 0 || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount and select a category.')),
      );
      return;
    }

    final categoryName = _selectedCategory!.name;
    final title = categoryName[0].toUpperCase() + categoryName.substring(1);

    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      type: _selectedType,
      category: _selectedCategory!,
      date: _selectedDate,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    await ref.read(transactionControllerProvider.notifier).addTransaction(transaction);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF1F2937)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Transaction',
          style: TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'AMOUNT',
                style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1.2),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text(
                    '\$',
                    style: TextStyle(fontSize: 42, fontWeight: FontWeight.w300, color: Color(0xFF97A6F6)),
                  ),
                  const SizedBox(width: 8),
                  IntrinsicWidth(
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w300, color: Color(0xFFC0CAFE)),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Enter amount';
                        if (double.tryParse(value.replaceAll(',', '')) == null) return 'Invalid';
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: '0.00',
                        hintStyle: TextStyle(color: Color(0xFFDCE2FF)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F5FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    _buildTypeToggle('Expense', TransactionType.expense, Colors.red),
                    _buildTypeToggle('Income', TransactionType.income, Colors.green),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              if (_selectedType != TransactionType.income) ...[
                const Text(
                  'Select Category',
                  style: TextStyle(color: Color(0xFF4B5563), fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 24,
                  alignment: WrapAlignment.spaceBetween,
                  children: TransactionCategory.values.map((category) {
                    final isSelected = _selectedCategory == category;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = category),
                      child: Container(
                        decoration: isSelected
                            ? BoxDecoration(borderRadius: BorderRadius.circular(20))
                            : null,
                        child: CategoryIconWidget(category: category, isSelected: isSelected),
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6FC),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TRANSACTION DATE',
                      style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF), fontWeight: FontWeight.w600, letterSpacing: 0.8),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) setState(() => _selectedDate = date);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('MM/dd/yyyy').format(_selectedDate),
                              style: const TextStyle(fontSize: 16, color: Color(0xFF1F2937), fontWeight: FontWeight.w500),
                            ),
                            const Icon(Icons.calendar_today_outlined, color: Color(0xFF1F2937), size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'NOTES',
                      style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF), fontWeight: FontWeight.w600, letterSpacing: 0.8),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextFormField(
                        controller: _notesController,
                        maxLines: 4,
                        style: const TextStyle(color: Color(0xFF1F2937)),
                        decoration: const InputDecoration(
                          hintText: 'Add a note about this\ntransaction...',
                          hintStyle: TextStyle(color: Color(0xFFD1D5DB), fontSize: 15),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 4,
                  shadowColor: const Color(0xFF5C4FF2).withValues(alpha: 0.5),
                ),
                child: const Text(
                  'Confirm Transaction',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeToggle(String label, TransactionType type, Color activeColor) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 2))]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.neutral : const Color(0xFF9CA3AF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
