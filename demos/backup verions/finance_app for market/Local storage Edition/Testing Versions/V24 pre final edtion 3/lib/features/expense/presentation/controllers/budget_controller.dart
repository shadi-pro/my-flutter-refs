// finance_app\lib\features\expense\presentation\controllers\budget_controller.dart

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:finance_app/features/expense/presentation/controllers/expense_controller.dart';
import 'package:finance_app/core/security/simple_encryption.dart';

class BudgetController extends GetxController {
  final _storage = GetStorage();

  // Monthly budget
  final monthlyBudget = 0.0.obs;

  //  Budgets according to  Categories
  final categoryBudgets = <String, double>{}.obs;

  // Bais Categories in Budget
  final List<String> defaultCategories = [
    'طعام',
    'مواصلات',
    'تسوق',
    'ترفيه',
    'صحة',
    'تعليم',
    'سكن',
    'فواتير',
  ];

  @override
  void onInit() {
    super.onInit();
    loadBudgetData();
  }

  // loading main Budget Data
  Future<void> loadBudgetData() async {
    try {
      final storedMonthlyBudget = SimpleEncryption.read('monthlyBudget');
      monthlyBudget.value = (storedMonthlyBudget as num?)?.toDouble() ?? 0.0;

      final storedCategoryBudgets =
          SimpleEncryption.read('categoryBudgets') ?? {};
      categoryBudgets.value = Map<String, double>.from(storedCategoryBudgets);

      // Initilizing the Budgets Categories if it are empty
      if (categoryBudgets.isEmpty) {
        for (var category in defaultCategories) {
          categoryBudgets[category] = 0.0;
        }
      }

      print('✅ Budget data loaded successfully');
    } catch (e) {
      // print('خطأ في تحميل بيانات الميزانية: $e');
      _initializeDefaultBudgets();
    }
  }

  //  Initilizing Default Budgets
  void _initializeDefaultBudgets() {
    for (var category in defaultCategories) {
      categoryBudgets[category] = 0.0;
    }
    monthlyBudget.value = 0.0;
  }

  // Update  Monthly Budget
  Future<void> setMonthlyBudget(double amount) async {
    monthlyBudget.value = amount;

    await SimpleEncryption.write('monthlyBudget', amount);

    update();
    // print('💰 Monthly budget updated: $amount');
  }

  //  Setting a budget with a certain cagerory
  Future<void> setCategoryBudget(String category, double amount) async {
    categoryBudgets[category] = amount;
    await _saveCategoryBudgets();
    update();
    // print('📊 Category budget updated: $category = $amount');
  }

  // Save a budget with a certain category
  Future<void> _saveCategoryBudgets() async {
    await SimpleEncryption.write('categoryBudgets', categoryBudgets);
  }

  double get totalCategoryBudgets {
    return categoryBudgets.values.fold(0.0, (sum, budget) => sum + budget);
  }

  // Checking for un exceed the Budget
  double get remainingBudget {
    final expenseController = Get.find<ExpenseController>();
    return monthlyBudget.value - expenseController.totalExpense.value;
  }

  // Calculating  expense percentage  of  Budget
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

    for (var category in categoryBudgets.keys) {
      final budget = categoryBudgets[category] ?? 0.0;
      final spent = categoryExpenses[category] ?? 0.0;
      remaining[category] = budget - spent;
    }

    return remaining;
  }

  // get Budget Alerts
  List<String> getBudgetAlerts() {
    final List<String> alerts = [];
    final expenseController = Get.find<ExpenseController>();

    // Budget Alert of high Expense
    if (spendingPercentage >= 80) {
      alerts.add(
          '⚠️ أنت أنفقت ${spendingPercentage.toStringAsFixed(0)}% من ميزانيتك');
    }

    if (spendingPercentage >= 100) {
      alerts.add('category_budget_exceeded'.tr);
    }

    //  Category Alets
    final remainingBudgets = getRemainingCategoryBudgets();
    for (var entry in remainingBudgets.entries) {
      if (entry.value < 0) {
        alerts.add(
            '📌 تجاوزت ميزانية "${entry.key}" بمقدار ${entry.value.abs().toStringAsFixed(2)} ج.م');
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
      // print('🔄 تم إعادة تعيين الميزانية');
    } catch (e) {
      // print('⚠️ خطأ في إعادة تعيين الميزانية: $e');
      // Fallback: Reset in memory even if storage fails
      monthlyBudget.value = 0.0;
      categoryBudgets.clear();
      _initializeDefaultBudgets();
      update();
    }
  }
}
