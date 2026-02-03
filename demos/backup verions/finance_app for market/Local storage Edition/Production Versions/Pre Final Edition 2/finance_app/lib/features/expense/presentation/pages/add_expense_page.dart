// finance_app\lib\features\expense\presentation\pages\add_expense_page.dart

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/enums.dart';
import '../../domain/entities/expense_entity.dart';
import '../controllers/expense_controller.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final ExpenseController _controller = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double _amount = 0.0;
  String _categoryKey = 'food'; // Store KEY, not translated text
  String _description = '';
  DateTime _date = DateTime.now();
  bool _isIncome = false;
  String _paymentMethodKey = 'cash'; // Store KEY

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Get translated category names for display
  List<String> get _displayCategories {
    return ExpenseCategory.values
        .map((ExpenseCategory category) => category.translationKey.tr)
        .toList();
  }

  // Get translated payment methods for display
  List<String> get _displayPaymentMethods {
    return PaymentMethod.values
        .map((PaymentMethod method) => method.translationKey.tr)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    // Initialize with first category/payment method keys
    _categoryKey = ExpenseCategory.food.translationKey;
    _paymentMethodKey = PaymentMethod.cash.translationKey;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    try {
      return DateFormat('yyyy/MM/dd', Get.locale?.languageCode ?? 'en')
          .format(date);
    } catch (_) {
      return DateFormat('yyyy/MM/dd').format(date);
    }
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: Get.locale,
    );
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    // Get displayed values (translated) for dropdowns
    final String displayedCategory = _categoryKey.tr;
    final String displayedPaymentMethod = _paymentMethodKey.tr;

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isIncome ? 'add_new_income'.tr : 'add_new_expense'.tr),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                SwitchListTile(
                  title: Text(_isIncome ? 'income'.tr : 'expense'.tr),
                  value: _isIncome,
                  onChanged: (bool v) => setState(() => _isIncome = v),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'amount'.tr,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (String? v) =>
                      v == null || double.tryParse(v) == null
                          ? 'enter_valid_number'.tr
                          : null,
                  onSaved: (String? v) => _amount = double.parse(v!),
                ),
                const SizedBox(height: 16),
                // Category Dropdown - Shows translated text, stores key
                DropdownButtonFormField<String>(
                  initialValue: displayedCategory,
                  decoration: InputDecoration(
                    labelText: 'category'.tr,
                    border: const OutlineInputBorder(),
                  ),
                  items: _displayCategories
                      .map((String displayText) => DropdownMenuItem<String>(
                            value: displayText,
                            child: Text(displayText),
                          ))
                      .toList(),
                  onChanged: (String? v) {
                    if (v != null) {
                      // Find the category key that matches this translated text
                      final ExpenseCategory selectedCategory =
                          ExpenseCategory.values.firstWhere(
                        (ExpenseCategory cat) => cat.translationKey.tr == v,
                        orElse: () => ExpenseCategory.other,
                      );
                      setState(() {
                        _categoryKey = selectedCategory.translationKey;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await _selectDate(context);
                    if (picked != null) {
                      setState(() => _date = picked);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('date'.tr,
                            style: const TextStyle(
                                color: Color(0xFF757575), fontSize: 16)),
                        Row(
                          children: <Widget>[
                            Text(_formatDate(_date),
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            const Icon(Icons.calendar_today,
                                color: Colors.blue),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Payment Method Dropdown - Shows translated text, stores key
                DropdownButtonFormField<String>(
                  initialValue: displayedPaymentMethod,
                  decoration: InputDecoration(
                    labelText: 'payment_method'.tr,
                    border: const OutlineInputBorder(),
                  ),
                  items: _displayPaymentMethods
                      .map((String displayText) => DropdownMenuItem<String>(
                            value: displayText,
                            child: Text(displayText),
                          ))
                      .toList(),
                  onChanged: (String? v) {
                    if (v != null) {
                      // Find the payment method key that matches this translated text
                      final PaymentMethod selectedMethod =
                          PaymentMethod.values.firstWhere(
                        (PaymentMethod method) => method.translationKey.tr == v,
                        orElse: () => PaymentMethod.cash,
                      );
                      setState(() {
                        _paymentMethodKey = selectedMethod.translationKey;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'description'.tr,
                    border: const OutlineInputBorder(),
                  ),
                  textDirection: ui.TextDirection.rtl,
                  textAlign: TextAlign.right,
                  onSaved: (String? v) => _description = v ?? '',
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveExpense,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text('save_transaction'.tr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveExpense() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    // Create expense with keys (not translated text)
    final ExpenseEntity expense = ExpenseEntity(
      amount: _amount,
      category: ExpenseCategory.fromKey(_categoryKey),
      description: _description,
      date: _date,
      isIncome: _isIncome,
      paymentMethod: PaymentMethod.fromKey(_paymentMethodKey),
    );

    _controller.addExpense(expense);
    Get.back();
  }
}
