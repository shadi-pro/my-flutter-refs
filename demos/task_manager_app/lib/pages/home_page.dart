import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';
import '../services/firestore_service.dart';
import '../widgets/task_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: StreamBuilder<List<Task>>(
        stream: firestoreService.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks yet.'));
          }

          final tasks = snapshot.data!;
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
                },
                onDelete: () async {
                  await firestoreService.deleteTask(task.id);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Add a dummy task for testing
          final newTask = Task(
            id: FirebaseFirestore.instance.collection('tasks').doc().id,
            title: 'Dummy Task',
            description: 'This is a test task',
            isDone: false,
            dueDate: DateTime.now().add(const Duration(days: 1)),
            category: 'General',
          );
          await firestoreService.addTask(newTask);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
