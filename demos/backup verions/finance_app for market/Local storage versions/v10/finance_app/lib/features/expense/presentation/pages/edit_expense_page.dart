// lib/features/expense/presentation/pages/edit_expense_page.dart

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/enums.dart';
import '../../../../features/expense/domain/entities/expense_entity.dart';
import '../controllers/expense_controller.dart';

class EditExpensePage extends StatefulWidget {
  final int expenseIndex;
  final Map<String, dynamic> expenseData;

  const EditExpensePage({
    super.key,
    required this.expenseIndex,
    required this.expenseData,
  });

  @override
  State<EditExpensePage> createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  final ExpenseController _controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  late double _amount;
  late String _category;
  late String _description;
  late DateTime _date;
  late bool _isIncome;
  late String _paymentMethod;

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
  void initState() {
    super.initState();

    // تهيئة البيانات من المعاملة المحددة
    _amount = (widget.expenseData['amount'] as num).toDouble();
    _category = widget.expenseData['category']?.toString() ?? 'أخرى';
    _description = widget.expenseData['description']?.toString() ?? '';
    _date = DateTime.parse(
        widget.expenseData['date']?.toString() ?? DateTime.now().toString());
    _isIncome = widget.expenseData['isIncome'] == true;
    _paymentMethod = widget.expenseData['paymentMethod']?.toString() ?? 'نقدي';

    _amountController.text = _amount.toString();
    _descriptionController.text = _description;
  }

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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isIncome ? 'تعديل دخل' : 'تعديل مصروف'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveExpense,
              tooltip: 'حفظ التعديلات',
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(_isIncome ? 'دخل' : 'مصروف'),
                  value: _isIncome,
                  onChanged: (v) => setState(() => _isIncome = v),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'المبلغ'),
                  validator: (v) => v == null || double.tryParse(v) == null
                      ? 'أدخل رقمًا صحيحًا'
                      : null,
                  onSaved: (v) => _amount = double.parse(v!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField(
                  value: _category,
                  decoration: const InputDecoration(labelText: 'الفئة'),
                  items: _categories
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v!),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('التاريخ'),
                  subtitle: Text(_formatDate(_date)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      locale: const Locale('ar'),
                    );
                    if (picked != null) {
                      setState(() => _date = picked);
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField(
                  value: _paymentMethod,
                  decoration: const InputDecoration(labelText: 'طريقة الدفع'),
                  items: _paymentMethods
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _paymentMethod = v!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration:
                      const InputDecoration(labelText: 'الوصف (اختياري)'),
                  onSaved: (v) => _description = v ?? '',
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveExpense,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('حفظ التعديلات'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        child: const Text('إلغاء'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _deleteExpense,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('حذف هذه المعاملة'),
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
      id: widget.expenseData['id']?.toString(), // الحفاظ على نفس الـ ID
      amount: _amount,
      category: ExpenseCategory.fromString(_category),
      description: _description,
      date: _date,
      isIncome: _isIncome,
      paymentMethod: PaymentMethod.fromString(_paymentMethod),
    );

    _controller.updateExpense(widget.expenseIndex, expense);
    Get.back();
  }

  void _deleteExpense() {
    Get.defaultDialog(
      title: 'تأكيد الحذف',
      middleText: 'هل تريد حذف هذه المعاملة؟',
      textConfirm: 'حذف',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      onConfirm: () {
        _controller.deleteExpense(widget.expenseIndex);
        Get.back(); // إغلاق نافذة التأكيد
        Get.back(); // العودة للصفحة الرئيسية
      },
    );
  }
}
