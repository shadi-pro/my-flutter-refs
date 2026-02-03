// lib/features/expense/presentation/controllers/budget_controller.dart

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:finance_app/features/expense/presentation/controllers/expense_controller.dart';
import 'package:finance_app/core/security/simple_encryption.dart';

import 'package:finance_app/core/models/enums.dart';
import 'package:finance_app/features/expense/domain/entities/expense_entity.dart';

class BudgetController extends GetxController {
  final GetStorage _storage = GetStorage();

  // Monthly budget
  final RxDouble monthlyBudget = 0.0.obs;

  // Budgets according to Categories
  final RxMap<String, double> categoryBudgets = <String, double>{}.obs;

  final List<String> defaultCategories = <String>[
    'food',
    'transportation',
    'marketing',
    'entertainment',
    'health',
    'learn',
    'living',
    'bills',
  ];

  @override
  void onInit() {
    super.onInit();
    loadBudgetData();
  }

  // Helper: Check if text is Arabic
  bool _isArabicText(String text) {
    final RegExp arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }

  // Helper: Convert Arabic text to translation key
  String _arabicToKey(String arabicText) {
    try {
      final ExpenseCategory category = ExpenseCategory.fromString(arabicText);
      return category.translationKey;
    } catch (e) {
      // If conversion fails, return the original
      return arabicText;
    }
  }

  // Helper: Get display name for category key
  String _getDisplayCategory(String categoryKey) {
    if (categoryKey.isEmpty) return 'others'.tr;

    try {
      // Check if it's already a translation key
      final ExpenseCategory matchingCategory =
          ExpenseCategory.values.firstWhere(
        (ExpenseCategory cat) => cat.translationKey == categoryKey,
        orElse: () => ExpenseCategory.other,
      );
      return matchingCategory.translationKey.tr;
    } catch (e) {
      // If it's Arabic (old data), convert and display
      if (_isArabicText(categoryKey)) {
        try {
          final ExpenseCategory category =
              ExpenseCategory.fromString(categoryKey);
          return category.translationKey.tr;
        } catch (e) {
          return categoryKey; // Fallback to Arabic
        }
      }
      return categoryKey; // Fallback
    }
  }

  // loading main Budget Data
  Future<void> loadBudgetData() async {
    try {
      final dynamic storedMonthlyBudget =
          SimpleEncryption.read('monthlyBudget');
      monthlyBudget.value = (storedMonthlyBudget as num?)?.toDouble() ?? 0.0;

      final dynamic storedCategoryBudgets =
          SimpleEncryption.read('categoryBudgets') ?? <String, dynamic>{};

      // Handle migration from Arabic to keys
      final Map<String, double> migratedBudgets = <String, double>{};

      if (storedCategoryBudgets is Map<String, dynamic>) {
        for (final MapEntry<dynamic, dynamic> entry
            in (storedCategoryBudgets as Map<dynamic, dynamic>).entries) {
          final String key = entry.key.toString();
          final double value = (entry.value as num).toDouble();

          // Convert Arabic keys to translation keys
          if (_isArabicText(key)) {
            final String migratedKey = _arabicToKey(key);
            migratedBudgets[migratedKey] = value;
          } else {
            migratedBudgets[key] = value;
          }
        }
      }

      categoryBudgets.value = migratedBudgets;

      // Initialize the Budgets Categories if they are empty
      if (categoryBudgets.isEmpty) {
        for (final String categoryKey in defaultCategories) {
          categoryBudgets[categoryKey] = 0.0;
        }
      }

      if (kDebugMode) {
        debugPrint('✅ Budget data loaded successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Error loading budget data: $e');
      }
      _initializeDefaultBudgets();
    }
  }

  // Initialize Default Budgets
  void _initializeDefaultBudgets() {
    for (final String categoryKey in defaultCategories) {
      categoryBudgets[categoryKey] = 0.0;
    }
    monthlyBudget.value = 0.0;
  }

  // Update Monthly Budget
  Future<void> setMonthlyBudget(double amount) async {
    monthlyBudget.value = amount;
    await SimpleEncryption.write('monthlyBudget', amount);
    update();
    if (kDebugMode) {
      debugPrint('💰 Monthly budget updated: $amount');
    }
  }

  // Setting a budget with a certain category (accepts either key or display text)
  Future<void> setCategoryBudget(String category, double amount) async {
    String categoryKey = category;

    // Convert display text to key if needed
    if (_isArabicText(category)) {
      // It's Arabic text, convert to key
      categoryKey = _arabicToKey(category);
    } else {
      // Check if it's display text (translated)
      for (final ExpenseCategory cat in ExpenseCategory.values) {
        if (cat.translationKey.tr == category) {
          categoryKey = cat.translationKey;
          break;
        }
      }
    }

    categoryBudgets[categoryKey] = amount;
    await _saveCategoryBudgets();
    update();
    if (kDebugMode) {
      debugPrint('📊 Category budget updated: $categoryKey = $amount');
    }
  }

  // Get category budget by key
  double? getCategoryBudgetByKey(String categoryKey) {
    return categoryBudgets[categoryKey];
  }

  // Get category budget by display text
  double? getCategoryBudgetByDisplay(String displayText) {
    for (final ExpenseCategory category in ExpenseCategory.values) {
      if (category.translationKey.tr == displayText) {
        return categoryBudgets[category.translationKey];
      }
    }
    return null;
  }

  // Save a budget with a certain category
  Future<void> _saveCategoryBudgets() async {
    await SimpleEncryption.write('categoryBudgets', categoryBudgets);
  }

  double get totalCategoryBudgets {
    return categoryBudgets.values.fold(0.0, (double sum, double? budget) {
      return sum + (budget ?? 0.0);
    });
  }

  // Checking for not exceeding the Budget
  double get remainingBudget {
    final ExpenseController expenseController = Get.find<ExpenseController>();
    return monthlyBudget.value - expenseController.totalExpense.value;
  }

  // Calculating expense percentage of Budget
  double get spendingPercentage {
    if (monthlyBudget.value <= 0) return 0;
    final ExpenseController expenseController = Get.find<ExpenseController>();
    return (expenseController.totalExpense.value / monthlyBudget.value) * 100;
  }

  // Getting remaining budget for each category
  Map<String, double> getRemainingCategoryBudgets() {
    final ExpenseController expenseController = Get.find<ExpenseController>();

    expenseController.getExpensesByCategory(false);

    final Map<String, double> remaining = <String, double>{};

    for (final String categoryKey in categoryBudgets.keys) {
      final double? budget = categoryBudgets[categoryKey];

      // Get expenses for this category (need to match by key)
      double spent = 0.0;
      for (final dynamic expense in expenseController.expenses) {
        if (expense is ExpenseEntity &&
            !expense.isIncome &&
            expense.category.translationKey == categoryKey) {
          spent += expense.amount;
        }
      }

      remaining[categoryKey] = (budget ?? 0.0) - spent;
    }

    return remaining;
  }

  // Get remaining budget for display (with translated category names)
  Map<String, double> getRemainingCategoryBudgetsForDisplay() {
    final Map<String, double> remaining = getRemainingCategoryBudgets();
    final Map<String, double> displayMap = <String, double>{};

    for (final MapEntry<String, double> entry in remaining.entries) {
      final String displayName = _getDisplayCategory(entry.key);
      displayMap[displayName] = entry.value;
    }

    return displayMap;
  }

  // Get all categories for display (with translated names)
  Map<String, double> getCategoryBudgetsForDisplay() {
    final Map<String, double> displayMap = <String, double>{};

    for (final MapEntry<String, double> entry in categoryBudgets.entries) {
      final String displayName = _getDisplayCategory(entry.key);
      displayMap[displayName] = entry.value;
    }

    return displayMap;
  }

  // get Budget Alerts
  List<String> getBudgetAlerts() {
    final List<String> alerts = <String>[];
    Get.find<ExpenseController>();

    // Budget Alert of high Expense
    if (spendingPercentage >= 80) {
      alerts.add('⚠️ ${'spent_percentage'.trParams({
            'value': spendingPercentage.toStringAsFixed(0),
          })}');
    }

    if (spendingPercentage >= 100) {
      alerts.add('category_budget_exceeded'.tr);
    }

    // Category Alerts
    final Map<String, double> remainingBudgets =
        getRemainingCategoryBudgetsForDisplay();
    for (final MapEntry<String, double> entry in remainingBudgets.entries) {
      if (entry.value < 0) {
        alerts.add('📌 ${'exceeded_budget_for'.trParams({
              'category': entry.key,
              'amount': entry.value.abs().toStringAsFixed(2),
            })} ${'currency_suffix'.tr}');
      }
    }

    return alerts;
  }

  // Reset Budget
  Future<void> resetBudget() async {
    try {
      monthlyBudget.value = 0.0;
      categoryBudgets.clear();
      _initializeDefaultBudgets();

      await SimpleEncryption.remove('monthlyBudget');
      await SimpleEncryption.remove('categoryBudgets');

      update();
      if (kDebugMode) {
        debugPrint('🔄 Budget reset successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Error resetting budget: $e');
      }
      // Fallback: Reset in memory even if storage fails
      monthlyBudget.value = 0.0;
      categoryBudgets.clear();
      _initializeDefaultBudgets();
      update();
    }
  }

  // Get default categories for display
  List<String> getDefaultCategoriesForDisplay() {
    return defaultCategories
        .map((String key) => _getDisplayCategory(key))
        .toList();
  }

  // Get default categories with keys
  Map<String, String> getDefaultCategoriesWithKeys() {
    final Map<String, String> result = <String, String>{};
    for (final String key in defaultCategories) {
      result[key] = _getDisplayCategory(key);
    }
    return result;
  }
}
