// lib/features/expense/presentation/pages/reports_page.dart

import 'package:finance_app/features/expense/presentation/controllers/expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/expense_controller.dart';
import 'monthly_analysis_page.dart';
import 'package:finance_app/features/export/presentation/export_service.dart';

class ReportsPage extends StatelessWidget {
  ReportsPage({super.key});
  final ExpenseController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final monthlyStats = controller.getMonthlyStats();
    final incomeCategories = controller.getExpensesByCategory(true);
    final expenseCategories = controller.getExpensesByCategory(false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'reports'.tr), // ✅ Changed from const Text('التقارير والإحصائيات')
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة ملخص الشهر
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          '${'statistics'.tr} ${_getCurrentMonth()}', // ✅ Changed from 'إحصائيات'
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // إحصائيات سريعة
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          'transactions'.tr, // ✅ Changed from 'المعاملات'
                          '${monthlyStats['count']}',
                          Icons.receipt,
                          Colors.blue,
                        ),
                        _buildStatItem(
                          'income'.tr, // ✅ Changed from 'الدخل'
                          '${(monthlyStats['income'] as double).toStringAsFixed(2)} ${'currency_suffix'.tr}',
                          Icons.arrow_downward,
                          Colors.green,
                        ),
                        _buildStatItem(
                          'expense'.tr, // ✅ Changed from 'المصروف'
                          '${(monthlyStats['expense'] as double).toStringAsFixed(2)} ${'currency_suffix'.tr}',
                          Icons.arrow_upward,
                          Colors.red,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // رصيد الشهر
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (monthlyStats['balance'] as double) >= 0
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            (monthlyStats['balance'] as double) >= 0
                                ? Icons.trending_up
                                : Icons.trending_down,
                            color: (monthlyStats['balance'] as double) >= 0
                                ? Colors.green
                                : Colors.red,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${'monthly_balance'.tr}: ${(monthlyStats['balance'] as double).toStringAsFixed(2)} ${'currency_suffix'.tr}', // ✅ Changed from 'رصيد الشهر'
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: (monthlyStats['balance'] as double) >= 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // توزيع الدخل حسب الفئة
            _buildCategorySection(
              'income_distribution'.tr, // ✅ Changed from 'توزيع الدخل'
              incomeCategories,
              Colors.green,
              Icons.arrow_downward,
            ),

            const SizedBox(height: 24),

            // توزيع المصروفات حسب الفئة
            _buildCategorySection(
              'expense_distribution'.tr, // ✅ Changed from 'توزيع المصروفات'
              expenseCategories,
              Colors.red,
              Icons.arrow_upward,
            ),

            const SizedBox(height: 24),

            // إحصائيات إضافية
            _buildAdditionalStats(),

            const SizedBox(height: 24),

            // إجراءات سريعة
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.download, color: Colors.blue),
                    title: Text(
                        'export_data'.tr), // ✅ Changed from 'تصدير البيانات'
                    subtitle: Text('save_copy'
                        .tr), // ✅ Changed from 'حفظ نسخة من جميع المعاملات'
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _exportData,
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.insights, color: Colors.purple),
                    title: Text(
                        'monthly_analysis'.tr), // ✅ Changed from 'تحليل شهري'
                    subtitle: Text('compare_previous_months'
                        .tr), // ✅ Changed from 'مقارنة الأشهر السابقة'
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Get.to(() => MonthlyAnalysisPage());
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(
    String title,
    Map<String, double> categories,
    Color color,
    IconData icon,
  ) {
    final total = categories.values.fold(0.0, (sum, value) => sum + value);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${total.toStringAsFixed(2)} ${'currency_suffix'.tr}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (categories.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'no_data'.tr, // ✅ Changed from 'لا توجد بيانات'
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ...categories.entries.map((entry) {
                final percentage = total > 0 ? (entry.value / total * 100) : 0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry.key,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          Text(
                            '${entry.value.toStringAsFixed(2)} ${'currency_suffix'.tr}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: LinearProgressIndicator(
                              value: percentage / 100,
                              backgroundColor: color.withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalStats() {
    final recentExpenses = controller.recentExpenses;
    final totalExpenses = controller.expenseCount;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'additional_stats'.tr, // ✅ Changed from 'إحصائيات إضافية'
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Icon(Icons.receipt_long,
                          color: Colors.blue, size: 24),
                      const SizedBox(height: 8),
                      Text(
                        totalExpenses.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'total_transactions'
                            .tr, // ✅ Changed from 'إجمالي المعاملات'
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Icon(Icons.access_time,
                          color: Colors.orange, size: 24),
                      const SizedBox(height: 8),
                      Text(
                        recentExpenses.length.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'recent_transactions'
                            .tr, // ✅ Changed from 'معاملات حديثة'
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(
                        controller.balance.value >= 0
                            ? Icons.trending_up
                            : Icons.trending_down,
                        color: controller.balance.value >= 0
                            ? Colors.green
                            : Colors.red,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.balance.value.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: controller.balance.value >= 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      Text(
                        'current_balance'.tr, // ✅ Changed from 'الرصيد الحالي'
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentMonth() {
    final now = DateTime.now();
    final months = [
      'january'.tr,
      'february'.tr,
      'march'.tr,
      'april'.tr,
      'may'.tr,
      'june'.tr,
      'july'.tr,
      'august'.tr,
      'september'.tr,
      'october'.tr,
      'november'.tr,
      'december'.tr,
    ];
    return '${months[now.month - 1]} ${now.year}';
  }

  void _exportData() async {
    try {
      if (controller.expenses.isEmpty) {
        Get.snackbar(
          'no_transactions_to_export'.tr, // ✅ Changed from 'لا توجد بيانات'
          'no_transactions_to_export'
              .tr, // ✅ Changed from 'لا توجد معاملات لتصديرها'
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange[100],
          colorText: Colors.orange[900],
        );
        return;
      }

      final result = await ExportService.exportData(controller.expensesAsMap);

      if (result == true) {
        Get.snackbar(
          'export_success'.tr, // ✅ Changed from '✅ تم التصدير بنجاح'
          'export_file_saved'.tr, // ✅ Changed from 'تم حفظ ملف التصدير بنجاح'
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
        );
      }
    } catch (e) {
      Get.snackbar(
        'export_error'.tr, // ✅ Changed from '❌ خطأ في التصدير'
        'export_failed'
            .trParams({'e': e.toString()}), // ✅ Changed with parameter
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }
  }
}
