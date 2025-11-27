import 'package:flutter/material.dart';
import '../models/task.dart';
import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Task> tasks = [];

  void _addTask(Task task) {
    setState(() => tasks.add(task));
  }

  void _toggleTask(Task task) {
    setState(() {
      final index = tasks.indexOf(task);
      tasks[index] = Task(
        id: task.id,
        title: task.title,
        description: task.description,
        isDone: !task.isDone,
      );
    });
  }

  void _deleteTask(Task task) {
    setState(() => tasks.remove(task));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Task Manager")),
      body: tasks.isEmpty
          ? const Center(child: Text("No tasks yet. Add one!"))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  leading: Checkbox(
                    value: task.isDone,
                    onChanged: (_) => _toggleTask(task),
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: task.description != null
                      ? Text(task.description!)
                      : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteTask(task),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push<Task>(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskPage()),
          );
          if (newTask != null) _addTask(newTask);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
