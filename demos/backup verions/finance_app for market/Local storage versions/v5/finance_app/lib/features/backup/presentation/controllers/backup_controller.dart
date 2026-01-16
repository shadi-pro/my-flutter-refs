// lib/features/backup/presentation/controllers/backup_controller.dart
import 'dart:convert';
import 'dart:io';
import 'package:finance_app/features/alerts/presentation/controllers/alert_controller.dart';
import 'package:finance_app/features/expense/presentation/controllers/budget_controller.dart';
import 'package:finance_app/features/expense/presentation/controllers/expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class BackupController extends GetxController {
  final _storage = GetStorage();
  final isLoading = false.obs;
  final lastBackupDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    loadLastBackupDate();
  }

  void loadLastBackupDate() {
    final dateStr = _storage.read('lastBackupDate');
    if (dateStr != null) {
      lastBackupDate.value = DateTime.parse(dateStr);
    }
  }

  // إنشاء نسخة احتياطية
  Future<void> createBackup() async {
    isLoading.value = true;

    try {
      // جمع جميع البيانات
      final Map<String, dynamic> backupData = {
        'appName': 'Finance App',
        'version': '1.0.0',
        'backupDate': DateTime.now().toIso8601String(),
        'expenses': _storage.read('expenses') ?? [],
        'monthlyBudget': _storage.read('monthlyBudget'),
        'categoryBudgets': _storage.read('categoryBudgets'),
        'alertSettings': {
          'budgetAlerts': _storage.read('budgetAlerts'),
          'largeExpenseAlerts': _storage.read('largeExpenseAlerts'),
          'dailySummary': _storage.read('dailySummary'),
        },
      };

      // تحويل إلى JSON
      final jsonData = jsonEncode(backupData);

      // حفظ في ملف
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final file = File('${directory.path}/finance_backup_$timestamp.json');
      await file.writeAsString(jsonData);

      // تحديث تاريخ آخر نسخة احتياطية
      lastBackupDate.value = DateTime.now();
      await _storage.write('lastBackupDate', DateTime.now().toIso8601String());

      Get.snackbar(
        '✅ تم الإنشاء',
        'تم إنشاء نسخة احتياطية بنجاح',
        snackPosition: SnackPosition.BOTTOM,
      );

      // مشاركة الملف
      await _shareBackupFile(file);
    } catch (e) {
      Get.snackbar(
        '❌ خطأ',
        'فشل في إنشاء النسخة الاحتياطية: $e',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // استعادة نسخة احتياطية
  Future<void> restoreBackup(String filePath) async {
    isLoading.value = true;

    try {
      final file = File(filePath);
      final jsonData = await file.readAsString();
      final backupData = jsonDecode(jsonData);

      // التحقق من صحة الملف
      if (backupData['appName'] != 'Finance App') {
        throw Exception('ملف غير صالح');
      }

      Get.defaultDialog(
        title: '⚠️ تأكيد الاستعادة',
        middleText:
            'سيتم استبدال جميع البيانات الحالية\nببيانات النسخة الاحتياطية',
        textConfirm: 'استعادة',
        textCancel: 'إلغاء',
        confirmTextColor: Colors.white,
        onConfirm: () async {
          Get.back();
          await _performRestore(backupData);
        },
      );
    } catch (e) {
      Get.snackbar(
        '❌ خطأ',
        'فشل في استعادة النسخة الاحتياطية: $e',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _performRestore(Map<String, dynamic> backupData) async {
    try {
      // استعادة البيانات
      await _storage.write('expenses', backupData['expenses'] ?? []);
      await _storage.write('monthlyBudget', backupData['monthlyBudget']);
      await _storage.write('categoryBudgets', backupData['categoryBudgets']);

      // استعادة إعدادات التنبيهات
      final alertSettings = backupData['alertSettings'] ?? {};
      await _storage.write('budgetAlerts', alertSettings['budgetAlerts']);
      await _storage.write(
          'largeExpenseAlerts', alertSettings['largeExpenseAlerts']);
      await _storage.write('dailySummary', alertSettings['dailySummary']);

      // تحديث Controllers
      if (Get.isRegistered<ExpenseController>()) {
        Get.find<ExpenseController>().loadExpenses();
      }
      if (Get.isRegistered<BudgetController>()) {
        Get.find<BudgetController>().loadBudgetData();
      }
      if (Get.isRegistered<AlertController>()) {
        Get.find<AlertController>().loadAlertSettings();
      }

      Get.snackbar(
        '✅ تم الاستعادة',
        'تم استعادة البيانات بنجاح',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      rethrow;
    }
  }

  // مشاركة ملف النسخة الاحتياطية
  Future<void> _shareBackupFile(File file) async {
    try {
      await Share.shareXFiles(
        [XFile(file.path)],
        text:
            'نسخة احتياطية من Finance App - ${DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now())}',
      );
    } catch (e) {
      print('خطأ في المشاركة: $e');
    }
  }

  // الحصول على معلومات النسخة الاحتياطية
  String get backupInfo {
    if (lastBackupDate.value == null) {
      return 'لا توجد نسخ احتياطية';
    }

    final diff = DateTime.now().difference(lastBackupDate.value!);

    if (diff.inDays > 0) {
      return 'آخر نسخة منذ ${diff.inDays} يوم';
    } else if (diff.inHours > 0) {
      return 'آخر نسخة منذ ${diff.inHours} ساعة';
    } else {
      return 'آخر نسخة منذ ${diff.inMinutes} دقيقة';
    }
  }

  // تصدير بيانات بسيطة (مشاركة نصية)
  Future<void> exportSimpleBackup() async {
    try {
      final expenses = _storage.read('expenses') ?? [];
      final totalIncome = expenses
          .where((e) => e['isIncome'] == true)
          .fold(0.0, (sum, e) => sum + (e['amount'] as num).toDouble());
      final totalExpense = expenses
          .where((e) => e['isIncome'] == false)
          .fold(0.0, (sum, e) => sum + (e['amount'] as num).toDouble());

      final report = '''
📊 تقرير Finance App
📅 ${DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now())}

📈 إجمالي الدخل: ${totalIncome.toStringAsFixed(2)} ج.م
📉 إجمالي المصروفات: ${totalExpense.toStringAsFixed(2)} ج.م
💰 الرصيد: ${(totalIncome - totalExpense).toStringAsFixed(2)} ج.م
🔢 عدد المعاملات: ${expenses.length}

--- المعاملات ---
${expenses.map((e) => '${e['isIncome'] ? '⬇️' : '⬆️'} ${e['amount']} ج.م - ${e['category']} - ${DateFormat('yyyy/MM/dd').format(DateTime.parse(e['date']))}').join('\n')}
      ''';

      await Share.share(report, subject: 'تقرير Finance App');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تصدير التقرير');
    }
  }
}
