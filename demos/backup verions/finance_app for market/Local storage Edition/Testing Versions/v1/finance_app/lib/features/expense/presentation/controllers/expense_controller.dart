// lib/features/expense/presentation/controllers/expense_controller.dart
import 'package:get/get.dart';

class ExpenseController extends GetxController {
  // بيانات مؤقتة للتجربة
  final expenses = [].obs;
  final isLoading = false.obs;

  final totalIncome = 0.0.obs;
  final totalExpense = 0.0.obs;
  final balance = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // بيانات تجريبية
    addTestData();
  }

  void addTestData() {
    // بيانات تجريبية للاختبار
    expenses.value = [
      {
        'id': '1',
        'amount': 1000.0,
        'category': 'مرتب',
        'description': 'مرتب الشهر',
        'date': DateTime.now().toString(),
        'isIncome': true,
        'paymentMethod': 'تحويل بنكي'
      },
      {
        'id': '2',
        'amount': 200.0,
        'category': 'طعام',
        'description': 'سوق الأسبوع',
        'date': DateTime.now().toString(),
        'isIncome': false,
        'paymentMethod': 'نقدي'
      },
    ];

    calculateTotals();
  }

  void calculateTotals() {
    totalIncome.value = 1000.0; // قيمة تجريبية
    totalExpense.value = 200.0; // قيمة تجريبية
    balance.value = totalIncome.value - totalExpense.value;
  }

  void addExpense(Map<String, dynamic> expense) {
    expenses.add(expense);
    calculateTotals();
    Get.snackbar('تم الحفظ!', 'تم إضافة المعاملة بنجاح');
  }
}
