// lib/features/backup/presentation/controllers/backup_controller.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

// Importing other controllers
import 'package:finance_app/features/expense/presentation/controllers/expense_controller.dart';
import 'package:finance_app/features/expense/presentation/controllers/budget_controller.dart';
import 'package:finance_app/features/alerts/presentation/controllers/alert_controller.dart';
import 'package:finance_app/features/search/presentation/controllers/expense_search_controller.dart';

class BackupController extends GetxController {
  final GetStorage _storage = GetStorage();
  final RxBool isLoading = false.obs;
  final Rx<DateTime?> lastBackupDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    loadLastBackupDate();
  }

  // Load Last Backup Date
  void loadLastBackupDate() {
    final String? dateStr = _storage.read('lastBackupDate');
    if (dateStr != null) {
      lastBackupDate.value = DateTime.parse(dateStr);
    }
  }

  // 1. Create full Backup version
  Future<void> createBackup() async {
    isLoading.value = true;

    try {
      // Collection all backup Data
      final Map<String, dynamic> backupData = <String, dynamic>{
        'appName': 'financeAppName'.tr,
        'version': 'appVersion'.tr,
        'backupDate': DateTime.now().toIso8601String(),
        'data': <String, dynamic>{
          'expenses': _storage.read('expenses') ?? <dynamic>[],
          'monthlyBudget': _storage.read('monthlyBudget'),
          'categoryBudgets': _storage.read('categoryBudgets'),
          'budgetAlerts': _storage.read('budgetAlerts'),
          'largeExpenseAlerts': _storage.read('largeExpenseAlerts'),
          'dailySummary': _storage.read('dailySummary'),
          'budgetThreshold': _storage.read('budgetThreshold'),
          'largeExpenseThreshold': _storage.read('largeExpenseThreshold'),
        },
      };

      // converting into JSON
      final String jsonData = jsonEncode(backupData);

      // Saving into File
      final Directory directory = await getApplicationDocumentsDirectory();
      final String timestamp =
          DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final File file =
          File('${directory.path}/finance_backup_$timestamp.json');
      await file.writeAsString(jsonData);

      // updating Last Backup Date
      lastBackupDate.value = DateTime.now();
      await _storage.write('lastBackupDate', DateTime.now().toIso8601String());

      Get.snackbar(
        '✅ ${'backupCreated'.tr}',
        'backupCreated'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );

      // sharing file
      await _shareBackupFile(file);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('❌ Backup error: $e');
        debugPrint('Stack trace: $stackTrace');
      }

      Get.snackbar(
        '❌ ${'backupCreationFailed'.tr}',
        '${'backupCreationFailed'.tr}: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 2. Restore Backup version
  Future<void> restoreBackup() async {
    try {
      // Picking up Backup file
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: <String>['json'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return; // User cancelled
      }

      final PlatformFile file = result.files.first;
      final String? filePath = file.path;

      if (filePath == null) {
        throw Exception('invalidFilePath'.tr);
      }

      isLoading.value = true;

      // Read and Analyze Backup file
      final File backupFile = File(filePath);
      final String jsonData = await backupFile.readAsString();
      final Map<String, dynamic> backupData =
          jsonDecode(jsonData) as Map<String, dynamic>;

      // checking if the backup file is correct
      if (backupData['appName'] != 'financeAppName'.tr) {
        throw Exception('invalidBackupFile'.tr);
      }

      // Confirmation window
      final bool proceed = await Get.dialog<bool>(
            AlertDialog(
              title: Row(
                children: <Widget>[
                  const Icon(Icons.warning, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text('restoreBackupWarning'.tr),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${'app'.tr}: ${backupData['appName']}'),
                  Text('${'version'.tr}: ${backupData['version']}'),
                  Text(
                      '${'backupDate'.tr}: ${DateFormat('yyyy/MM/dd HH:mm').format(DateTime.parse(backupData['backupDate'] as String))}'),
                  const SizedBox(height: 16),
                  Text(
                    'restoreWarningMessage'.tr,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'irreversibleAction'.tr,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: Text('cancel'.tr),
                ),
                ElevatedButton(
                  onPressed: () => Get.back(result: true),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('restore'.tr),
                ),
              ],
            ),
          ) ??
          false;

      if (!proceed) {
        isLoading.value = false;
        return;
      }

      // Perform Restore
      await _performRestore(backupData['data'] as Map<String, dynamic>);

      Get.snackbar(
        '✅ ${'backupRestored'.tr}',
        'backupRestored'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('❌ Restore error: $e');
        debugPrint('Stack trace: $stackTrace');
      }

      Get.snackbar(
        '❌ ${'restorationFailed'.tr}',
        '${'error'.tr}: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 3. Perform actual Restore
  Future<void> _performRestore(Map<String, dynamic> backupData) async {
    try {
      // first deleting the current data
      await _storage.erase();

      // Restore all data
      await _storage.write('expenses', backupData['expenses'] ?? <dynamic>[]);
      await _storage.write('monthlyBudget', backupData['monthlyBudget']);
      await _storage.write('categoryBudgets', backupData['categoryBudgets']);
      await _storage.write('budgetAlerts', backupData['budgetAlerts']);
      await _storage.write(
          'largeExpenseAlerts', backupData['largeExpenseAlerts']);
      await _storage.write('dailySummary', backupData['dailySummary']);
      await _storage.write('budgetThreshold', backupData['budgetThreshold']);
      await _storage.write(
          'largeExpenseThreshold', backupData['largeExpenseThreshold']);

      // second Updating Last Backup Date
      lastBackupDate.value = DateTime.now();
      await _storage.write('lastBackupDate', DateTime.now().toIso8601String());

      // Reload all controllers
      await _reloadAllControllers();
    } catch (e) {
      rethrow;
    }
  }

  // 4. Reload All Controllers after storing
  Future<void> _reloadAllControllers() async {
    try {
      // Expense Controller
      if (Get.isRegistered<ExpenseController>()) {
        final ExpenseController expenseController =
            Get.find<ExpenseController>();
        expenseController.loadExpenses();
      }

      // Budget Controller
      if (Get.isRegistered<BudgetController>()) {
        final BudgetController budgetController = Get.find<BudgetController>();
        budgetController.loadBudgetData();
      }

      // Alert Controller
      if (Get.isRegistered<AlertController>()) {
        final AlertController alertController = Get.find<AlertController>();
        alertController.loadAlertSettings();
      }

      // Search Controller
      if (Get.isRegistered<ExpenseSearchController>()) {
        final ExpenseSearchController searchController =
            Get.find<ExpenseSearchController>();
        searchController.resetFilters();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error reloading controllers: $e');
      }
    }
  }

  // 5. Share Backup File
  Future<void> _shareBackupFile(File file) async {
    try {
      await Share.shareXFiles(
        <XFile>[XFile(file.path)],
        text:
            '${'shareText'.tr} - ${DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now())}',
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Share error: $e');
      }
    }
  }

  // 6. Export Simple Backup by Textual Format
  Future<void> exportSimpleBackup() async {
    isLoading.value = true;

    try {
      // using ExpenseController to directly get data
      final ExpenseController expenseController = Get.find<ExpenseController>();
      final List<Map<String, dynamic>> expenses =
          expenseController.expensesAsMap;

      if (expenses.isEmpty) {
        Get.snackbar(
          '⚠️ ${'noDataToExport'.tr}',
          'noDataMessage'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange[100],
          colorText: Colors.orange[900],
        );
        isLoading.value = false;
        return;
      }

      // Calculating Statistics Correctly
      double totalIncome = 0;
      double totalExpense = 0;
      final Map<String, double> categoryTotals = <String, double>{};

      for (final Map<String, dynamic> expense in expenses) {
        final double amount = (expense['amount'] as num).toDouble();
        final bool isIncome = expense['isIncome'] == true;
        final String category = expense['category']?.toString() ?? 'unknown'.tr;

        if (isIncome) {
          totalIncome += amount;
        } else {
          totalExpense += amount;

          // Calculate the sum of each category
          categoryTotals.update(
            category,
            (double value) => value + amount,
            ifAbsent: () => amount,
          );
        }
      }

      // Building the report highly formatted
      final String report = '''
📊 ${'backupReportTitle'.tr}
📅 ${'backupReportDate'.tr}: ${_formatDateTime(DateTime.now())}

══════════════════════════════════════════
${'generalStatistics'.tr}:
══════════════════════════════════════════
• ${'totalTransactions'.tr}: ${expenses.length}
• ${'totalIncome'.tr}: ${totalIncome.toStringAsFixed(2)} ${'egyptianPound'.tr}
• ${'totalExpenses'.tr}: ${totalExpense.toStringAsFixed(2)} ${'egyptianPound'.tr}
• ${'netBalance'.tr}: ${(totalIncome - totalExpense).toStringAsFixed(2)} ${'egyptianPound'.tr}

══════════════════════════════════════════
${'expenseDistribution'.tr}:
══════════════════════════════════════════
${_buildCategoryReport(categoryTotals, totalExpense)}

══════════════════════════════════════════
${'recentTransactions'.tr}:
══════════════════════════════════════════
${_buildRecentTransactions(expenses, limit: 5)}

══════════════════════════════════════════
${'backupInfo'.tr}:
══════════════════════════════════════════
• ${'lastBackup'.tr}: ${lastBackupDate.value != null ? _formatDateTime(lastBackupDate.value!) : 'noBackupsCreated'.tr}
• ${'dataSize'.tr}: ${expenses.length} ${expenses.length == 1 ? 'transaction'.tr : 'transactions'.tr}
• ${'creationDate'.tr}: ${_formatDateTime(DateTime.now())}
══════════════════════════════════════════
''';

      // Sharing Report
      await Share.share(
        report,
        subject: '${'backupReportTitle'.tr} - ${_formatDate(DateTime.now())}',
      );

      Get.snackbar(
        '✅ ${'exportSuccess'.tr}',
        'reportShared'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('❌ Error in exportSimpleBackup: $e');
        debugPrint('Stack trace: $stackTrace');
      }

      Get.snackbar(
        '❌ ${'exportFailed'.tr}',
        'errorCreatingReport'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Assistance function for Building Category Report
  String _buildCategoryReport(
      Map<String, double> categories, double totalExpense) {
    if (categories.isEmpty) {
      return '• ${'noCategorizedExpenses'.tr}\n';
    }

    final List<MapEntry<String, double>> sortedCategories = categories.entries
        .toList()
      ..sort((MapEntry<String, double> a, MapEntry<String, double> b) =>
          b.value.compareTo(a.value));

    final StringBuffer report = StringBuffer();
    for (final MapEntry<String, double> entry in sortedCategories) {
      final double percentage =
          totalExpense > 0 ? (entry.value / totalExpense * 100) : 0;

      report.write(
          '• ${entry.key}: ${entry.value.toStringAsFixed(2)} ${'egyptianPound'.tr} (${percentage.toStringAsFixed(1)}%)\n');
    }

    return report.toString();
  }

  // Assistance function for Building Recent Transactions
  String _buildRecentTransactions(List<Map<String, dynamic>> expenses,
      {int limit = 5}) {
    // Checking for empty Expenses list
    if (expenses.isEmpty) {
      return '• ${'noRecentTransactions'.tr}\n';
    }

    // Copy List according to ascending Date
    final List<Map<String, dynamic>> recent =
        List<Map<String, dynamic>>.from(expenses);

    recent.sort((Map<String, dynamic> a, Map<String, dynamic> b) {
      try {
        final String? dateStrA = a['date']?.toString();
        final String? dateStrB = b['date']?.toString();

        if (dateStrA == null || dateStrB == null) return 0;

        final DateTime dateA = DateTime.parse(dateStrA);
        final DateTime dateB = DateTime.parse(dateStrB);

        return dateB.compareTo(dateA); // the recent first
      } catch (e) {
        return 0; // no change in order in case of error
      }
    });

    // Taking only the desired count
    final List<Map<String, dynamic>> limitedList = recent.take(limit).toList();

    if (limitedList.isEmpty) {
      return '• ${'noRecentTransactions'.tr}\n';
    }

    // Buffering the report
    final StringBuffer buffer = StringBuffer();

    for (final Map<String, dynamic> expense in limitedList) {
      try {
        final String? dateStr = expense['date']?.toString();
        if (dateStr == null) continue;

        final DateTime date = DateTime.parse(dateStr);
        final String formattedDate = _formatDate(date);
        final bool isIncome = expense['isIncome'] == true;
        final double amount = (expense['amount'] as num).toDouble();
        final String category = expense['category']?.toString() ?? 'unknown'.tr;
        final String description = expense['description']?.toString() ?? '';

        buffer.write('• $formattedDate: ');
        buffer.write(isIncome ? '⬇️ ${'income'.tr}' : '⬆️ ${'expense'.tr}');
        buffer.write(
            ' ${amount.toStringAsFixed(2)} ${'egyptianPound'.tr} (${'category'.tr}: $category)');

        if (description.isNotEmpty) {
          buffer.write(' - ${'description'.tr}: $description');
        }

        buffer.writeln();
      } catch (e) {
        // Skipping invalid transactions
        if (kDebugMode) {
          debugPrint('⚠️ ${'skipInvalidTransaction'.tr}: $e');
        }
        continue;
      }
    }

    return buffer.toString();
  }

  // Assistance function for date Formatting
  String _formatDate(DateTime date) {
    try {
      return DateFormat('yyyy/MM/dd').format(date);
    } catch (e) {
      return 'unknownDate'.tr;
    }
  }

  // Assistance function for Formatting Date and Time
  String _formatDateTime(DateTime date) {
    try {
      return DateFormat('yyyy/MM/dd HH:mm').format(date);
    } catch (e) {
      return 'unknownDate'.tr;
    }
  }

  // 7. Getting Info from lastBackupDate
  String get backupInfo {
    if (lastBackupDate.value == null) {
      return 'noBackupsCreated'.tr;
    }

    final Duration diff = DateTime.now().difference(lastBackupDate.value!);

    if (diff.inDays > 0) {
      return '${'lastBackup'.tr}: ${diff.inDays} ${'daysAgo'.tr}';
    } else if (diff.inHours > 0) {
      return '${'lastBackup'.tr}: ${diff.inHours} ${'hoursAgo'.tr}';
    } else if (diff.inMinutes > 0) {
      return '${'lastBackup'.tr}: ${diff.inMinutes} ${'minutesAgo'.tr}';
    } else {
      return '${'lastBackup'.tr}: ${'now'.tr}';
    }
  }

  // 8. Get Backup File(s) Count
  Future<int> getBackupFileCount() async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final int files = Directory(directory.path)
          .listSync()
          .where((FileSystemEntity entity) => entity.path.endsWith('.json'))
          .whereType<File>()
          .length;
      return files;
    } catch (e) {
      return 0;
    }
  }

  // 9. Removing the Data from the backup file
  Future<void> clearBackupData() async {
    try {
      final bool? confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: Text('clearBackupData'.tr),
          content: Text('confirmClearBackup'.tr),
          actions: <Widget>[
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('cancel'.tr),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('clear'.tr),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await _storage.remove('lastBackupDate');
        lastBackupDate.value = null;
        Get.snackbar(
          'dataClearedSuccess'.tr,
          'dataClearedSuccess'.tr,
        );
      }
    } catch (e) {
      Get.snackbar('error'.tr, 'clearFailedMessage'.tr);
    }
  }
}
