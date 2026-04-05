import 'package:intl/intl.dart';

import 'package:flutter/services.dart';

class ThousandsFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,##0');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
  
    String digitsOnly = newValue.text.replaceAll(',', '');

 
    if (digitsOnly.isEmpty) {
      return newValue.copyWith(text: '');
    }

  
    final number = int.tryParse(digitsOnly);
    if (number == null) return oldValue;

    final newText = _formatter.format(number);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}