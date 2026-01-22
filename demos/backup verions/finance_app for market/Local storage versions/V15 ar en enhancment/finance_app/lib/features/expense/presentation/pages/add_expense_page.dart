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
  final _formKey = GlobalKey<FormState>();

  double _amount = 0.0;
  String _category = 'food'.tr;
  String _description = '';
  DateTime _date = DateTime.now();
  bool _isIncome = false;
  String _paymentMethod = 'cash'.tr;

  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<String> _categories = [
    "food".tr,
    "transportation".tr,
    "marketing".tr,
    "entertainment".tr,
    "health".tr,
    "learn".tr,
    "living".tr,
    "bills".tr,
    "salary".tr,
    "investment".tr,
    "gifts".tr,
    "others".tr,
  ];

  final List<String> _paymentMethods = [
    "cash".tr,
    "credit_card".tr,
    "bank_transfer".tr,
    "e_wallet".tr,
    "cheque".tr
  ];

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
              children: [
                SwitchListTile(
                  title: Text(_isIncome ? 'income'.tr : 'expense'.tr),
                  value: _isIncome,
                  onChanged: (v) => setState(() => _isIncome = v),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'amount'.tr,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || double.tryParse(v) == null
                      ? 'enter_valid_number'.tr
                      : null,
                  onSaved: (v) => _amount = double.parse(v!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField(
                  value: _category,
                  decoration: InputDecoration(
                    labelText: 'category'.tr,
                    border: const OutlineInputBorder(),
                  ),
                  items: _categories
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v!),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final picked = await _selectDate(context);
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
                      children: [
                        Text('date'.tr,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 16)),
                        Row(
                          children: [
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
                DropdownButtonFormField(
                  value: _paymentMethod,
                  decoration: InputDecoration(
                    labelText: 'payment_method'.tr,
                    border: const OutlineInputBorder(),
                  ),
                  items: _paymentMethods
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _paymentMethod = v!),
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
                  onSaved: (v) => _description = v ?? '',
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

    final expense = ExpenseEntity(
      amount: _amount,
      category: ExpenseCategory.fromString(_category),
      description: _description,
      date: _date,
      isIncome: _isIncome,
      paymentMethod: PaymentMethod.fromString(_paymentMethod),
    );

    _controller.addExpense(expense);
    Get.back();
  }
}
