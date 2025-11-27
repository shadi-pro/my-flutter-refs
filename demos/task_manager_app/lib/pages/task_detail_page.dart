import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/firestore_service.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;

  const TaskDetailPage({super.key, required this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _categoryController;
  DateTime? _dueDate;
  bool _isDone = false;

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(
      text: widget.task.description ?? '',
    );
    _categoryController = TextEditingController(text: widget.task.category);
    _dueDate = widget.task.dueDate;
    _isDone = widget.task.isDone;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    final updatedTask = Task(
      id: widget.task.id,
      title: _titleController.text,
      description: _descController.text.isEmpty ? null : _descController.text,
      isDone: _isDone,
      dueDate: _dueDate,
      category: _categoryController.text.isEmpty
          ? "General"
          : _categoryController.text,
    );
    await _firestoreService.updateTask(updatedTask);
    Navigator.pop(context);
  }

  Future<void> _deleteTask() async {
    await _firestoreService.deleteTask(widget.task.id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: _deleteTask,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextFormField(
              controller: _categoryController,
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
                      initialDate: _dueDate ?? DateTime.now(),
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
            SwitchListTile(
              title: const Text("Completed"),
              value: _isDone,
              onChanged: (val) => setState(() => _isDone = val),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTask,
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
