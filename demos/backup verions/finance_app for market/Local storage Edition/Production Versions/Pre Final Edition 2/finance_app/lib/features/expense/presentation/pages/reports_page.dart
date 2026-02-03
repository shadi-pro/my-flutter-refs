// lib/features/expense/presentation/pages/reports_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finance_app/features/expense/presentation/controllers/expense_controller.dart';
import 'package:finance_app/features/export/presentation/export_service.dart';
import 'monthly_analysis_page.dart';

class ReportsPage extends StatelessWidget {
  ReportsPage({super.key});
  final ExpenseController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> monthlyStats = controller.getMonthlyStats();
    final Map<String, double> incomeCategories =
        controller.getExpensesByCategory(true);
    final Map<String, double> expenseCategories =
        controller.getExpensesByCategory(false);

    return Scaffold(
      appBar: AppBar(
        title: Text('reports'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Monthly Summary Card :
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(Icons.calendar_today, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          '${'statistics'.tr} ${_getCurrentMonth()}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Quick Statistics :
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildStatItem(
                          'transactions'.tr,
                          '${monthlyStats['count']}',
                          Icons.receipt,
                          Colors.blue,
                        ),
                        _buildStatItem(
                          'income'.tr,
                          '${(monthlyStats['income'] as double).toStringAsFixed(2)} ${'currency_suffix'.tr}',
                          Icons.arrow_downward,
                          Colors.green,
                        ),
                        _buildStatItem(
                          'expense'.tr,
                          '${(monthlyStats['expense'] as double).toStringAsFixed(2)} ${'currency_suffix'.tr}',
                          Icons.arrow_upward,
                          Colors.red,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Month Balance :
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (monthlyStats['balance'] as double) >= 0
                            ? const Color(0xFFE8F5E9)
                            : const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
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
                            '${'monthly_balance'.tr}: ${(monthlyStats['balance'] as double).toStringAsFixed(2)} ${'currency_suffix'.tr}',
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

            // Income Distribution by Categories
            _buildCategorySection(
              'income_distribution'.tr,
              incomeCategories,
              Colors.green,
              Icons.arrow_downward,
            ),

            const SizedBox(height: 24),

            // Expense Distribution by Categories
            _buildCategorySection(
              'expense_distribution'.tr,
              expenseCategories,
              Colors.red,
              Icons.arrow_upward,
            ),

            const SizedBox(height: 24),

            // Additional Statistics
            _buildAdditionalStats(),

            const SizedBox(height: 24),

            // Quick Actions
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.download, color: Colors.blue),
                    title: Text('export_data'.tr),
                    subtitle: Text('save_copy'.tr),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _exportData,
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.insights, color: Colors.purple),
                    title: Text('monthly_analysis'.tr),
                    subtitle: Text('compare_previous_months'.tr),
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
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withAlpha((0.1 * 255).toInt()),
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
    final double total =
        categories.values.fold(0.0, (double sum, double value) => sum + value);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
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
                    'no_data'.tr,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ...categories.entries.map((MapEntry<String, double> entry) {
                final double percentage =
                    total > 0 ? (entry.value / total * 100) : 0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
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
                        children: <Widget>[
                          Expanded(
                            flex: 8,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: percentage / 100,
                                backgroundColor: color.withOpacity(
                                    0.2), // FIX: Replaced deprecated color.value
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(color),
                                minHeight: 6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF757575),
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
    final List<dynamic> recentExpenses = controller.recentExpenses;
    final int totalExpenses = controller.expenseCount;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'additional_stats'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
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
                        'total_transactions'.tr,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
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
                        'recent_transactions'.tr,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
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
                        'current_balance'.tr,
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
    final DateTime now = DateTime.now();

    final String monthName = _getMonthName(now.month);
    return '$monthName ${now.year}';
  }

  String _getMonthName(int month) {
    final List<String> months = <String>[
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
    return months[month - 1];
  }

  void _exportData() async {
    try {
      if (controller.expenses.isEmpty) {
        Get.snackbar(
          'no_transactions_to_export'.tr,
          'no_transactions_to_export'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFFFF3E0),
          colorText: const Color(0xFFE65100),
        );
        return;
      }

      final bool result =
          await ExportService.exportData(controller.expensesAsMap);

      if (result == true) {
        Get.snackbar(
          'export_success'.tr,
          'export_file_saved'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: const Color(0xFFE8F5E9),
          colorText: const Color(0xFF1B5E20),
        );
      }
    } catch (e) {
      Get.snackbar(
        'export_error'.tr,
        'export_failed'.trParams(<String, String>{'e': e.toString()}),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFFEBEE),
        colorText: const Color(0xFFC62828),
      );
    }
  }
}
