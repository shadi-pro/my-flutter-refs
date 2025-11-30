import 'package:flutter/material.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:task_manager_app/pages/task_detail_page.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onToggleDone;

  const TaskCard({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggleDone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.category),
            if (task.dueDate != null)
              Text("Due: ${task.dueDate!.toLocal().toString().split(' ')[0]}"),
            Text(
              "Created: ${task.createdAt.toLocal().toString().split(' ')[0]}",
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
        leading: Checkbox(value: task.isDone, onChanged: (_) => onToggleDone()),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskDetailPage(task: task)),
          );
        },
      ),
    );
  }
}
