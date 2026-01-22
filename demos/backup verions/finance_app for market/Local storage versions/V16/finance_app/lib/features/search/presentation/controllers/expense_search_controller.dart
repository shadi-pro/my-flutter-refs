// lib/features/search/presentation/controllers/expense_search_controller.dart

import 'package:get/get.dart';
import '../../../expense/presentation/controllers/expense_controller.dart';
import '../../../expense/domain/entities/expense_entity.dart'; // أضف هذا الاستيراد
import '../../../../core/utils/error_handler.dart';

class ExpenseSearchController extends GetxController {
  static const String TAG = 'ExpenseSearchController';

  final searchQuery = ''.obs;
  final selectedCategory = 'الكل'.obs;
  final selectedType = 'الكل'.obs;
  final minAmount = 0.0.obs;
  final maxAmount = 1000000.0.obs;
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);
  final isFilterActive = false.obs;

  @override
  void onInit() {
    super.onInit();
    ever(searchQuery, (_) => updateFilterStatus());
    ever(selectedCategory, (_) => updateFilterStatus());
    ever(selectedType, (_) => updateFilterStatus());
    ever(minAmount, (_) => updateFilterStatus());
    ever(maxAmount, (_) => updateFilterStatus());
    ever(startDate, (_) => updateFilterStatus());
    ever(endDate, (_) => updateFilterStatus());
  }

  void updateFilterStatus() {
    isFilterActive.value = searchQuery.value.isNotEmpty ||
        selectedCategory.value != 'الكل' ||
        selectedType.value != 'الكل' ||
        minAmount.value > 0.0 ||
        maxAmount.value < 1000000.0 ||
        startDate.value != null ||
        endDate.value != null;
  }

  List<Map<String, dynamic>> get filteredExpenses {
    try {
      final expenseController = Get.find<ExpenseController>();

      // الحل: تحويل List<ExpenseEntity> إلى List<Map<String, dynamic>>
      List<Map<String, dynamic>> expenses = expenseController.expenses
          .map((expenseEntity) => expenseEntity.toMap())
          .toList();

      // فلترة بالنص
      if (searchQuery.value.isNotEmpty) {
        expenses = expenses.where((expense) {
          return expense['category']
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              expense['description']
                  .toString()
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
          if (selectedType.value == 'مصروف')
            return expense['isIncome'] == false;
          return true;
        }).toList();
      }

      // فلترة بالمبلغ
      expenses = expenses.where((expense) {
        final amount = (expense['amount'] as num).toDouble();
        return amount >= minAmount.value && amount <= maxAmount.value;
      }).toList();

      // فلترة بالتاريخ
      if (startDate.value != null) {
        expenses = expenses.where((expense) {
          try {
            final expenseDate = DateTime.parse(expense['date']);
            return expenseDate.isAfter(startDate.value!);
          } catch (e) {
            return false;
          }
        }).toList();
      }

      if (endDate.value != null) {
        expenses = expenses.where((expense) {
          try {
            final expenseDate = DateTime.parse(expense['date']);
            return expenseDate.isBefore(endDate.value!);
          } catch (e) {
            return false;
          }
        }).toList();
      }

      // ترتيب حسب التاريخ (الأحدث أولاً)
      expenses.sort((a, b) {
        try {
          final dateA = DateTime.parse(a['date']);
          final dateB = DateTime.parse(b['date']);
          return dateB.compareTo(dateA);
        } catch (e) {
          return 0;
        }
      });

      return expenses;
    } catch (e) {
      ErrorHandler.showError('خطأ في تصفية البيانات: $e');
      return [];
    }
  }

  // دالة جديدة للحصول على ExpenseEntity مباشرة
  List<ExpenseEntity> get filteredExpenseEntities {
    try {
      final expenseController = Get.find<ExpenseController>();
      List<ExpenseEntity> expenses = List.from(expenseController.expenses);

      // فلترة بالنص
      if (searchQuery.value.isNotEmpty) {
        expenses = expenses.where((expense) {
          return expense.category.arabicName
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              expense.description
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase());
        }).toList();
      }

      // فلترة بالفئة
      if (selectedCategory.value != 'الكل') {
        expenses = expenses.where((expense) {
          return expense.category.arabicName == selectedCategory.value;
        }).toList();
      }

      // فلترة بالنوع
      if (selectedType.value != 'الكل') {
        expenses = expenses.where((expense) {
          if (selectedType.value == 'دخل') return expense.isIncome == true;
          if (selectedType.value == 'مصروف') return expense.isIncome == false;
          return true;
        }).toList();
      }

      // فلترة بالمبلغ
      expenses = expenses.where((expense) {
        return expense.amount >= minAmount.value &&
            expense.amount <= maxAmount.value;
      }).toList();

      // فلترة بالتاريخ
      if (startDate.value != null) {
        expenses = expenses.where((expense) {
          return expense.date.isAfter(startDate.value!);
        }).toList();
      }

      if (endDate.value != null) {
        expenses = expenses.where((expense) {
          return expense.date.isBefore(endDate.value!);
        }).toList();
      }

      // ترتيب حسب التاريخ (الأحدث أولاً)
      expenses.sort((a, b) => b.date.compareTo(a.date));

      return expenses;
    } catch (e) {
      ErrorHandler.showError('خطأ في تصفية البيانات: $e');
      return [];
    }
  }

  int get filteredCount => filteredExpenses.length;

  void resetFilters() {
    searchQuery.value = '';
    selectedCategory.value = 'الكل';
    selectedType.value = 'الكل';
    minAmount.value = 0.0;
    maxAmount.value = 1000000.0;
    startDate.value = null;
    endDate.value = null;
    ErrorHandler.showSuccess('تم إعادة تعيين جميع الفلاتر');
  }

  Map<String, dynamic> getFilterSummary() {
    return {
      'searchQuery': searchQuery.value,
      'category': selectedCategory.value,
      'type': selectedType.value,
      'amountRange': '${minAmount.value} - ${maxAmount.value}',
      'dateRange': startDate.value != null && endDate.value != null
          ? '${startDate.value!.toIso8601String()} to ${endDate.value!.toIso8601String()}'
          : 'غير محدد',
      'resultCount': filteredCount,
    };
  }

  // دالة مساعدة للبحث السريع
  List<ExpenseEntity> quickSearch(String query) {
    final expenseController = Get.find<ExpenseController>();
    return expenseController.expenses.where((expense) {
      return expense.category.arabicName.contains(query) ||
          expense.description.contains(query) ||
          expense.amount.toString().contains(query);
    }).toList();
  }
}
