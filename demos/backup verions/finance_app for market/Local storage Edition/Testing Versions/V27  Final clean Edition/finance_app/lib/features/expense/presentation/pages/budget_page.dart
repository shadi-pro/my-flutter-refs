// lib/features/expense/presentation/pages/budget_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/budget_controller.dart';
import '../controllers/expense_controller.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final BudgetController _controller = Get.find<BudgetController>();
  final ExpenseController _expenseController = Get.find<ExpenseController>();

  final TextEditingController _budgetController = TextEditingController();
  final Map<String, TextEditingController> _categoryControllers = {};

  // Store mapping between display names and keys
  final Map<String, String> _categoryDisplayToKey = {};

  @override
  void initState() {
    super.initState();
    _budgetController.text = _controller.monthlyBudget.value.toStringAsFixed(2);

    // ✅ FIXED: Get categories with their display names (translated)
    final categoriesWithKeys = _controller.getDefaultCategoriesWithKeys();

    for (var entry in categoriesWithKeys.entries) {
      final categoryKey = entry.key;
      final displayName = entry.value;

      // Store mapping
      _categoryDisplayToKey[displayName] = categoryKey;

      // Initialize controller with display name as key
      _categoryControllers[displayName] = TextEditingController(
        text: _controller.categoryBudgets[categoryKey]?.toStringAsFixed(2) ??
            '0.00',
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
    Get.snackbar('saved'.tr, 'monthly_budget_updated'.tr);
  }

  void _saveCategoryBudget(String displayCategory) {
    final controller = _categoryControllers[displayCategory];
    final value = double.tryParse(controller?.text ?? '0') ?? 0.0;

    // Get the key for this display category
    final categoryKey = _categoryDisplayToKey[displayCategory];
    if (categoryKey != null) {
      _controller.setCategoryBudget(categoryKey, value);
      Get.snackbar('saved'.tr, 'category_budget_updated'.tr);
    }
  }

  void _showBudgetSummary() {
    final alerts = _controller.getBudgetAlerts();

    Get.defaultDialog(
      title: 'budget_summary'.tr,
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Monthly Budget
            _buildSummaryItem(
              'monthly_budget'.tr,
              '${_controller.monthlyBudget.value} ${'currency_suffix'.tr}',
              Icons.account_balance_wallet,
              Colors.blue,
            ),

            _buildSummaryItem(
              'spent'.tr,
              '${_expenseController.totalExpense.value} ${'currency_suffix'.tr}',
              Icons.arrow_upward,
              Colors.red,
            ),

            _buildSummaryItem(
              'remaining'.tr,
              '${_controller.remainingBudget.toStringAsFixed(2)} ${'currency_suffix'.tr}',
              Icons.savings,
              _controller.remainingBudget >= 0 ? Colors.green : Colors.red,
            ),

            const Divider(),

            // Alerts
            if (alerts.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'alerts'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
      textConfirm: 'ok'.tr,
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
        ));
  }

  @override
  Widget build(BuildContext context) {
    final displayCategories = _controller.getDefaultCategoriesForDisplay();

    return Scaffold(
      appBar: AppBar(
        title: Text('budget'.tr),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.assessment),
            onPressed: _showBudgetSummary,
            tooltip: 'budget_summary'.tr,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Monthly Budget Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'monthly_budget'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _budgetController,
                      decoration: InputDecoration(
                        labelText: 'amount_with_currency'.tr,
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
                            percentage >= 100
                                ? 'budget_exceeded'.tr
                                : '${percentage.toStringAsFixed(1)}% ${'spent'.tr.toLowerCase()}',
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

            // Category Budgets Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'category_budget'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'set_category_budget'.tr,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ...displayCategories.map((displayCategory) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(displayCategory),
                            ),
                            SizedBox(
                              width: 120,
                              child: TextField(
                                controller:
                                    _categoryControllers[displayCategory],
                                decoration: InputDecoration(
                                  hintText: '0.00',
                                  suffixText: 'currency_suffix'.tr,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                onSubmitted: (_) =>
                                    _saveCategoryBudget(displayCategory),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.save, size: 20),
                              onPressed: () =>
                                  _saveCategoryBudget(displayCategory),
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

            // Notes Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'notes'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'note_budget_control'.tr,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'note_budget_alert'.tr,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'note_budget_edit'.tr,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Control Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showBudgetSummary,
                    icon: const Icon(Icons.assessment),
                    label: Text('show_summary'.tr),
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
                    label: Text('reset'.tr),
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
