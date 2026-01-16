import 'package:finance_app/features/expense/presentation/pages/budget_page.dart';
import 'package:finance_app/features/expense/presentation/pages/reports_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/expense_controller.dart';
import 'add_expense_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ExpenseController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مالي - Finance App'),
        centerTitle: true,
        actions: [
          // Delete all logs button    :
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              Get.defaultDialog(
                title: 'مسح كل البيانات',
                middleText: 'هل أنت متأكد من مسح كل المعاملات؟',
                textConfirm: 'نعم',
                textCancel: 'لا',
                confirmTextColor: Colors.white,
                onConfirm: () {
                  controller.clearAllData();
                  Get.back();
                },
              );
            },
            tooltip: 'مسح كل البيانات',
          ),

          // Navigate to [reporting page] button   :
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Get.to(() => ReportsPage());
            },
            tooltip: 'التقارير',
          ),

          // Navigate to [budget page]  button  :
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            onPressed: () {
              Get.to(() => BudgetPage());
            },
            tooltip: 'الميزانية',
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // بطاقة الملخص
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'الرصيد الحالي',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${controller.balance.value.toStringAsFixed(2)} ج.م',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: controller.balance.value >= 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Icon(Icons.arrow_downward,
                                  color: Colors.green),
                              const SizedBox(height: 4),
                              const Text(
                                'الدخل',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.totalIncome.value.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(Icons.arrow_upward, color: Colors.red),
                              const SizedBox(height: 4),
                              const Text(
                                'المصروفات',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.totalExpense.value
                                    .toStringAsFixed(2),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // عنوان قسم المعاملات
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'آخر المعاملات',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: صفحة كل المعاملات
                    },
                    child: const Text('عرض الكل'),
                  ),
                ],
              ),

              // قائمة المعاملات
              Expanded(
                child: controller.expenses.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        itemCount: controller.expenses.length,
                        itemBuilder: (context, index) {
                          final expense = controller.expenses[index];
                          return _buildExpenseItem(expense, index);
                        },
                      ),
              ),
            ],
          ),
        );
      }),

      // زر الإضافة الجديد
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // الانتقال إلى صفحة الإضافة
          Get.to(() => const AddExpensePage());
        },
        icon: const Icon(Icons.add),
        label: const Text('إضافة جديد'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد معاملات حتى الآن',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'ابدأ بإضافة أول معاملة لك',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(dynamic expense, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: expense['isIncome']
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          child: Icon(
            expense['isIncome'] ? Icons.download : Icons.upload,
            color: expense['isIncome'] ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          expense['category'],
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (expense['description'].toString().isNotEmpty)
              Text(
                expense['description'].toString(),
                style: const TextStyle(fontSize: 13),
              ),
            const SizedBox(height: 2),
            Text(
              _formatDate(expense['date']),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${expense['amount'].toStringAsFixed(2)} ج.م',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: expense['isIncome'] ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              expense['paymentMethod'] ?? 'نقدي',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        onTap: () {
          _showExpenseDetails(expense, index);
        },
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('yyyy/MM/dd', 'ar').format(date);
    } catch (e) {
      return dateString;
    }
  }

  void _showExpenseDetails(dynamic expense, int index) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'تفاصيل المعاملة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('المبلغ:', '${expense['amount']} ج.م'),
            _buildDetailRow('النوع:', expense['isIncome'] ? 'دخل' : 'مصروف'),
            _buildDetailRow('الفئة:', expense['category']),
            if (expense['description'].toString().isNotEmpty)
              _buildDetailRow('الوصف:', expense['description'].toString()),
            _buildDetailRow('التاريخ:', _formatDate(expense['date'])),
            _buildDetailRow('طريقة الدفع:', expense['paymentMethod'] ?? 'نقدي'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text('إغلاق'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.defaultDialog(
                        title: 'تأكيد الحذف',
                        middleText: 'هل تريد حذف هذه المعاملة؟',
                        textConfirm: 'حذف',
                        textCancel: 'إلغاء',
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          controller.deleteExpense(index);
                          Get.back();
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('حذف'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
