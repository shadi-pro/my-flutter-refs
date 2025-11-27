import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class FirestoreService {
  final CollectionReference tasksRef = FirebaseFirestore.instance.collection(
    'tasks',
  );

  // Add a new task
  Future<void> addTask(Task task) async {
    await tasksRef.doc(task.id).set(task.toMap());
  }

  // Get all tasks (real-time stream)
  Stream<List<Task>> getTasks() {
    return tasksRef
        .orderBy('dueDate', descending: false) // earliest due date first
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  // Update a task
  Future<void> updateTask(Task task) async {
    await tasksRef.doc(task.id).update(task.toMap());
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    await tasksRef.doc(id).delete();
  }
}
