// FILE: lib/features/expense/presentation/controllers/expense_controller.dart

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
    } catch (e) {
      ErrorHandler.showError('initDataError'.trParams({'e': e.toString()}));
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
                errorCount++;
              }
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
          ErrorHandler.showWarning(
            'loadedWithErrors'.trParams({
              'successCount': successCount.toString(),
              'errorCount': errorCount.toString()
            }),
            title: 'note'.tr,
          );
        }
      } else {
        expenses.value = [];
        calculateRealTotals();

        await SimpleEncryption.remove('expenses');
        ErrorHandler.showWarning(
          'corruptedDataCleared'.tr,
          title: 'alert'.tr,
        );
      }
    } catch (e) {
      expenses.value = [];
      calculateRealTotals();

      ErrorHandler.showError(
        'loadDataFailedRestart'.tr,
        title: 'criticalError'.tr,
      );
    }
  }

  @visibleForTesting
  Future<void> addTestData() async {
    return;
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
        throw Exception('invalidAmount'.tr);
      }

      if (expense.category == ExpenseCategory.other &&
          expense.description.isEmpty) {
        throw Exception('otherCategoryDescription'.tr);
      }

      if (_isDuplicateExpense(expense)) {
        final shouldProceed = await ErrorHandler.showConfirmationDialog(
          title: 'similarTransaction'.tr,
          message: 'duplicateExpenseQuestion'.tr,
          confirmText: 'proceedAnyway'.tr,
          cancelText: 'cancel'.tr,
          confirmColor: Colors.blue,
        );

        if (!shouldProceed) {
          return;
        }
      }

      expenses.add(expense);
      await _saveToStorage();
      calculateRealTotals();

      ErrorHandler.showSuccess('saveSuccess'.tr);

      final alertController = Get.find<AlertController>();

      if (!expense.isIncome) {
        alertController.checkExpenseAlerts(expense.amount,
            expense.category.translationKey.tr, expense.isIncome);
      }

      if (Get.isRegistered<BudgetController>()) {
        final budgetController = Get.find<BudgetController>();
        alertController.checkBudgetAlerts(
          budgetController.spendingPercentage,
          budgetController.remainingBudget,
        );
      }
    } catch (e) {
      ErrorHandler.showError('addExpenseFailed'.trParams({'e': e.toString()}));
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
        throw Exception('invalidIndex'.tr);
      }

      if (expense.amount <= 0) {
        throw Exception('invalidAmount'.tr);
      }

      expenses[index] = expense;
      await _saveToStorage();
      calculateRealTotals();

      ErrorHandler.showSuccess('updateSuccess'.tr);
    } catch (e) {
      ErrorHandler.showError(
          'updateExpenseFailed'.trParams({'e': e.toString()}));
    }
  }

  Future<void> deleteExpense(int index) async {
    try {
      if (index < 0 || index >= expenses.length) {
        throw Exception('invalidIndex'.tr);
      }

      final expenseToDelete = expenses[index];

      expenses.removeAt(index);
      await _saveToStorage();
      calculateRealTotals();

      ErrorHandler.showSuccess('deleteSuccess'.tr);
    } catch (e) {
      ErrorHandler.showError(
          'deleteExpenseFailed'.trParams({'e': e.toString()}));
    }
  }

  Future<void> clearAllData() async {
    try {
      final confirmed = await ErrorHandler.showConfirmationDialog(
        title: 'clearAllDataTitle'.tr,
        message: 'clearAllDataMessage'.tr,
        confirmText: 'confirmClearAll'.tr,
        cancelText: 'cancel'.tr,
        confirmColor: Colors.red,
      );

      if (!confirmed) {
        return;
      }

      expenses.clear();
      await SimpleEncryption.remove('expenses');

      await SimpleEncryption.remove('monthlyBudget');
      await SimpleEncryption.remove('categoryBudgets');

      calculateRealTotals();

      ErrorHandler.showSuccess('clearAllSuccess'.tr);
    } catch (e) {
      ErrorHandler.showError('clearDataFailed'.trParams({'e': e.toString()}));
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final data = expenses.map((e) => e.toMap()).toList();
      await SimpleEncryption.write('expenses', data);
    } catch (e) {
      ErrorHandler.showError('saveDataError'.trParams({'e': e.toString()}));
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
      final categoryName = expense.category.translationKey.tr;
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
