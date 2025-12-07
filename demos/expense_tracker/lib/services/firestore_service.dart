import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 🔹 Add a new expense
  Future<void> addExpense(String uid, Expense expense) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .add(expense.toMap());
  }

  /// 🔹 Get all expenses for a user (real-time stream)
  Stream<List<Expense>> getExpenses(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList(),
        );
  }

  /// 🔹 Update an existing expense
  Future<void> updateExpense(String uid, Expense expense) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .doc(expense.id)
        .update(expense.toMap());
  }

  /// 🔹 Delete an expense
  Future<void> deleteExpense(String uid, String expenseId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .doc(expenseId)
        .delete();
  }
}
