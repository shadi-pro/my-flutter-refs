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
        await addTestData();
      }
    } catch (e) {
      ErrorHandler.showError('خطأ في تهيئة البيانات: $e');
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
        return;
      }

      if (storedData is List) {
        final loadedExpenses = <ExpenseEntity>[];
        int errorCount = 0;

        for (var item in storedData) {
          try {
            if (item is Map<String, dynamic>) {
              final expense = ExpenseEntity.fromMap(item);
              loadedExpenses.add(expense);
            } else {
              errorCount++;
            }
          } catch (e) {
            errorCount++;
          }
        }

        expenses.value = loadedExpenses;
        calculateRealTotals();

        if (errorCount > 0) {
          print(
              '⚠️ Loaded ${expenses.length} expenses with $errorCount errors');
        } else {
          print('✅ Successfully loaded ${expenses.length} expenses');
        }
      } else {
        print('⚠️ Stored expenses is not a List');
        expenses.value = [];
        calculateRealTotals();
      }
    } catch (e) {
      print('❌ Error loading expenses: $e');
      expenses.value = [];
      calculateRealTotals();
    }
  }

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
    } catch (e) {
      ErrorHandler.showError('خطأ في إضافة البيانات التجريبية: $e');
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
  }

  Future<void> addExpense(ExpenseEntity expense) async {
    try {
      if (expense.amount <= 0) {
        throw Exception('المبلغ يجب أن يكون أكبر من صفر');
      }

      expenses.add(expense);
      await _saveToStorage();
      calculateRealTotals();

      ErrorHandler.showSuccess('تم إضافة المعاملة بنجاح');

      final alertController = Get.find<AlertController>();
      alertController.checkExpenseAlerts(
          expense.amount, expense.category.arabicName);

      if (Get.isRegistered<BudgetController>()) {
        final budgetController = Get.find<BudgetController>();
        alertController.checkBudgetAlerts(
          budgetController.spendingPercentage,
          budgetController.remainingBudget,
        );
      }
    } catch (e) {
      ErrorHandler.showError('فشل في إضافة المعاملة: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> updateExpense(int index, ExpenseEntity expense) async {
    try {
      if (index < 0 || index >= expenses.length) {
        throw Exception('فهرس غير صالح');
      }

      expenses[index] = expense;
      await _saveToStorage();
      calculateRealTotals();
      ErrorHandler.showSuccess('تم تحديث المعاملة بنجاح');
    } catch (e) {
      ErrorHandler.showError('فشل في تحديث المعاملة: ${e.toString()}');
    }
  }

  Future<void> deleteExpense(int index) async {
    try {
      if (index < 0 || index >= expenses.length) {
        throw Exception('فهرس غير صالح');
      }

      expenses.removeAt(index);
      await _saveToStorage();
      calculateRealTotals();
      ErrorHandler.showSuccess('تم حذف المعاملة بنجاح');
    } catch (e) {
      ErrorHandler.showError('فشل في حذف المعاملة: ${e.toString()}');
    }
  }

  Future<void> clearAllData() async {
    try {
      final confirmed = await ErrorHandler.showConfirmationDialog(
        title: 'مسح كل البيانات',
        message:
            'هل أنت متأكد من مسح كل المعاملات؟ هذا الإجراء لا يمكن التراجع عنه.',
        confirmText: 'مسح الكل',
        cancelText: 'إلغاء',
      );

      if (!confirmed) return;

      expenses.clear();
      await SimpleEncryption.remove('expenses');
      calculateRealTotals();
      ErrorHandler.showSuccess('تم مسح كل البيانات بنجاح');
    } catch (e) {
      ErrorHandler.showError('فشل في مسح البيانات: ${e.toString()}');
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final data = expenses.map((e) => e.toMap()).toList();
      await SimpleEncryption.write('expenses', data);
    } catch (e) {
      ErrorHandler.showError('خطأ في حفظ البيانات: $e');
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
    return sorted.take(10).toList();
  }

  List<ExpenseEntity> getExpensesByDateRange(DateTime start, DateTime end) {
    return expenses.where((expense) {
      return expense.date.isAfter(start) && expense.date.isBefore(end);
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
}
