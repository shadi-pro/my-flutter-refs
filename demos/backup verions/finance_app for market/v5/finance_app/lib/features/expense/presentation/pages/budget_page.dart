// lib/features/budget/presentation/pages/budget_page.dart

import 'package:finance_app/features/expense/presentation/controllers/expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/budget_controller.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final BudgetController _controller = Get.find();
  final ExpenseController _expenseController = Get.find();

  final TextEditingController _budgetController = TextEditingController();
  final Map<String, TextEditingController> _categoryControllers = {};

  @override
  void initState() {
    super.initState();
    _budgetController.text = _controller.monthlyBudget.value.toStringAsFixed(2);

    // تهيئة controllers للفئات
    for (var category in _controller.defaultCategories) {
      _categoryControllers[category] = TextEditingController(
        text:
            _controller.categoryBudgets[category]?.toStringAsFixed(2) ?? '0.00',
      );
    }
  }

  @override
  void dispose() {
    _budgetController.dispose();
    for (var controller in _categoryControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveMonthlyBudget() {
    final value = double.tryParse(_budgetController.text) ?? 0.0;
    _controller.setMonthlyBudget(value);
    Get.snackbar('تم الحفظ', 'تم تحديث الميزانية الشهرية');
  }

  void _saveCategoryBudget(String category) {
    final controller = _categoryControllers[category];
    final value = double.tryParse(controller?.text ?? '0') ?? 0.0;
    _controller.setCategoryBudget(category, value);
    Get.snackbar('تم الحفظ', 'تم تحديث ميزانية $category');
  }

  void _showBudgetSummary() {
    final alerts = _controller.getBudgetAlerts();

    Get.defaultDialog(
      title: 'ملخص الميزانية',
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الميزانية الشهرية
            _buildSummaryItem(
              'الميزانية الشهرية',
              '${_controller.monthlyBudget.value} ج.م',
              Icons.account_balance_wallet,
              Colors.blue,
            ),

            _buildSummaryItem(
              'إجمالي الإنفاق',
              '${_expenseController.totalExpense.value} ج.م',
              Icons.arrow_upward,
              Colors.red,
            ),

            _buildSummaryItem(
              'المتبقي',
              '${_controller.remainingBudget.toStringAsFixed(2)} ج.م',
              Icons.savings,
              _controller.remainingBudget >= 0 ? Colors.green : Colors.red,
            ),

            const Divider(),

            // التحذيرات
            if (alerts.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'تحذيرات:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ...alerts
                  .map((alert) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text('• $alert'),
                      ))
                  .toList(),
            ],
          ],
        ),
      ),
      textConfirm: 'حسناً',
      onConfirm: Get.back,
    );
  }

  Widget _buildSummaryItem(
      String title, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(child: Text(title)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الميزانية'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.assessment),
            onPressed: _showBudgetSummary,
            tooltip: 'ملخص الميزانية',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الميزانية الشهرية
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الميزانية الشهرية',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _budgetController,
                      decoration: InputDecoration(
                        labelText: 'المبلغ (ج.م)',
                        prefixIcon: const Icon(Icons.attach_money),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.save),
                          onPressed: _saveMonthlyBudget,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      final percentage = _controller.spendingPercentage;
                      return Column(
                        children: [
                          LinearProgressIndicator(
                            value: percentage / 100,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              percentage >= 100
                                  ? Colors.red
                                  : percentage >= 80
                                      ? Colors.orange
                                      : Colors.green,
                            ),
                            minHeight: 10,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'تم إنفاق ${percentage.toStringAsFixed(1)}% من الميزانية',
                            style: TextStyle(
                              color: percentage >= 100
                                  ? Colors.red
                                  : percentage >= 80
                                      ? Colors.orange
                                      : Colors.green,
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ميزانية الفئات
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ميزانية الفئات',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'حدد ميزانية لكل فئة من فئات المصروفات',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

                    // قائمة الفئات
                    ..._controller.defaultCategories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(category),
                            ),
                            SizedBox(
                              width: 120,
                              child: TextField(
                                controller: _categoryControllers[category],
                                decoration: InputDecoration(
                                  hintText: '0.00',
                                  suffixText: 'ج.م',
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                onSubmitted: (_) =>
                                    _saveCategoryBudget(category),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.save, size: 20),
                              onPressed: () => _saveCategoryBudget(category),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ملاحظات
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ملاحظات',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• الميزانية تساعدك على التحكم في إنفاقك',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      '• سيتم إعلامك عند اقترابك من تجاوز الميزانية',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      '• يمكنك تعديل الميزانية في أي وقت',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // أزرار التحكم
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showBudgetSummary,
                    icon: const Icon(Icons.assessment),
                    label: const Text('عرض الملخص'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _controller.resetBudget();
                      setState(() {
                        _budgetController.text = '0.00';
                        for (var controller in _categoryControllers.values) {
                          controller.text = '0.00';
                        }
                      });
                    },
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('إعادة تعيين'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
