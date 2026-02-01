//   lib/features/alerts/presentation/controllers/alert_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AlertController extends GetxController {
  final _storage = GetStorage();

  // Alert settings
  final budgetAlertsEnabled = true.obs;
  final largeExpenseAlertsEnabled = true.obs;
  final dailySummaryEnabled = false.obs;

  // Alert thresholds
  final budgetAlertThreshold = 80.0.obs; // Percentage
  final largeExpenseThreshold = 500.0.obs; // Large amount

  @override
  void onInit() {
    super.onInit();
    loadAlertSettings();
  }

  void loadAlertSettings() {
    budgetAlertsEnabled.value = _storage.read('budgetAlerts') ?? true;
    largeExpenseAlertsEnabled.value =
        _storage.read('largeExpenseAlerts') ?? true;
    dailySummaryEnabled.value = _storage.read('dailySummary') ?? false;
    budgetAlertThreshold.value = _storage.read('budgetThreshold') ?? 80.0;
    largeExpenseThreshold.value =
        _storage.read('largeExpenseThreshold') ?? 500.0;
  }

  Future<void> saveAlertSettings() async {
    await _storage.write('budgetAlerts', budgetAlertsEnabled.value);
    await _storage.write('largeExpenseAlerts', largeExpenseAlertsEnabled.value);
    await _storage.write('dailySummary', dailySummaryEnabled.value);
    await _storage.write('budgetThreshold', budgetAlertThreshold.value);
    await _storage.write('largeExpenseThreshold', largeExpenseThreshold.value);
  }

  // Check alerts when adding expense
  void checkExpenseAlerts(double amount, String category, bool isIncome) {
    // Check that transaction is not income
    if (isIncome) return;

    if (largeExpenseAlertsEnabled.value &&
        amount >= largeExpenseThreshold.value) {
      showLargeExpenseAlert(amount, category);
    }
  }

  void showLargeExpenseAlert(double amount, String category) {
    Get.snackbar(
      'large_expense_alert_title'.tr,
      'large_expense_message'.trParams(
          {'amount': amount.toStringAsFixed(2), 'category': category}),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.orange[100],
      colorText: Colors.orange[900],
    );
  }

  // Budget alerts
  void checkBudgetAlerts(double spentPercentage, double remainingBudget) {
    if (!budgetAlertsEnabled.value) return;

    if (spentPercentage >= budgetAlertThreshold.value) {
      showBudgetAlert(spentPercentage, remainingBudget);
    }

    if (remainingBudget < 0) {
      showBudgetExceededAlert(remainingBudget.abs());
    }
  }

  void showBudgetAlert(double percentage, double remaining) {
    Get.snackbar(
      'budget_alert_title'.tr,
      'budget_alert_message'.trParams({
        'percentage': percentage.toStringAsFixed(1),
        'remaining': remaining.toStringAsFixed(2)
      }),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.orange[100],
      colorText: Colors.orange[900],
    );
  }

  void showBudgetExceededAlert(double exceededAmount) {
    Get.snackbar(
      'budget_exceeded_title'.tr,
      'budget_exceeded_message'
          .trParams({'amount': exceededAmount.toStringAsFixed(2)}),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red[100],
      colorText: Colors.red[900],
    );
  }

  // Daily summary
  void showDailySummary(double dailyIncome, double dailyExpense) {
    if (!dailySummaryEnabled.value) return;

    Get.defaultDialog(
      title: 'daily_summary_title'.tr,
      middleText: 'daily_summary_content'.trParams({
        'income': dailyIncome.toStringAsFixed(2),
        'expense': dailyExpense.toStringAsFixed(2),
        'net': (dailyIncome - dailyExpense).toStringAsFixed(2)
      }),
      textConfirm: 'ok'.tr,
      onConfirm: Get.back,
    );
  }
}
