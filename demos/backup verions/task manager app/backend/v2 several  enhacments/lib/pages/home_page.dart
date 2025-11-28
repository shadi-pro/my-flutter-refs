import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/firestore_service.dart';
import '../widgets/task_card.dart';
import 'task_detail_page.dart';
import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: Column(
        children: [
          // 🔎 Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search tasks...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          // 🏷️ Category filter dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'All', child: Text('All Categories')),
                DropdownMenuItem(value: 'Work', child: Text('Work')),
                DropdownMenuItem(value: 'Personal', child: Text('Personal')),
                DropdownMenuItem(value: 'General', child: Text('General')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: firestoreService.getTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No tasks yet.'));
                }

                // Filter tasks by search + category
                final tasks = snapshot.data!.where((task) {
                  final titleMatch = task.title.toLowerCase().contains(
                    _searchQuery,
                  );
                  final categoryMatch = task.category.toLowerCase().contains(
                    _searchQuery,
                  );

                  final categoryFilter = _selectedCategory == 'All'
                      ? true
                      : task.category.toLowerCase() ==
                            _selectedCategory.toLowerCase();

                  return (titleMatch || categoryMatch) && categoryFilter;
                }).toList();

                if (tasks.isEmpty) {
                  return const Center(child: Text('No matching tasks.'));
                }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskCard(
                      task: task,
                      onToggleDone: () async {
                        final updatedTask = Task(
                          id: task.id,
                          title: task.title,
                          description: task.description,
                          isDone: !task.isDone,
                          dueDate: task.dueDate,
                          category: task.category,
                        );
                        await firestoreService.updateTask(updatedTask);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              task.isDone
                                  ? "Task marked as not done"
                                  : "Task marked as done",
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      onDelete: () async {
                        await firestoreService.deleteTask(task.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Task deleted successfully!"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
