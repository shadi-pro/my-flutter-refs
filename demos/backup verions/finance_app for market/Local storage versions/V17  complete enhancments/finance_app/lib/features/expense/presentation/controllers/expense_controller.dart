// lib/features/expense/presentation/controllers/expense_controller.dart

// KEEP ALL OTHER IMPORTS:
import 'package:finance_app/core/models/enums.dart';
import 'package:finance_app/features/alerts/presentation/controllers/alert_controller.dart';
import 'package:finance_app/features/expense/domain/entities/expense_entity.dart';
import 'package:finance_app/core/utils/error_handler.dart';
import 'package:finance_app/core/security/simple_encryption.dart';
import 'package:finance_app/features/expense/presentation/controllers/budget_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ExpenseController extends GetxController {
  final expenses = <ExpenseEntity>[].obs;
  final isLoading = false.obs;
  final totalIncome = 0.0.obs;
  final totalExpense = 0.0.obs;
  final balance = 0.0.obs;
  final selectedExpense = Rx<ExpenseEntity?>(null);

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  Future<void> _initializeData() async {
    isLoading.value = true;

    try {
      await loadExpenses();

      if (expenses.isEmpty) {
        print('📝 No expenses found, considering test data...');
      }
    } catch (e, stackTrace) {
      print('❌ Error initializing data: $e');
      print('Stack trace: $stackTrace');
      ErrorHandler.showError('خطأ في تهيئة البيانات: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadExpenses() async {
    try {
      final storedData = SimpleEncryption.read('expenses');

      if (storedData == null) {
        expenses.value = [];
        calculateRealTotals();
        print('📭 No stored expenses found');
        return;
      }

      if (storedData is List) {
        final loadedExpenses = <ExpenseEntity>[];
        int errorCount = 0;
        int successCount = 0;

        for (var i = 0; i < storedData.length; i++) {
          try {
            final item = storedData[i];

            if (item is Map<String, dynamic>) {
              final expense = ExpenseEntity.fromMap(item);

              if (expense.amount > 0 && expense.id.isNotEmpty) {
                loadedExpenses.add(expense);
                successCount++;
              } else {
                print('⚠️ Skipping invalid expense at index $i');
                errorCount++;
              }
            } else {
              print('⚠️ Skipping non-map item at index $i: $item');
              errorCount++;
            }
          } catch (e, stackTrace) {
            print('❌ Error parsing expense at index $i: $e');
            print('Stack trace: $stackTrace');
            errorCount++;
          }
        }

        expenses.value = loadedExpenses;
        calculateRealTotals();

        print('📊 Loaded $successCount expenses with $errorCount errors');

        if (errorCount > 0) {
          ErrorHandler.showWarning(
            'تم تحميل $successCount معاملة مع $errorCount أخطاء',
            title: 'ملاحظة',
          );
        }
      } else {
        print('⚠️ Stored expenses is not a List: ${storedData.runtimeType}');
        expenses.value = [];
        calculateRealTotals();

        await SimpleEncryption.remove('expenses');
        ErrorHandler.showWarning(
          'تم اكتشاف بيانات تالفة، تم مسح البيانات القديمة',
          title: 'تنبيه',
        );
      }
    } catch (e, stackTrace) {
      print('❌ Critical error loading expenses: $e');
      print('Stack trace: $stackTrace');

      expenses.value = [];
      calculateRealTotals();

      ErrorHandler.showError(
        'فشل في تحميل البيانات، يرجى إعادة تشغيل التطبيق',
        title: 'خطأ حرج',
      );
    }
  }

  @visibleForTesting
  Future<void> addTestData() async {
    try {
      final testExpenses = [
        ExpenseEntity(
          amount: 5000.0,
          category: ExpenseCategory.salary,
          description: 'مرتب شهر يناير',
          date: DateTime.now(),
          isIncome: true,
          paymentMethod: PaymentMethod.bankTransfer,
        ),
        ExpenseEntity(
          amount: 300.0,
          category: ExpenseCategory.food,
          description: 'سوق الأسبوع',
          date: DateTime.now(),
          isIncome: false,
          paymentMethod: PaymentMethod.cash,
        ),
        ExpenseEntity(
          amount: 150.0,
          category: ExpenseCategory.transportation,
          description: 'بنزين السيارة',
          date: DateTime.now(),
          isIncome: false,
          paymentMethod: PaymentMethod.creditCard,
        ),
      ];

      expenses.value = testExpenses;
      await _saveToStorage();
      calculateRealTotals();

      ErrorHandler.showSuccess('تم تحميل البيانات التجريبية بنجاح');
    } catch (e, stackTrace) {
      print('❌ Error adding test data: $e');
      print('Stack trace: $stackTrace');
      ErrorHandler.showError(
          'خطأ في إضافة البيانات التجريبية: ${e.toString()}');
    }
  }

  void calculateRealTotals() {
    double income = 0;
    double expense = 0;

    for (var entity in expenses) {
      if (entity.isIncome) {
        income += entity.amount;
      } else {
        expense += entity.amount;
      }
    }

    totalIncome.value = income;
    totalExpense.value = expense;
    balance.value = income - expense;

    print(
        '💰 Totals calculated - Income: $income, Expense: $expense, Balance: ${balance.value}');
  }

  Future<void> addExpense(ExpenseEntity expense) async {
    try {
      if (expense.amount <= 0) {
        throw Exception('المبلغ يجب أن يكون أكبر من صفر');
      }

      if (expense.category == ExpenseCategory.other &&
          expense.description.isEmpty) {
        throw Exception('يرجى إدخال وصف للمعاملات في الفئة "أخرى"');
      }

      if (_isDuplicateExpense(expense)) {
        final shouldProceed = await ErrorHandler.showConfirmationDialog(
          title: 'معاملة مشابهة',
          message: 'يوجد معاملة مشابهة تم إضافتها مؤخراً. هل تريد المتابعة؟',
          confirmText: 'نعم، متابعة',
          cancelText: 'إلغاء',
          confirmColor: Colors.blue,
        );

        if (!shouldProceed) {
          return;
        }
      }

      expenses.add(expense);
      await _saveToStorage();
      calculateRealTotals();

      ErrorHandler.showSuccess('تم إضافة المعاملة بنجاح');

      final alertController = Get.find<AlertController>();
      alertController.checkExpenseAlerts(
          expense.amount, expense.category.arabicName);

      // Get BudgetController when needed
      if (Get.isRegistered<BudgetController>()) {
        final budgetController = Get.find<BudgetController>();
        alertController.checkBudgetAlerts(
          budgetController.spendingPercentage,
          budgetController.remainingBudget,
        );
      }
    } catch (e, stackTrace) {
      print('❌ Error adding expense: $e');
      print('Stack trace: $stackTrace');

      ErrorHandler.showError('فشل في إضافة المعاملة: ${e.toString()}');
      rethrow;
    }
  }

  bool _isDuplicateExpense(ExpenseEntity newExpense) {
    final recentExpenses = this.recentExpenses.take(5).toList();

    for (var existingExpense in recentExpenses) {
      if (existingExpense.isSimilarTo(newExpense)) {
        return true;
      }
    }

    return false;
  }

  Future<void> updateExpense(int index, ExpenseEntity expense) async {
    try {
      if (index < 0 || index >= expenses.length) {
        throw Exception('فهرس غير صالح');
      }

      if (expense.amount <= 0) {
        throw Exception('المبلغ يجب أن يكون أكبر من صفر');
      }

      expenses[index] = expense;
      await _saveToStorage();
      calculateRealTotals();

      ErrorHandler.showSuccess('تم تحديث المعاملة بنجاح');
    } catch (e, stackTrace) {
      print('❌ Error updating expense at index $index: $e');
      print('Stack trace: $stackTrace');

      ErrorHandler.showError('فشل في تحديث المعاملة: ${e.toString()}');
    }
  }

  Future<void> deleteExpense(int index) async {
    try {
      if (index < 0 || index >= expenses.length) {
        throw Exception('فهرس غير صالح');
      }

      final expenseToDelete = expenses[index];

      expenses.removeAt(index);
      await _saveToStorage();
      calculateRealTotals();

      ErrorHandler.showSuccess('تم حذف المعاملة بنجاح');

      print(
          '🗑️ Deleted expense: ${expenseToDelete.category.arabicName} - ${expenseToDelete.amount}');
    } catch (e, stackTrace) {
      print('❌ Error deleting expense at index $index: $e');
      print('Stack trace: $stackTrace');

      ErrorHandler.showError('فشل في حذف المعاملة: ${e.toString()}');
    }
  }

  Future<void> clearAllData() async {
    try {
      final confirmed = await ErrorHandler.showConfirmationDialog(
        title: 'مسح كل البيانات',
        message:
            'هل أنت متأكد من مسح كل المعاملات؟\n\nهذا الإجراء لا يمكن التراجع عنه وسيتم حذف:\n• جميع المعاملات\n• جميع الإحصائيات\n• جميع الميزانيات\n\nتأكد من عمل نسخة احتياطية أولاً.',
        confirmText: 'نعم، مسح الكل',
        cancelText: 'إلغاء',
        confirmColor: Colors.red,
      );

      if (!confirmed) {
        print('⚠️ User cancelled clear all data');
        return;
      }

      expenses.clear();
      await SimpleEncryption.remove('expenses');

      await SimpleEncryption.remove('monthlyBudget');
      await SimpleEncryption.remove('categoryBudgets');

      calculateRealTotals();

      ErrorHandler.showSuccess('تم مسح كل البيانات بنجاح');

      print('🧹 All data cleared by user');
    } catch (e, stackTrace) {
      print('❌ Error clearing all data: $e');
      print('Stack trace: $stackTrace');

      ErrorHandler.showError('فشل في مسح البيانات: ${e.toString()}');
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final data = expenses.map((e) => e.toMap()).toList();
      await SimpleEncryption.write('expenses', data);

      print('💾 Saved ${expenses.length} expenses to storage');
    } catch (e, stackTrace) {
      print('❌ Error saving expenses to storage: $e');
      print('Stack trace: $stackTrace');

      ErrorHandler.showError('خطأ في حفظ البيانات: ${e.toString()}');
      rethrow;
    }
  }

  Map<String, dynamic> getMonthlyStats() {
    final now = DateTime.now();
    final monthlyExpenses = expenses.where((expense) {
      return expense.date.month == now.month && expense.date.year == now.year;
    }).toList();

    double monthlyIncome = 0;
    double monthlyExpense = 0;

    for (var expense in monthlyExpenses) {
      if (expense.isIncome) {
        monthlyIncome += expense.amount;
      } else {
        monthlyExpense += expense.amount;
      }
    }

    return {
      'income': monthlyIncome,
      'expense': monthlyExpense,
      'balance': monthlyIncome - monthlyExpense,
      'count': monthlyExpenses.length,
      'averageExpense': monthlyExpenses.isNotEmpty
          ? monthlyExpense / monthlyExpenses.length
          : 0,
    };
  }

  Map<String, double> getExpensesByCategory(bool isIncome) {
    final Map<String, double> categoryTotals = {};

    final filteredExpenses =
        expenses.where((expense) => expense.isIncome == isIncome);

    for (var expense in filteredExpenses) {
      final categoryName = expense.category.arabicName;
      categoryTotals.update(
        categoryName,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    return categoryTotals;
  }

  int get expenseCount => expenses.length;

  List<ExpenseEntity> get recentExpenses {
    final sorted = List<ExpenseEntity>.from(expenses);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  List<ExpenseEntity> getExpensesByDateRange(DateTime start, DateTime end) {
    return expenses.where((expense) {
      return expense.date.isAfter(start.subtract(const Duration(days: 1))) &&
          expense.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  ExpenseEntity? getExpenseById(String id) {
    try {
      return expenses.firstWhere((expense) => expense.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Map<String, dynamic>> get expensesAsMap {
    return expenses.map((e) => e.toMap()).toList();
  }

  List<ExpenseEntity> get currentMonthExpenses {
    final now = DateTime.now();
    return expenses.where((expense) {
      return expense.date.month == now.month && expense.date.year == now.year;
    }).toList();
  }

  String? get mostExpensiveCategory {
    if (expenses.isEmpty) return null;

    final categoryTotals = getExpensesByCategory(false);
    if (categoryTotals.isEmpty) return null;

    final sortedEntries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.first.key;
  }
}
