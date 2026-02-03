// lib/core/models/enums.dart

enum ExpenseCategory {
  food('food'),
  transportation('transportation'),
  shopping('marketing'),
  entertainment('entertainment'),
  health('health'),
  education('learn'),
  housing('living'),
  bills('bills'),
  salary('salary'),
  investment('investment'),
  gifts('gifts'),
  other('others');

  final String translationKey;
  const ExpenseCategory(this.translationKey);

  // Simple getter - NO translation here
  String get displayName => translationKey;

  // Convert from stored key
  static ExpenseCategory fromKey(String key) {
    return ExpenseCategory.values.firstWhere(
      (e) => e.translationKey == key,
      orElse: () => ExpenseCategory.other,
    );
  }

  // For backward compatibility (migration from Arabic)
  static ExpenseCategory fromString(String arabicName) {
    final Map<String, String> arabicToKey = {
      'طعام': 'food',
      'مواصلات': 'transportation',
      'تسوق': 'marketing',
      'ترفيه': 'entertainment',
      'صحة': 'health',
      'تعليم': 'learn',
      'سكن': 'living',
      'فواتير': 'bills',
      'مرتب': 'salary',
      'استثمار': 'investment',
      'هدايا': 'gifts',
      'أخرى': 'others',
    };

    final key = arabicToKey[arabicName] ?? 'others';
    return fromKey(key);
  }
}

enum PaymentMethod {
  cash('cash'),
  creditCard('credit_card'),
  bankTransfer('bank_transfer'),
  wallet('e_wallet'),
  check('cheque');

  final String translationKey;
  const PaymentMethod(this.translationKey);

  // Simple getter - NO translation here
  String get displayName => translationKey;

  static PaymentMethod fromKey(String key) {
    return PaymentMethod.values.firstWhere(
      (e) => e.translationKey == key,
      orElse: () => PaymentMethod.cash,
    );
  }

  // For backward compatibility
  static PaymentMethod fromString(String arabicName) {
    final Map<String, String> arabicToKey = {
      'نقدي': 'cash',
      'بطاقة ائتمان': 'credit_card',
      'تحويل بنكي': 'bank_transfer',
      'محفظة إلكترونية': 'e_wallet',
      'شيك': 'cheque',
    };

    final key = arabicToKey[arabicName] ?? 'cash';
    return fromKey(key);
  }
}
