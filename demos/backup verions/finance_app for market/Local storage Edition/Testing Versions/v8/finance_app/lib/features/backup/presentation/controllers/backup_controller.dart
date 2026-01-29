// lib/features/backup/presentation/controllers/backup_controller.dart

import 'dart:convert';
import 'dart:io';
import 'package:finance_app/features/alerts/presentation/controllers/alert_controller.dart';
import 'package:finance_app/features/expense/presentation/controllers/budget_controller.dart';
import 'package:finance_app/features/expense/presentation/controllers/expense_controller.dart';
import 'package:finance_app/features/search/presentation/controllers/expense_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

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

  // 1. Create Backup
  Future<void> createBackup() async {
    isLoading.value = true;

    try {
      // Collect all data
      final Map<String, dynamic> backupData = {
        'appName': 'Finance App',
        'version': '1.0.0',
        'backupDate': DateTime.now().toIso8601String(),
        'data': {
          'expenses': _storage.read('expenses') ?? [],
          'monthlyBudget': _storage.read('monthlyBudget'),
          'categoryBudgets': _storage.read('categoryBudgets'),
          'budgetAlerts': _storage.read('budgetAlerts'),
          'largeExpenseAlerts': _storage.read('largeExpenseAlerts'),
          'dailySummary': _storage.read('dailySummary'),
          'budgetThreshold': _storage.read('budgetThreshold'),
          'largeExpenseThreshold': _storage.read('largeExpenseThreshold'),
        },
      };

      // Convert to JSON
      final jsonData = jsonEncode(backupData);

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final file = File('${directory.path}/finance_backup_$timestamp.json');
      await file.writeAsString(jsonData);

      // Update last backup date
      lastBackupDate.value = DateTime.now();
      await _storage.write('lastBackupDate', DateTime.now().toIso8601String());

      Get.snackbar(
        '✅ Backup Created',
        'Backup created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Share the file
      await _shareBackupFile(file);
    } catch (e) {
      Get.snackbar(
        '❌ Error',
        'Failed to create backup: $e',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 2. Restore Backup - COMPLETE IMPLEMENTATION
  Future<void> restoreBackup() async {
    try {
      // Pick backup file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return; // User cancelled
      }

      PlatformFile file = result.files.first;
      final filePath = file.path;

      if (filePath == null) {
        throw Exception('Invalid file path');
      }

      isLoading.value = true;

      // Read and parse the backup file
      final backupFile = File(filePath);
      final jsonData = await backupFile.readAsString();
      final backupData = jsonDecode(jsonData);

      // Validate backup file
      if (backupData['appName'] != 'Finance App') {
        throw Exception('Invalid backup file: Not a Finance App backup');
      }

      // Show confirmation dialog
      final bool proceed = await Get.dialog<bool>(
            AlertDialog(
              title: const Text('⚠️ Restore Backup'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('App: ${backupData['appName']}'),
                  Text('Version: ${backupData['version']}'),
                  Text(
                      'Backup Date: ${DateFormat('yyyy/MM/dd HH:mm').format(DateTime.parse(backupData['backupDate']))}'),
                  const SizedBox(height: 16),
                  const Text(
                    '⚠️ This will replace ALL current data with backup data!',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Get.back(result: true),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Restore'),
                ),
              ],
            ),
          ) ??
          false;

      if (!proceed) {
        isLoading.value = false;
        return;
      }

      // Perform restore
      await _performRestore(backupData['data']);

      Get.snackbar(
        '✅ Restore Complete',
        'All data has been restored successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        '❌ Restore Failed',
        'Error: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 3. Perform actual restore
  Future<void> _performRestore(Map<String, dynamic> backupData) async {
    try {
      // Clear existing data first
      await _storage.erase();

      // Restore all data
      await _storage.write('expenses', backupData['expenses'] ?? []);
      await _storage.write('monthlyBudget', backupData['monthlyBudget']);
      await _storage.write('categoryBudgets', backupData['categoryBudgets']);
      await _storage.write('budgetAlerts', backupData['budgetAlerts']);
      await _storage.write(
          'largeExpenseAlerts', backupData['largeExpenseAlerts']);
      await _storage.write('dailySummary', backupData['dailySummary']);
      await _storage.write('budgetThreshold', backupData['budgetThreshold']);
      await _storage.write(
          'largeExpenseThreshold', backupData['largeExpenseThreshold']);

      // Update last backup date
      lastBackupDate.value = DateTime.now();
      await _storage.write('lastBackupDate', DateTime.now().toIso8601String());

      // Reload all controllers
      await _reloadAllControllers();
    } catch (e) {
      rethrow;
    }
  }

  // 4. Reload all controllers after restore
  Future<void> _reloadAllControllers() async {
    try {
      // Expense Controller
      if (Get.isRegistered<ExpenseController>()) {
        final expenseController = Get.find<ExpenseController>();
        expenseController.loadExpenses();
      }

      // Budget Controller
      if (Get.isRegistered<BudgetController>()) {
        final budgetController = Get.find<BudgetController>();
        budgetController.loadBudgetData();
      }

      // Alert Controller
      if (Get.isRegistered<AlertController>()) {
        final alertController = Get.find<AlertController>();
        alertController.loadAlertSettings();
      }

      // Search Controller
      if (Get.isRegistered<ExpenseSearchController>()) {
        final searchController = Get.find<ExpenseSearchController>();
        searchController.resetFilters();
      }
    } catch (e) {
      print('Error reloading controllers: $e');
    }
  }

  // 5. Share backup file
  Future<void> _shareBackupFile(File file) async {
    try {
      await Share.shareXFiles(
        [XFile(file.path)],
        text:
            'Finance App Backup - ${DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now())}',
      );
    } catch (e) {
      print('Share error: $e');
    }
  }

  // 6. Simple export (text format)
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
📊 Finance App Report
📅 ${DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now())}

📈 Total Income: ${totalIncome.toStringAsFixed(2)} EGP
📉 Total Expense: ${totalExpense.toStringAsFixed(2)} EGP
💰 Balance: ${(totalIncome - totalExpense).toStringAsFixed(2)} EGP
🔢 Transactions: ${expenses.length}

--- Transactions ---
${expenses.map((e) => '${e['isIncome'] ? '⬇️' : '⬆️'} ${e['amount']} EGP - ${e['category']} - ${DateFormat('yyyy/MM/dd').format(DateTime.parse(e['date']))}').join('\n')}
      ''';

      await Share.share(report, subject: 'Finance App Report');
    } catch (e) {
      Get.snackbar('Error', 'Failed to export report');
    }
  }

  // 7. Get backup info
  String get backupInfo {
    if (lastBackupDate.value == null) {
      return 'No backups found';
    }

    final diff = DateTime.now().difference(lastBackupDate.value!);

    if (diff.inDays > 0) {
      return 'Last backup: ${diff.inDays} days ago';
    } else if (diff.inHours > 0) {
      return 'Last backup: ${diff.inHours} hours ago';
    } else {
      return 'Last backup: ${diff.inMinutes} minutes ago';
    }
  }

  // 8. Get backup file count
  Future<int> getBackupFileCount() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = Directory(directory.path)
          .listSync()
          .where((entity) => entity.path.endsWith('.json'))
          .where((entity) => entity is File)
          .length;
      return files;
    } catch (e) {
      return 0;
    }
  }
}
