// lib/features/expense/presentation/pages/add_expense_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  final List<String> _categories = [
    'طعام',
    'مواصلات',
    'تسوق',
    'ترفيه',
    'صحة',
    'تعليم',
    'سكن',
    'فواتير',
    'أخرى'
  ];

  final List<String> _paymentMethods = [
    'نقدي',
    'بطاقة ائتمان',
    'تحويل بنكي',
    'محفظة إلكترونية'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('ar', 'EG'),
    );

    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // TODO: استيراد ExpenseEntity بشكل صحيح
      // final expense = ExpenseEntity(
      //   amount: _amount,
      //   category: _category,
      //   description: _description,
      //   date: _date,
      //   isIncome: _isIncome,
      //   paymentMethod: _paymentMethod,
      // );

      // _controller.addExpense(expense);

      Get.back();
      Get.snackbar(
        'تم الحفظ!',
        'تم ${_isIncome ? 'إضافة دخل' : 'تسجيل مصروف'} بنجاح',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isIncome ? 'إضافة دخل جديد' : 'إضافة مصروف جديد',
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'المبلغ',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال المبلغ';
                  }
                  return null;
                },
                onSaved: (value) {
                  _amount = double.tryParse(value!) ?? 0.0;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveExpense,
                child: const Text('حفظ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
