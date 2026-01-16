// lib/features/search/presentation/controllers/search_controller.dart
import 'package:get/get.dart';
import '../../../expense/presentation/controllers/expense_controller.dart';

// تغيير الاسم إلى ExpenseSearchController
class ExpenseSearchController extends GetxController {
  final searchQuery = ''.obs;
  final selectedCategory = 'الكل'.obs;
  final selectedType = 'الكل'.obs;
  final minAmount = 0.0.obs;
  final maxAmount = 1000000.0.obs;
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);

  List get filteredExpenses {
    final expenseController = Get.find<ExpenseController>();
    List expenses = expenseController.expenses.toList();

    // فلترة بالنص
    if (searchQuery.value.isNotEmpty) {
      expenses = expenses.where((expense) {
        return expense['category']
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ||
            expense['description']
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase());
      }).toList();
    }

    // فلترة بالفئة
    if (selectedCategory.value != 'الكل') {
      expenses = expenses.where((expense) {
        return expense['category'] == selectedCategory.value;
      }).toList();
    }

    // فلترة بالنوع
    if (selectedType.value != 'الكل') {
      expenses = expenses.where((expense) {
        if (selectedType.value == 'دخل') return expense['isIncome'] == true;
        if (selectedType.value == 'مصروف') return expense['isIncome'] == false;
        return true;
      }).toList();
    }

    // فلترة بالمبلغ
    expenses = expenses.where((expense) {
      final amount = expense['amount'] as double;
      return amount >= minAmount.value && amount <= maxAmount.value;
    }).toList();

    return expenses;
  }

  void resetFilters() {
    searchQuery.value = '';
    selectedCategory.value = 'الكل';
    selectedType.value = 'الكل';
    minAmount.value = 0.0;
    maxAmount.value = 1000000.0;
    startDate.value = null;
    endDate.value = null;
  }
}
