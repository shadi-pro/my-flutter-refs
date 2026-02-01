// lib/features/expense/presentation/controllers/budget_controller.dart

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:finance_app/features/expense/presentation/controllers/expense_controller.dart';
import 'package:finance_app/core/security/simple_encryption.dart';
// ✅ ADD IMPORT for ExpenseCategory
import 'package:finance_app/core/models/enums.dart';

class BudgetController extends GetxController {
  final _storage = GetStorage();

  // Monthly budget
  final monthlyBudget = 0.0.obs;

  // Budgets according to Categories
  final categoryBudgets = <String, double>{}.obs;

  // ✅ FIXED: Use translation keys instead of Arabic text
  final List<String> defaultCategories = [
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
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }

  // Helper: Convert Arabic text to translation key
  String _arabicToKey(String arabicText) {
    try {
      final category = ExpenseCategory.fromString(arabicText);
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
      final matchingCategory = ExpenseCategory.values.firstWhere(
          (cat) => cat.translationKey == categoryKey,
          orElse: () => ExpenseCategory.other);
      return matchingCategory.translationKey.tr;
    } catch (e) {
      // If it's Arabic (old data), convert and display
      if (_isArabicText(categoryKey)) {
        try {
          final category = ExpenseCategory.fromString(categoryKey);
          return category.translationKey.tr;
        } catch (e) {
          return categoryKey;
        }
      }
      return categoryKey;
    }
  }

  // loading main Budget Data
  Future<void> loadBudgetData() async {
    try {
      final storedMonthlyBudget = SimpleEncryption.read('monthlyBudget');
      monthlyBudget.value = (storedMonthlyBudget as num?)?.toDouble() ?? 0.0;

      final storedCategoryBudgets =
          SimpleEncryption.read('categoryBudgets') ?? {};

      //  Handle migration from Arabic to keys
      final migratedBudgets = <String, double>{};

      if (storedCategoryBudgets is Map) {
        for (var entry in (storedCategoryBudgets).entries) {
          final key = entry.key.toString();
          final value = (entry.value as num).toDouble();

          // Convert Arabic keys to translation keys
          if (_isArabicText(key)) {
            final migratedKey = _arabicToKey(key);
            migratedBudgets[migratedKey] = value;
          } else {
            migratedBudgets[key] = value;
          }
        }
      }

      categoryBudgets.value = migratedBudgets;

      // Initialize the Budgets Categories if they are empty
      if (categoryBudgets.isEmpty) {
        for (var categoryKey in defaultCategories) {
          categoryBudgets[categoryKey] = 0.0;
        }
      }

      print('✅ Budget data loaded successfully');
    } catch (e) {
      print('⚠️ Error loading budget data: $e');
      _initializeDefaultBudgets();
    }
  }

  // Initialize Default Budgets
  void _initializeDefaultBudgets() {
    for (var categoryKey in defaultCategories) {
      categoryBudgets[categoryKey] = 0.0;
    }
    monthlyBudget.value = 0.0;
  }

  // Update Monthly Budget
  Future<void> setMonthlyBudget(double amount) async {
    monthlyBudget.value = amount;
    await SimpleEncryption.write('monthlyBudget', amount);
    update();
    print('💰 Monthly budget updated: $amount');
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
      for (var cat in ExpenseCategory.values) {
        if (cat.translationKey.tr == category) {
          categoryKey = cat.translationKey;
          break;
        }
      }
    }

    categoryBudgets[categoryKey] = amount;
    await _saveCategoryBudgets();
    update();
    print('📊 Category budget updated: $categoryKey = $amount');
  }

  // Get category budget by key
  double? getCategoryBudgetByKey(String categoryKey) {
    return categoryBudgets[categoryKey];
  }

  // Get category budget by display text
  double? getCategoryBudgetByDisplay(String displayText) {
    for (var category in ExpenseCategory.values) {
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
    return categoryBudgets.values.fold(0.0, (sum, budget) => sum + budget);
  }

  // Checking for not exceeding the Budget
  double get remainingBudget {
    final expenseController = Get.find<ExpenseController>();
    return monthlyBudget.value - expenseController.totalExpense.value;
  }

  // Calculating expense percentage of Budget
  double get spendingPercentage {
    if (monthlyBudget.value <= 0) return 0;
    final expenseController = Get.find<ExpenseController>();
    return (expenseController.totalExpense.value / monthlyBudget.value) * 100;
  }

  // Getting remaining budget for each category
  Map<String, double> getRemainingCategoryBudgets() {
    final expenseController = Get.find<ExpenseController>();
    final categoryExpenses = expenseController.getExpensesByCategory(false);

    final Map<String, double> remaining = {};

    for (var categoryKey in categoryBudgets.keys) {
      final budget = categoryBudgets[categoryKey] ?? 0.0;

      // Get expenses for this category (need to match by key)
      double spent = 0.0;
      for (var expense in expenseController.expenses) {
        if (!expense.isIncome &&
            expense.category.translationKey == categoryKey) {
          spent += expense.amount;
        }
      }

      remaining[categoryKey] = budget - spent;
    }

    return remaining;
  }

  // Get remaining budget for display (with translated category names)
  Map<String, double> getRemainingCategoryBudgetsForDisplay() {
    final remaining = getRemainingCategoryBudgets();
    final displayMap = <String, double>{};

    for (var entry in remaining.entries) {
      final displayName = _getDisplayCategory(entry.key);
      displayMap[displayName] = entry.value;
    }

    return displayMap;
  }

  // Get all categories for display (with translated names)
  Map<String, double> getCategoryBudgetsForDisplay() {
    final displayMap = <String, double>{};

    for (var entry in categoryBudgets.entries) {
      final displayName = _getDisplayCategory(entry.key);
      displayMap[displayName] = entry.value;
    }

    return displayMap;
  }

  // get Budget Alerts
  List<String> getBudgetAlerts() {
    final List<String> alerts = [];
    final expenseController = Get.find<ExpenseController>();

    // Budget Alert of high Expense
    if (spendingPercentage >= 80) {
      alerts.add('⚠️ ${'spent_percentage'.trParams({
            'value': spendingPercentage.toStringAsFixed(0)
          })}');
    }

    if (spendingPercentage >= 100) {
      alerts.add('category_budget_exceeded'.tr);
    }

    // Category Alerts
    final remainingBudgets = getRemainingCategoryBudgetsForDisplay();
    for (var entry in remainingBudgets.entries) {
      if (entry.value < 0) {
        alerts.add('📌 ${'exceeded_budget_for'.trParams({
              'category': entry.key,
              'amount': entry.value.abs().toStringAsFixed(2)
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
      print('🔄 Budget reset successfully');
    } catch (e) {
      print('⚠️ Error resetting budget: $e');
      // Fallback: Reset in memory even if storage fails
      monthlyBudget.value = 0.0;
      categoryBudgets.clear();
      _initializeDefaultBudgets();
      update();
    }
  }

  // Get default categories for display
  List<String> getDefaultCategoriesForDisplay() {
    return defaultCategories.map((key) => _getDisplayCategory(key)).toList();
  }

  // Get default categories with keys
  Map<String, String> getDefaultCategoriesWithKeys() {
    final Map<String, String> result = {};
    for (var key in defaultCategories) {
      result[key] = _getDisplayCategory(key);
    }
    return result;
  }
}
