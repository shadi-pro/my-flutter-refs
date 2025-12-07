import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../services/firestore_service.dart';

class AddExpensePage extends StatefulWidget {
  final String uid; // user ID (replace with FirebaseAuth later)
  const AddExpensePage({super.key, required this.uid});

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

      await _firestoreService.addExpense(widget.uid, expense);
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
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a title' : null,
              ),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter an amount' : null,
              ),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                items:
                    ['General', 'Food', 'Transport', 'Bills', 'Entertainment']
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                onChanged: (value) => setState(() {
                  _selectedCategory = value!;
                }),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              ListTile(
                title: Text(
                  'Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveExpense,
                child: const Text('Save Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
