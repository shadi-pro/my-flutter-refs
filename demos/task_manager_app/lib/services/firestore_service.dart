import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Helper to get current user UID
  String get uid => FirebaseAuth.instance.currentUser!.uid;

  // Add a new task
  Future<void> addTask(Task task) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(task.id)
        .set(task.toMap());
  }

  // Get all tasks (real-time stream)
  Stream<List<Task>> getTasks() {
    return _db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .orderBy('dueDate', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  // Update a task
  Future<void> updateTask(Task task) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(task.id)
        .update(task.toMap());
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    await _db.collection('users').doc(uid).collection('tasks').doc(id).delete();
  }
}
