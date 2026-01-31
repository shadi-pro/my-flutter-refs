//  lib/features/export/presentation/export_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:finance_app/features/expense/presentation/controllers/expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';

class ExportService {
  // Main export function called by reports_page
  static Future<bool> exportData(List<Map<String, dynamic>> expenses) async {
    try {
      // Check if data exists
      if (expenses.isEmpty) {
        Get.snackbar(
          'export_no_data_title'.tr,
          'export_no_data_message'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange[100],
          colorText: Colors.orange[900],
        );
        return false;
      }

      final exportFormat = await _showExportFormatDialog();
      if (exportFormat == null) return false;

      switch (exportFormat) {
        case 'csv':
          await _exportToCSV(expenses);
          break;
        case 'json':
          await _exportToJSON(expenses);
          break;
        default:
          return false;
      }

      return true;
    } catch (e) {
      Get.snackbar(
        'export_error_title'.tr,
        'export_unexpected_error'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return false;
    }
  }

  //  Alternative function called directly by reports_page
  static Future<bool> exportSummary() async {
    try {
      // Get controller
      final expenseController = Get.find<ExpenseController>();
      final expenses = expenseController.expensesAsMap;

      return await exportData(expenses);
    } catch (e) {
      Get.snackbar(
        'export_error_title'.tr,
        'export_data_access_error'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  //  Show export format options
  static Future<String?> _showExportFormatDialog() async {
    return await Get.dialog<String>(
      AlertDialog(
        title: Text('export_choose_format'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.blue),
              title: Text('export_format_csv'.tr),
              subtitle: Text('export_format_csv_desc'.tr),
              onTap: () => Get.back(result: 'csv'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.code, color: Colors.green),
              title: Text('export_format_json'.tr),
              subtitle: Text('export_format_json_desc'.tr),
              onTap: () => Get.back(result: 'json'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  //  Export to CSV
  static Future<void> _exportToCSV(List<Map<String, dynamic>> expenses) async {
    try {
      final List<List<dynamic>> csvData = [];

      // File header
      csvData.add([
        'export_csv_header_date'.tr,
        'export_csv_header_type'.tr,
        'export_csv_header_category'.tr,
        'export_csv_header_amount'.tr,
        'export_csv_header_description'.tr,
        'export_csv_header_payment'.tr,
      ]);

      // Data
      for (var expense in expenses) {
        final date = expense['date']?.toString() ?? '';
        final isIncome = expense['isIncome'] == true;
        final category = expense['category']?.toString() ?? 'export_unknown'.tr;
        final amount = expense['amount']?.toString() ?? '0.00';
        final description = expense['description']?.toString() ?? '';
        final paymentMethod =
            expense['paymentMethod']?.toString() ?? 'export_cash'.tr;

        csvData.add([
          date,
          isIncome ? 'export_type_income'.tr : 'export_type_expense'.tr,
          category,
          amount,
          description,
          paymentMethod,
        ]);
      }

      // Convert to CSV text
      final csvString = const ListToCsvConverter().convert(csvData);

      // Save file temporarily
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${'export_file_prefix'.tr}_$timestamp.csv';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(csvString, flush: true);

      // Share file
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'export_subject_finance'.tr,
        text: 'export_share_text'.trParams({
          'count': expenses.length.toString(),
          'date': _formatDate(DateTime.now())
        }),
      );
    } catch (e) {
      rethrow;
    }
  }

  //  Export to JSON
  static Future<void> _exportToJSON(List<Map<String, dynamic>> expenses) async {
    try {
      // Calculate statistics
      double totalIncome = 0;
      double totalExpense = 0;

      for (var expense in expenses) {
        if (expense['isIncome'] == true) {
          totalIncome += (expense['amount'] as num).toDouble();
        } else {
          totalExpense += (expense['amount'] as num).toDouble();
        }
      }

      // Create structured JSON data
      final exportData = {
        'appName': 'export_app_name'.tr,
        'exportDate': DateTime.now().toIso8601String(),
        'exportDateFormatted': _formatDate(DateTime.now()),
        'statistics': {
          'totalTransactions': expenses.length,
          'totalIncome': totalIncome,
          'totalExpense': totalExpense,
          'balance': totalIncome - totalExpense,
        },
        'transactions': expenses,
      };

      // Convert to JSON
      final jsonString = jsonEncode(exportData);
      final prettyJson = JsonEncoder.withIndent('  ').convert(exportData);

      // Save file
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${'export_file_prefix'.tr}_$timestamp.json';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(prettyJson, flush: true);

      // Share file
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'export_subject_json'.tr,
        text: 'export_share_json'.tr,
      );
    } catch (e) {
      rethrow;
    }
  }

  //  Helper function to format date
  static String _formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd HH:mm', Get.locale?.languageCode ?? 'en')
        .format(date);
  }

  //  Get information about exported files
  static Future<List<FileSystemEntity>> getExportFiles() async {
    try {
      final directory = await getTemporaryDirectory();
      final files = Directory(directory.path)
          .listSync()
          .where((entity) =>
              entity.path.contains('export_file_prefix'.tr) &&
              (entity.path.endsWith('.csv') || entity.path.endsWith('.json')))
          .toList();

      // Sort by date (newest first)
      files.sort(
          (a, b) => b.statSync().modified.compareTo(a.statSync().modified));

      return files;
    } catch (e) {
      return [];
    }
  }

  // Clean old exported files
  static Future<void> cleanOldExports({int keepLastDays = 7}) async {
    try {
      final files = await getExportFiles();
      final cutoffDate = DateTime.now().subtract(Duration(days: keepLastDays));

      for (var file in files) {
        final stat = file.statSync();
        if (stat.modified.isBefore(cutoffDate)) {
          await file.delete();
        }
      }
    } catch (e) {}
  }
}
