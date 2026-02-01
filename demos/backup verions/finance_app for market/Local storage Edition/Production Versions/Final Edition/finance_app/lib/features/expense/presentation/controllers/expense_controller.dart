// FILE: lib/features/expense/presentation/controllers/expense_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finance_app/core/models/enums.dart';
import 'package:finance_app/features/alerts/presentation/controllers/alert_controller.dart';
import 'package:finance_app/features/expense/domain/entities/expense_entity.dart';
import 'package:finance_app/core/utils/error_handler.dart';
import 'package:finance_app/core/security/simple_encryption.dart';
import 'package:finance_app/features/expense/presentation/controllers/budget_controller.dart';

class ExpenseController extends GetxController {
  final RxList<ExpenseEntity> expenses = <ExpenseEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxDouble totalIncome = 0.0.obs;
  final RxDouble totalExpense = 0.0.obs;
  final RxDouble balance = 0.0.obs;
  final Rx<ExpenseEntity?> selectedExpense = Rx<ExpenseEntity?>(null);

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
      ErrorHandler.showError(
          'initDataError'.trParams(<String, String>{'e': e.toString()}));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadExpenses() async {
    try {
      final dynamic storedData = SimpleEncryption.read('expenses');

      if (storedData == null) {
        expenses.value = <ExpenseEntity>[];
        calculateRealTotals();
        return;
      }

      if (storedData is List<dynamic>) {
        final List<ExpenseEntity> loadedExpenses = <ExpenseEntity>[];
        int errorCount = 0;
        int successCount = 0;

        for (int i = 0; i < storedData.length; i++) {
          try {
            final dynamic item = storedData[i];

            if (item is Map<String, dynamic>) {
              final ExpenseEntity expense = ExpenseEntity.fromMap(item);

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
            'loadedWithErrors'.trParams(<String, String>{
              'successCount': successCount.toString(),
              'errorCount': errorCount.toString(),
            }),
            title: 'note'.tr,
          );
        }
      } else {
        expenses.value = <ExpenseEntity>[];
        calculateRealTotals();

        await SimpleEncryption.remove('expenses');
        ErrorHandler.showWarning(
          'corruptedDataCleared'.tr,
          title: 'alert'.tr,
        );
      }
    } catch (e) {
      expenses.value = <ExpenseEntity>[];
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

    for (final ExpenseEntity entity in expenses) {
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
        final bool shouldProceed = await ErrorHandler.showConfirmationDialog(
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

      final AlertController alertController = Get.find<AlertController>();

      if (!expense.isIncome) {
        alertController.checkExpenseAlerts(
          expense.amount,
          expense.category.translationKey.tr,
          expense.isIncome,
        );
      }

      if (Get.isRegistered<BudgetController>()) {
        final BudgetController budgetController = Get.find<BudgetController>();
        alertController.checkBudgetAlerts(
          budgetController.spendingPercentage,
          budgetController.remainingBudget,
        );
      }
    } catch (e) {
      ErrorHandler.showError(
          'addExpenseFailed'.trParams(<String, String>{'e': e.toString()}));
      rethrow;
    }
  }

  bool _isDuplicateExpense(ExpenseEntity newExpense) {
    final List<ExpenseEntity> recentExpenses =
        this.recentExpenses.take(5).toList();

    for (final ExpenseEntity existingExpense in recentExpenses) {
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
        'updateExpenseFailed'.trParams(<String, String>{'e': e.toString()}),
      );
    }
  }

  Future<void> deleteExpense(int index) async {
    try {
      if (index < 0 || index >= expenses.length) {
        throw Exception('invalidIndex'.tr);
      }

      expenses[index];

      expenses.removeAt(index);
      await _saveToStorage();
      calculateRealTotals();

      ErrorHandler.showSuccess('deleteSuccess'.tr);
    } catch (e) {
      ErrorHandler.showError(
        'deleteExpenseFailed'.trParams(<String, String>{'e': e.toString()}),
      );
    }
  }

  Future<void> clearAllData() async {
    try {
      final bool confirmed = await ErrorHandler.showConfirmationDialog(
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
      ErrorHandler.showError(
          'clearDataFailed'.trParams(<String, String>{'e': e.toString()}));
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final List<Map<String, dynamic>> data =
          expenses.map((ExpenseEntity e) => e.toMap()).toList();
      await SimpleEncryption.write('expenses', data);
    } catch (e) {
      ErrorHandler.showError(
          'saveDataError'.trParams(<String, String>{'e': e.toString()}));
      rethrow;
    }
  }

  Map<String, dynamic> getMonthlyStats() {
    final DateTime now = DateTime.now();
    final List<ExpenseEntity> monthlyExpenses =
        expenses.where((ExpenseEntity expense) {
      return expense.date.month == now.month && expense.date.year == now.year;
    }).toList();

    double monthlyIncome = 0;
    double monthlyExpense = 0;

    for (final ExpenseEntity expense in monthlyExpenses) {
      if (expense.isIncome) {
        monthlyIncome += expense.amount;
      } else {
        monthlyExpense += expense.amount;
      }
    }

    return <String, dynamic>{
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
    final Map<String, double> categoryTotals = <String, double>{};

    final Iterable<ExpenseEntity> filteredExpenses =
        expenses.where((ExpenseEntity expense) => expense.isIncome == isIncome);

    for (final ExpenseEntity expense in filteredExpenses) {
      final String categoryName = expense.category.translationKey.tr;
      categoryTotals.update(
        categoryName,
        (double value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    return categoryTotals;
  }

  int get expenseCount => expenses.length;

  List<ExpenseEntity> get recentExpenses {
    final List<ExpenseEntity> sorted = List<ExpenseEntity>.from(expenses);
    sorted.sort((ExpenseEntity a, ExpenseEntity b) => b.date.compareTo(a.date));
    return sorted;
  }

  List<ExpenseEntity> getExpensesByDateRange(DateTime start, DateTime end) {
    return expenses.where((ExpenseEntity expense) {
      return expense.date.isAfter(start.subtract(const Duration(days: 1))) &&
          expense.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  ExpenseEntity? getExpenseById(String id) {
    try {
      return expenses.firstWhere((ExpenseEntity expense) => expense.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Map<String, dynamic>> get expensesAsMap {
    return expenses.map((ExpenseEntity e) => e.toMap()).toList();
  }

  List<ExpenseEntity> get currentMonthExpenses {
    final DateTime now = DateTime.now();
    return expenses.where((ExpenseEntity expense) {
      return expense.date.month == now.month && expense.date.year == now.year;
    }).toList();
  }

  String? get mostExpensiveCategory {
    if (expenses.isEmpty) return null;

    final Map<String, double> categoryTotals = getExpensesByCategory(false);
    if (categoryTotals.isEmpty) return null;

    final List<MapEntry<String, double>> sortedEntries =
        categoryTotals.entries.toList()
          ..sort(
            (MapEntry<String, double> a, MapEntry<String, double> b) =>
                b.value.compareTo(a.value),
          );

    return sortedEntries.first.key;
  }
}
