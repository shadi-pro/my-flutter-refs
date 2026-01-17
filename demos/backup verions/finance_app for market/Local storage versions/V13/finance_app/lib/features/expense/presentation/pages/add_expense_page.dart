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
  String _category = 'طعام';
  String _description = '';
  DateTime _date = DateTime.now();
  bool _isIncome = false;
  String _paymentMethod = 'نقدي';

  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<String> _categories = [
    'طعام',
    'مواصلات',
    'تسوق',
    'ترفيه',
    'صحة',
    'تعليم',
    'سكن',
    'فواتير',
    'مرتب',
    'استثمار',
    'هدايا',
    'أخرى'
  ];

  final List<String> _paymentMethods = [
    'نقدي',
    'بطاقة ائتمان',
    'تحويل بنكي',
    'محفظة إلكترونية',
    'شيك'
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    try {
      return DateFormat('yyyy/MM/dd', 'ar').format(date);
    } catch (_) {
      return DateFormat('yyyy/MM/dd').format(date);
    }
  }

  // ✅ **الدالة المصححة لاختيار التاريخ**
  Future<DateTime?> _selectDate(BuildContext context) async {
    try {
      print('📅 Opening date picker...');

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        locale: const Locale('ar'), // ✅ فقط 'ar' بدون 'EG'
        // إزالة الـ builder مؤقتاً للتجربة
      );

      if (picked != null) {
        print('📅 Selected: $picked');
      } else {
        print('📅 Date selection cancelled');
      }

      return picked;
    } catch (e) {
      print('❌ Date picker error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isIncome ? 'إضافة دخل جديد' : 'إضافة مصروف جديد'),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // تبديل الدخل/المصروف
                SwitchListTile(
                  title: Text(_isIncome ? 'دخل' : 'مصروف'),
                  value: _isIncome,
                  onChanged: (v) => setState(() => _isIncome = v),
                ),
                const SizedBox(height: 16),

                // حقل المبلغ
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'المبلغ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || double.tryParse(v) == null
                      ? 'أدخل رقمًا صحيحًا'
                      : null,
                  onSaved: (v) => _amount = double.parse(v!),
                ),
                const SizedBox(height: 16),

                // اختيار الفئة
                DropdownButtonFormField(
                  value: _category,
                  decoration: const InputDecoration(
                    labelText: 'الفئة',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v!),
                ),
                const SizedBox(height: 16),

                // ✅ **زر اختيار التاريخ المصحح**
                GestureDetector(
                  onTap: () async {
                    print('🟡 Date field tapped!');
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
                        Text(
                          'التاريخ',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              _formatDate(_date),
                              style: const TextStyle(fontSize: 16),
                            ),
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

                // اختيار طريقة الدفع
                DropdownButtonFormField(
                  value: _paymentMethod,
                  decoration: const InputDecoration(
                    labelText: 'طريقة الدفع',
                    border: OutlineInputBorder(),
                  ),
                  items: _paymentMethods
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _paymentMethod = v!),
                ),
                const SizedBox(height: 16),

                // حقل الوصف
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'الوصف (اختياري)',
                    border: OutlineInputBorder(),
                  ),
                  textDirection: ui.TextDirection.rtl,
                  textAlign: TextAlign.right,
                  onSaved: (v) => _description = v ?? '',
                ),
                const SizedBox(height: 24),

                // زر الحفظ
                ElevatedButton(
                  onPressed: _saveExpense,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('حفظ المعاملة'),
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
