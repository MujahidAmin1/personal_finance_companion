String formatCurrency(double amount) {
    final formatted = amount.abs().toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+\.)'),
          (m) => '${m[1]},',
        );
    return '\$${amount < 0 ? '-' : ''}$formatted';
  }