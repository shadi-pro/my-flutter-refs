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

  // البيانات
  double _amount = 0.0;
  String _category = 'طعام';
  String _description = '';
  DateTime _date = DateTime.now();
  bool _isIncome = false;
  String _paymentMethod = 'نقدي';

  // القوائم
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

      final expense = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'amount': _amount,
        'category': _category,
        'description': _description,
        'date': _date.toIso8601String(),
        'isIncome': _isIncome,
        'paymentMethod': _paymentMethod,
      };

      _controller.addExpense(expense);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isIncome ? 'إضافة دخل جديد' : 'إضافة مصروف جديد',
          style: TextStyle(
            color: _isIncome ? Colors.green[800] : Colors.blue[800],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: _isIncome ? Colors.green : Colors.blue,
            ),
            onPressed: () {
              setState(() {
                _isIncome = !_isIncome;
              });
            },
            tooltip: _isIncome ? 'تحويل إلى مصروف' : 'تحويل إلى دخل',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // نوع المعاملة (دخل/مصروف)
              Card(
                child: ListTile(
                  leading: Icon(
                    _isIncome ? Icons.download : Icons.upload,
                    color: _isIncome ? Colors.green : Colors.red,
                  ),
                  title: Text(_isIncome ? 'دخل' : 'مصروف'),
                  trailing: Switch(
                    value: _isIncome,
                    onChanged: (value) {
                      setState(() {
                        _isIncome = value;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveTrackColor: Colors.red[200],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // المبلغ
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'المبلغ',
                  hintText: 'أدخل المبلغ',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال المبلغ';
                  }
                  if (double.tryParse(value) == null) {
                    return 'الرجاء إدخال رقم صحيح';
                  }
                  return null;
                },
                onSaved: (value) {
                  _amount = double.parse(value!);
                },
              ),

              const SizedBox(height: 20),

              // الفئة
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'الفئة',
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                value: _category,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              // التاريخ
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'التاريخ',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('yyyy/MM/dd', 'ar').format(_date),
                        style: const TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // طريقة الدفع
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'طريقة الدفع',
                  prefixIcon: const Icon(Icons.payment),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                value: _paymentMethod,
                items: _paymentMethods.map((method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              // الوصف
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'الوصف (اختياري)',
                  hintText: 'أدخل وصفاً للمعاملة',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                maxLines: 3,
                onSaved: (value) {
                  _description = value ?? '';
                },
              ),

              const SizedBox(height: 30),

              // زر الحفظ
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveExpense,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isIncome ? Colors.green : Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'حفظ المعاملة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
