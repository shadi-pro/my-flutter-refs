import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../services/firestore_service.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _dueDate;

  final FirestoreService _firestoreService = FirestoreService();

  // 🏷️ Predefined categories
  final List<String> _categories = ['Work', 'Personal', 'General'];
  String _selectedCategory = 'General';

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: const Uuid().v4(),
        title: _titleController.text,
        description: _descController.text.isEmpty ? null : _descController.text,
        dueDate: _dueDate,
        category: _selectedCategory,
        createdAt: DateTime.now(), // ✅ required field added
      );

      await _firestoreService.addTask(task);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Task added successfully!"),
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter a title" : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                decoration: const InputDecoration(labelText: "Category"),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _dueDate == null
                          ? "No due date selected"
                          : "Due: ${_dueDate!.toLocal().toString().split(' ')[0]}",
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => _dueDate = picked);
                      }
                    },
                    child: const Text("Select Due Date"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                child: const Text("Save Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
