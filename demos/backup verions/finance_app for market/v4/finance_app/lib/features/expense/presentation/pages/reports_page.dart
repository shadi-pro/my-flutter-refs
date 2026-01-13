import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/expense_controller.dart';

class ReportsPage extends StatelessWidget {
  ReportsPage({super.key});
  final controller = Get.find<ExpenseController>();

  @override
  Widget build(BuildContext context) {
    final monthlyStats = controller.getMonthlyStats();
    final incomeCategories = controller.getExpensesByCategory(true);
    final expenseCategories = controller.getExpensesByCategory(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير والإحصائيات  report and statics  '),
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
                          'إحصائيات ${_getCurrentMonth()}',
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
                          'المعاملات',
                          monthlyStats['count'].toString(),
                          Icons.receipt,
                          Colors.blue,
                        ),
                        _buildStatItem(
                          'الدخل',
                          '${monthlyStats['income'].toStringAsFixed(2)} ج.م',
                          Icons.arrow_downward,
                          Colors.green,
                        ),
                        _buildStatItem(
                          'المصروف',
                          '${monthlyStats['expense'].toStringAsFixed(2)} ج.م',
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
                        color: monthlyStats['balance'] >= 0
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            monthlyStats['balance'] >= 0
                                ? Icons.trending_up
                                : Icons.trending_down,
                            color: monthlyStats['balance'] >= 0
                                ? Colors.green
                                : Colors.red,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'رصيد الشهر: ${monthlyStats['balance'].toStringAsFixed(2)} ج.م',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: monthlyStats['balance'] >= 0
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
              'توزيع الدخل',
              incomeCategories,
              Colors.green,
              Icons.arrow_downward,
            ),

            const SizedBox(height: 24),

            // توزيع المصروفات حسب الفئة
            _buildCategorySection(
              'توزيع المصروفات',
              expenseCategories,
              Colors.red,
              Icons.arrow_upward,
            ),

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
                    title: const Text('تصدير البيانات'),
                    subtitle: const Text('حفظ نسخة من جميع المعاملات'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _exportData,
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.insights, color: Colors.purple),
                    title: const Text('تحليل شهري'),
                    subtitle: const Text('مقارنة الأشهر السابقة'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Get.snackbar('قريباً', 'هذه الميزة قيد التطوير');
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
                  '${total.toStringAsFixed(2)} ج.م',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (categories.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'لا توجد بيانات',
                    style: TextStyle(color: Colors.grey),
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
                            '${entry.value.toStringAsFixed(2)} ج.م',
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

  String _getCurrentMonth() {
    final now = DateTime.now();
    final months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];
    return '${months[now.month - 1]} ${now.year}';
  }

  void _exportData() {
    // TODO: تنفيذ تصدير البيانات
    Get.defaultDialog(
      title: 'تصدير البيانات',
      middleText: 'سيتم تصدير جميع المعاملات إلى ملف Excel',
      textConfirm: 'موافق',
      textCancel: 'إلغاء',
      onConfirm: () {
        Get.back();
        Get.snackbar(
          'تم التصدير',
          'تم حفظ البيانات بنجاح',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }
}
