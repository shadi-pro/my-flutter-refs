// lib/features/export/presentation/export_service.dart

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
  // ✅ دالة التصدير الأساسية التي تستدعيها reports_page
  static Future<bool> exportData(List<Map<String, dynamic>> expenses) async {
    try {
      // التحقق من وجود بيانات
      if (expenses.isEmpty) {
        Get.snackbar(
          '⚠️ لا توجد بيانات',
          'لا توجد معاملات لتصديرها',
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
      print('❌ Export error: $e');
      Get.snackbar(
        '❌ خطأ في التصدير',
        'حدث خطأ غير متوقع',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return false;
    }
  }

  // ✅ دالة بديلة تستدعيها reports_page مباشرة (حسب الكود السابق)
  static Future<bool> exportSummary() async {
    try {
      // جلب المتحكم
      final expenseController = Get.find<ExpenseController>();
      final expenses = expenseController.expensesAsMap;

      return await exportData(expenses);
    } catch (e) {
      print('❌ Export summary error: $e');
      Get.snackbar(
        '❌ خطأ',
        'تعذر الوصول إلى البيانات',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  // ✅ عرض خيارات التصدير
  static Future<String?> _showExportFormatDialog() async {
    return await Get.dialog<String>(
      AlertDialog(
        title: const Text('📤 اختر صيغة التصدير'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.blue),
              title: const Text('CSV (Excel)'),
              subtitle: const Text('ملف جدول يمكن فتحه في Excel'),
              onTap: () => Get.back(result: 'csv'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.code, color: Colors.green),
              title: const Text('JSON'),
              subtitle: const Text('ملف بيانات قابل للقراءة'),
              onTap: () => Get.back(result: 'json'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  // ✅ تصدير إلى CSV
  static Future<void> _exportToCSV(List<Map<String, dynamic>> expenses) async {
    try {
      final List<List<dynamic>> csvData = [];

      // رأس الملف
      csvData.add([
        'التاريخ',
        'النوع',
        'الفئة',
        'المبلغ (ج.م)',
        'الوصف',
        'طريقة الدفع',
      ]);

      // البيانات
      for (var expense in expenses) {
        final date = expense['date']?.toString() ?? '';
        final isIncome = expense['isIncome'] == true;
        final category = expense['category']?.toString() ?? 'غير معروف';
        final amount = expense['amount']?.toString() ?? '0.00';
        final description = expense['description']?.toString() ?? '';
        final paymentMethod = expense['paymentMethod']?.toString() ?? 'نقدي';

        csvData.add([
          date,
          isIncome ? 'دخل' : 'مصروف',
          category,
          amount,
          description,
          paymentMethod,
        ]);
      }

      // تحويل إلى نص CSV
      final csvString = const ListToCsvConverter().convert(csvData);

      // حفظ الملف مؤقتاً
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'مالي_تصدير_$timestamp.csv';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(csvString, flush: true);

      // مشاركة الملف
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'تصدير بيانات التطبيق المالي',
        text:
            'تم تصدير ${expenses.length} معاملة بتاريخ ${_formatDate(DateTime.now())}',
      );

      print('✅ CSV export successful: ${file.path}');
    } catch (e) {
      print('❌ CSV export error: $e');
      rethrow;
    }
  }

  // ✅ تصدير إلى JSON
  static Future<void> _exportToJSON(List<Map<String, dynamic>> expenses) async {
    try {
      // حساب الإحصائيات
      double totalIncome = 0;
      double totalExpense = 0;

      for (var expense in expenses) {
        if (expense['isIncome'] == true) {
          totalIncome += (expense['amount'] as num).toDouble();
        } else {
          totalExpense += (expense['amount'] as num).toDouble();
        }
      }

      // إنشاء بيانات JSON منظمة
      final exportData = {
        'appName': 'تطبيق مالي',
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

      // تحويل إلى JSON
      final jsonString = jsonEncode(exportData);
      final prettyJson = JsonEncoder.withIndent('  ').convert(exportData);

      // حفظ الملف
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'مالي_تصدير_$timestamp.json';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(prettyJson, flush: true);

      // مشاركة الملف
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'تصدير بيانات JSON',
        text: 'بيانات التطبيق المالي بصيغة JSON',
      );

      print('✅ JSON export successful: ${file.path}');
    } catch (e) {
      print('❌ JSON export error: $e');
      rethrow;
    }
  }

  // ✅ دالة مساعدة لتنسيق التاريخ
  static String _formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd HH:mm', 'ar').format(date);
  }

  // ✅ الحصول على معلومات عن الملفات المصدرة
  static Future<List<FileSystemEntity>> getExportFiles() async {
    try {
      final directory = await getTemporaryDirectory();
      final files = Directory(directory.path)
          .listSync()
          .where((entity) =>
              entity.path.contains('مالي_تصدير_') &&
              (entity.path.endsWith('.csv') || entity.path.endsWith('.json')))
          .toList();

      // ترتيب حسب التاريخ (الأحدث أولاً)
      files.sort(
          (a, b) => b.statSync().modified.compareTo(a.statSync().modified));

      return files;
    } catch (e) {
      print('Error getting export files: $e');
      return [];
    }
  }

  // ✅ مسح الملفات المصدرة القديمة
  static Future<void> cleanOldExports({int keepLastDays = 7}) async {
    try {
      final files = await getExportFiles();
      final cutoffDate = DateTime.now().subtract(Duration(days: keepLastDays));

      for (var file in files) {
        final stat = file.statSync();
        if (stat.modified.isBefore(cutoffDate)) {
          await file.delete();
          print('🗑️ Deleted old export: ${file.path}');
        }
      }
    } catch (e) {
      print('Error cleaning old exports: $e');
    }
  }
}
