//  finance_app\lib\core\models\enums.dart

enum ExpenseCategory {
  food('طعام'),
  transportation('مواصلات'),
  shopping('تسوق'),
  entertainment('ترفيه'),
  health('صحة'),
  education('تعليم'),
  housing('سكن'),
  bills('فواتير'),
  salary('مرتب'),
  investment('استثمار'),
  gifts('هدايا'),
  other('أخرى');

  final String arabicName;
  const ExpenseCategory(this.arabicName);

  static ExpenseCategory fromString(String name) {
    return ExpenseCategory.values.firstWhere(
      (e) => e.arabicName == name,
      orElse: () => ExpenseCategory.other,
    );
  }
}

enum PaymentMethod {
  cash('نقدي'),
  creditCard('بطاقة ائتمان'),
  bankTransfer('تحويل بنكي'),
  wallet('محفظة إلكترونية'),
  check('شيك');

  final String arabicName;
  const PaymentMethod(this.arabicName);

  static PaymentMethod fromString(String name) {
    return PaymentMethod.values.firstWhere(
      (e) => e.arabicName == name,
      orElse: () => PaymentMethod.cash,
    );
  }
}
