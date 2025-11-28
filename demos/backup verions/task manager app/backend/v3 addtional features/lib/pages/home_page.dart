import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/firestore_service.dart';
import '../widgets/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _dateFilter = 'Newest';

  // ✅ Bulk mark all as done
  Future<void> _markAllDone(List<Task> tasks) async {
    final futures = tasks.map((task) {
      final updatedTask = Task(
        id: task.id,
        title: task.title,
        description: task.description,
        isDone: true, // force all to done
        dueDate: task.dueDate,
        category: task.category,
        createdAt: task.createdAt,
      );
      return firestoreService.updateTask(updatedTask);
    }).toList();

    await Future.wait(futures);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("All tasks marked as done!")));
  }

  // ✅ Bulk mark all as not done
  Future<void> _markAllNotDone(List<Task> tasks) async {
    final futures = tasks.map((task) {
      final updatedTask = Task(
        id: task.id,
        title: task.title,
        description: task.description,
        isDone: false, // force all to not done
        dueDate: task.dueDate,
        category: task.category,
        createdAt: task.createdAt,
      );
      return firestoreService.updateTask(updatedTask);
    }).toList();

    await Future.wait(futures);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("All tasks marked as not done!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _dateFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Newest', child: Text('Newest First')),
              const PopupMenuItem(value: 'Oldest', child: Text('Oldest First')),
            ],
          ),
        ],
      ),
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

                var tasks = snapshot.data!.where((task) {
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

                tasks.sort((a, b) {
                  if (_dateFilter == 'Newest') {
                    return b.createdAt.compareTo(a.createdAt);
                  } else {
                    return a.createdAt.compareTo(b.createdAt);
                  }
                });

                if (tasks.isEmpty) {
                  return const Center(child: Text('No matching tasks.'));
                }

                return Column(
                  children: [
                    // ✅ Bulk action buttons
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.done_all),
                            label: const Text("Mark All Done"),
                            onPressed: () => _markAllDone(tasks),
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.clear_all),
                            label: const Text("Mark All Not Done"),
                            onPressed: () => _markAllNotDone(tasks),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
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
                                createdAt: task.createdAt,
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
                      ),
                    ),
                  ],
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
