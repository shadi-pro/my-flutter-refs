import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = "General";
  DateTime? _dueDate;

  final firestoreService = FirestoreService();

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: const Uuid().v4(), // unique ID
        title: _titleController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        category: _selectedCategory,
        dueDate: _dueDate,
        createdAt: DateTime.now(), // always set
      );

      await firestoreService.addTask(task);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Task added successfully!")));

      Navigator.pop(context); // go back to HomePage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Task")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: const [
                  DropdownMenuItem(value: "General", child: Text("General")),
                  DropdownMenuItem(value: "Work", child: Text("Work")),
                  DropdownMenuItem(value: "Personal", child: Text("Personal")),
                ],
                onChanged: (value) => setState(() {
                  _selectedCategory = value!;
                }),
                decoration: const InputDecoration(labelText: "Category"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _dueDate = picked;
                    });
                  }
                },
                child: Text(
                  _dueDate == null
                      ? "Pick Due Date"
                      : "Due: ${_dueDate!.toLocal()}".split(' ')[0],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Save Task"),
                onPressed: _saveTask,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
