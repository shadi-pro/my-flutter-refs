import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../services/firestore_service.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key}); // ✅ no uid needed

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'General';
  DateTime _selectedDate = DateTime.now();

  final FirestoreService _firestoreService = FirestoreService();

  Future<void> _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      final expense = Expense(
        id: '', // Firestore will auto-generate
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        date: _selectedDate,
        createdAt: DateTime.now(),
      );

      await _firestoreService.addExpense(expense);
      Navigator.pop(context); // go back to HomePage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 🔹 Title field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                maxLength: 30,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 16),

              // 🔹 Amount field
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter an amount' : null,
              ),
              const SizedBox(height: 16),

              // 🔹 Category dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'General',
                    child: Row(
                      children: const [
                        Icon(Icons.category),
                        SizedBox(width: 8),
                        Text('General'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Food',
                    child: Row(
                      children: const [
                        Icon(Icons.fastfood),
                        SizedBox(width: 8),
                        Text('Food'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Transport',
                    child: Row(
                      children: const [
                        Icon(Icons.directions_car),
                        SizedBox(width: 8),
                        Text('Transport'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Bills',
                    child: Row(
                      children: const [
                        Icon(Icons.receipt),
                        SizedBox(width: 8),
                        Text('Bills'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Entertainment',
                    child: Row(
                      children: const [
                        Icon(Icons.movie),
                        SizedBox(width: 8),
                        Text('Entertainment'),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => _selectedCategory = value!),
              ),
              const SizedBox(height: 16),

              // 🔹 Date picker
              ListTile(
                title: Text(
                  'Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                ),
                leading: const Icon(Icons.calendar_today),
                trailing: const Icon(Icons.edit_calendar),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
              ),
              const SizedBox(height: 20),

              // 🔹 Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveExpense,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Expense'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
