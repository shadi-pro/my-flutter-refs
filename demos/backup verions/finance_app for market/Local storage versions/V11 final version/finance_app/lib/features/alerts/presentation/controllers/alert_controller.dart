// lib/features/alerts/presentation/controllers/alert_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AlertController extends GetxController {
  final _storage = GetStorage();

  // إعدادات التنبيهات
  final budgetAlertsEnabled = true.obs;
  final largeExpenseAlertsEnabled = true.obs;
  final dailySummaryEnabled = false.obs;

  // عتبات التنبيهات
  final budgetAlertThreshold = 80.0.obs; // نسبة الميزانية
  final largeExpenseThreshold = 500.0.obs; // مبلغ كبير

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

  // التحقق من التنبيهات عند إضافة معاملة
  void checkExpenseAlerts(double amount, String category) {
    if (largeExpenseAlertsEnabled.value &&
        amount >= largeExpenseThreshold.value) {
      showLargeExpenseAlert(amount, category);
    }

    // سيتم إضافة تنبيهات الميزانية لاحقاً
  }

  void showLargeExpenseAlert(double amount, String category) {
    Get.snackbar(
      'مصروف كبير! 💸',
      'لقد أنفقت $amount ج.م على $category',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.orange[100],
      colorText: Colors.orange[900],
    );
  }

  // تنبيهات الميزانية
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
      'تنبيه الميزانية ⚠️',
      'لقد أنفقت ${percentage.toStringAsFixed(1)}% من ميزانيتك\nالمتبقي: ${remaining.toStringAsFixed(2)} ج.م',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.orange[100],
      colorText: Colors.orange[900],
    );
  }

  void showBudgetExceededAlert(double exceededAmount) {
    Get.snackbar(
      'تجاوز الميزانية! 🚨',
      'لقد تجاوزت ميزانيتك بمقدار ${exceededAmount.toStringAsFixed(2)} ج.م',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red[100],
      colorText: Colors.red[900],
    );
  }

  // ملخص يومي
  void showDailySummary(double dailyIncome, double dailyExpense) {
    if (!dailySummaryEnabled.value) return;

    Get.defaultDialog(
      title: 'ملخص اليوم 📊',
      middleText: 'الدخل: ${dailyIncome.toStringAsFixed(2)} ج.م\n'
          'المصروفات: ${dailyExpense.toStringAsFixed(2)} ج.م\n'
          'الصافي: ${(dailyIncome - dailyExpense).toStringAsFixed(2)} ج.م',
      textConfirm: 'حسناً',
      onConfirm: Get.back,
    );
  }
}
