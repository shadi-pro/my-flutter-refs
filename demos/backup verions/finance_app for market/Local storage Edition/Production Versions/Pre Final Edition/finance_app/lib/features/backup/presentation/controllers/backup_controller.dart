// lib/features/backup/presentation/controllers/backup_controller.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

// Importing other   controllers
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

  // Loading Last Backup Date
  void loadLastBackupDate() {
    final dateStr = _storage.read('lastBackupDate');
    if (dateStr != null) {
      lastBackupDate.value = DateTime.parse(dateStr);
    }
  }

  // 1.  create Full Backup
  Future<void> createBackup() async {
    isLoading.value = true;

    try {
      // Gathering all data
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

      // converting to JSON
      final jsonData = jsonEncode(backupData);

      // Saving into a file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final file = File('${directory.path}/finance_backup_$timestamp.json');
      await file.writeAsString(jsonData);

      //  updaing the last Backup Date
      lastBackupDate.value = DateTime.now();
      await _storage.write('lastBackupDate', DateTime.now().toIso8601String());

      Get.snackbar(
        '✅ تم إنشاء النسخة الاحتياطية',
        'تم إنشاء النسخة الاحتياطية بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );

      // مشاركة الملف
      await _shareBackupFile(file);
    } catch (e, stackTrace) {
      print('❌ Backup error: $e');
      print('Stack trace: $stackTrace');

      Get.snackbar(
        '❌ خطأ',
        'فشل في إنشاء النسخة الاحتياطية: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 2. استعادة النسخة الاحتياطية
  Future<void> restoreBackup() async {
    try {
      // اختيار ملف النسخة الاحتياطية
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return; // المستخدم ألغى العملية
      }

      PlatformFile file = result.files.first;
      final filePath = file.path;

      if (filePath == null) {
        throw Exception('مسار ملف غير صالح');
      }

      isLoading.value = true;

      // قراءة وتحليل ملف النسخة الاحتياطية
      final backupFile = File(filePath);
      final jsonData = await backupFile.readAsString();
      final backupData = jsonDecode(jsonData);

      // التحقق من صحة ملف النسخة الاحتياطية
      if (backupData['appName'] != 'Finance App') {
        throw Exception(
            'ملف نسخة احتياطية غير صالح: ليس ملف تطبيق Finance App');
      }

      // عرض نافذة تأكيد
      final bool proceed = await Get.dialog<bool>(
            AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('⚠️ استعادة النسخة الاحتياطية'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('التطبيق: ${backupData['appName']}'),
                  Text('الإصدار: ${backupData['version']}'),
                  Text(
                      'تاريخ النسخة الاحتياطية: ${DateFormat('yyyy/MM/dd HH:mm').format(DateTime.parse(backupData['backupDate']))}'),
                  const SizedBox(height: 16),
                  const Text(
                    '⚠️ سيتم استبدال جميع البيانات الحالية ببيانات النسخة الاحتياطية!',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'هذا الإجراء لا يمكن التراجع عنه.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () => Get.back(result: true),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('استعادة'),
                ),
              ],
            ),
          ) ??
          false;

      if (!proceed) {
        isLoading.value = false;
        return;
      }

      // تنفيذ الاستعادة
      await _performRestore(backupData['data']);

      Get.snackbar(
        '✅ تمت الاستعادة بنجاح',
        'تم استعادة جميع البيانات بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    } catch (e, stackTrace) {
      print('❌ Restore error: $e');
      print('Stack trace: $stackTrace');

      Get.snackbar(
        '❌ فشلت الاستعادة',
        'خطأ: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 3. تنفيذ الاستعادة الفعلية
  Future<void> _performRestore(Map<String, dynamic> backupData) async {
    try {
      // مسح البيانات الحالية أولاً
      await _storage.erase();

      // استعادة كل البيانات
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

      // تحديث تاريخ آخر نسخة احتياطية
      lastBackupDate.value = DateTime.now();
      await _storage.write('lastBackupDate', DateTime.now().toIso8601String());

      // إعادة تحميل كل المتحكمات
      await _reloadAllControllers();
    } catch (e) {
      rethrow;
    }
  }

  // 4. إعادة تحميل كل المتحكمات بعد الاستعادة
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

  // 5. مشاركة ملف النسخة الاحتياطية
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

  // 6. تصدير تقرير نصي - النسخة المصححة
  Future<void> exportSimpleBackup() async {
    isLoading.value = true;

    try {
      // استخدام ExpenseController للحصول على البيانات مباشرة
      final expenseController = Get.find<ExpenseController>();
      final expenses = expenseController.expensesAsMap;

      if (expenses.isEmpty) {
        Get.snackbar(
          '⚠️ لا توجد بيانات',
          'لا توجد معاملات لتصديرها',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange[100],
          colorText: Colors.orange[900],
        );
        isLoading.value = false;
        return;
      }

      // حساب الإحصائيات بشكل صحيح
      double totalIncome = 0;
      double totalExpense = 0;
      final Map<String, double> categoryTotals = {};

      for (var expense in expenses) {
        final amount = (expense['amount'] as num).toDouble();
        final isIncome = expense['isIncome'] == true;
        final category = expense['category']?.toString() ?? 'غير معروف';

        if (isIncome) {
          totalIncome += amount;
        } else {
          totalExpense += amount;

          // حساب المجموع لكل فئة
          categoryTotals.update(
            category,
            (value) => value + amount,
            ifAbsent: () => amount,
          );
        }
      }

      // بناء التقرير بشكل منسق
      final report = '''
📊 تقرير التطبيق المالي
📅 تاريخ التقرير: ${_formatDateTime(DateTime.now())}

══════════════════════════════════════════
📈 الإحصائيات العامة:
══════════════════════════════════════════
• إجمالي المعاملات: ${expenses.length}
• إجمالي الدخل: ${totalIncome.toStringAsFixed(2)} ج.م
• إجمالي المصروفات: ${totalExpense.toStringAsFixed(2)} ج.م
• الرصيد الصافي: ${(totalIncome - totalExpense).toStringAsFixed(2)} ج.م

══════════════════════════════════════════
📊 توزيع المصروفات حسب الفئة:
══════════════════════════════════════════
${_buildCategoryReport(categoryTotals, totalExpense)}

══════════════════════════════════════════
📝 آخر 5 معاملات:
══════════════════════════════════════════
${_buildRecentTransactions(expenses, limit: 5)}

══════════════════════════════════════════
💾 معلومات النسخ الاحتياطي:
══════════════════════════════════════════
• آخر نسخة احتياطية: ${lastBackupDate.value != null ? _formatDateTime(lastBackupDate.value!) : 'لم يتم إنشاء نسخ احتياطية'}
• حجم البيانات: ${expenses.length} معاملة
• تاريخ الإنشاء: ${_formatDateTime(DateTime.now())}
══════════════════════════════════════════
''';

      // مشاركة التقرير
      await Share.share(
        report,
        subject: 'تقرير التطبيق المالي - ${_formatDate(DateTime.now())}',
      );

      Get.snackbar(
        '✅ تم التصدير بنجاح',
        'تم مشاركة التقرير النصي',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    } catch (e, stackTrace) {
      print('❌ Error in exportSimpleBackup: $e');
      print('Stack trace: $stackTrace');

      Get.snackbar(
        '❌ فشل في التصدير',
        'حدث خطأ أثناء إنشاء التقرير',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  // دالة مساعدة لبناء تقرير الفئات
  String _buildCategoryReport(
      Map<String, double> categories, double totalExpense) {
    if (categories.isEmpty) {
      return '• لا توجد مصروفات مصنفة\n';
    }

    final sortedCategories = categories.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    String report = '';
    for (var entry in sortedCategories) {
      final percentage =
          totalExpense > 0 ? (entry.value / totalExpense * 100) : 0;

      report +=
          '• ${entry.key}: ${entry.value.toStringAsFixed(2)} ج.م (${percentage.toStringAsFixed(1)}%)\n';
    }

    return report;
  }

  // دالة مساعدة لبناء المعاملات الحديثة
  // دالة مساعدة لبناء المعاملات الحديثة - الإصدار النهائي
  String _buildRecentTransactions(List<Map<String, dynamic>> expenses,
      {int limit = 5}) {
    // التحقق من القائمة الفارغة
    if (expenses.isEmpty) {
      return '• لا توجد معاملات حديثة\n';
    }

    // نسخ القائمة وترتيبها حسب التاريخ (الأحدث أولاً)
    final recent = List<Map<String, dynamic>>.from(expenses);

    recent.sort((a, b) {
      try {
        final dateStrA = a['date']?.toString();
        final dateStrB = b['date']?.toString();

        if (dateStrA == null || dateStrB == null) return 0;

        final dateA = DateTime.parse(dateStrA);
        final dateB = DateTime.parse(dateStrB);

        return dateB.compareTo(dateA); // الأحدث أولاً
      } catch (e) {
        return 0; // في حالة الخطأ، لا تغيير في الترتيب
      }
    });

    // أخذ العدد المطلوب فقط
    final limitedList = recent.take(limit).toList();

    if (limitedList.isEmpty) {
      return '• لا توجد معاملات حديثة\n';
    }

    // بناء التقرير
    final buffer = StringBuffer();

    for (var expense in limitedList) {
      try {
        final dateStr = expense['date']?.toString();
        if (dateStr == null) continue;

        final date = DateTime.parse(dateStr);
        final formattedDate = _formatDate(date);
        final isIncome = expense['isIncome'] == true;
        final amount = (expense['amount'] as num).toDouble();
        final category = expense['category']?.toString() ?? 'غير معروف';
        final description = expense['description']?.toString() ?? '';

        buffer.write('• $formattedDate: ');
        buffer.write(isIncome ? '⬇️' : '⬆️');
        buffer.write(' ${amount.toStringAsFixed(2)} ج.م ($category)');

        if (description.isNotEmpty) {
          buffer.write(' - $description');
        }

        buffer.writeln();
      } catch (e) {
        // تخطي المعاملات غير الصالحة
        print('⚠️ تخطي معاملة غير صالحة: $e');
        continue;
      }
    }

    return buffer.toString();
  }

  // دالة مساعدة لتنسيق التاريخ
  String _formatDate(DateTime date) {
    try {
      return DateFormat('yyyy/MM/dd').format(date);
    } catch (e) {
      return 'تاريخ غير معروف';
    }
  }

  // دالة مساعدة لتنسيق التاريخ والوقت
  String _formatDateTime(DateTime date) {
    try {
      return DateFormat('yyyy/MM/dd HH:mm').format(date);
    } catch (e) {
      return 'تاريخ غير معروف';
    }
  }

  // 7. الحصول على معلومات النسخ الاحتياطي
  String get backupInfo {
    if (lastBackupDate.value == null) {
      return 'لم يتم إنشاء نسخ احتياطية';
    }

    final diff = DateTime.now().difference(lastBackupDate.value!);

    if (diff.inDays > 0) {
      return 'آخر نسخة احتياطية: منذ ${diff.inDays} يوم';
    } else if (diff.inHours > 0) {
      return 'آخر نسخة احتياطية: منذ ${diff.inHours} ساعة';
    } else if (diff.inMinutes > 0) {
      return 'آخر نسخة احتياطية: منذ ${diff.inMinutes} دقيقة';
    } else {
      return 'آخر نسخة احتياطية: الآن';
    }
  }

  // 8. الحصول على عدد ملفات النسخ الاحتياطي
  Future<int> getBackupFileCount() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = Directory(directory.path)
          .listSync()
          .where((entity) => entity.path.endsWith('.json'))
          .whereType<File>()
          .length;
      return files;
    } catch (e) {
      return 0;
    }
  }

  // 9. مسح بيانات النسخ الاحتياطي
  Future<void> clearBackupData() async {
    try {
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('مسح بيانات النسخ الاحتياطي'),
          content:
              const Text('هل تريد مسح كل بيانات النسخ الاحتياطي المحفوظة؟'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('مسح'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await _storage.remove('lastBackupDate');
        lastBackupDate.value = null;
        Get.snackbar(
          'تم المسح',
          'تم مسح بيانات النسخ الاحتياطي',
        );
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في مسح البيانات');
    }
  }
}
