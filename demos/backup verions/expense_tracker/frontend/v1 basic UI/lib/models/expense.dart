import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id; // Firestore document ID
  final String title; // Expense title (e.g., "Groceries")
  final double amount; // Expense amount
  final String category; // Category (e.g., "Food")
  final DateTime date; // Date of expense
  final DateTime createdAt; // When the record was created

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.createdAt,
  });

  // 🔎 Convert Firestore document → Expense object
  factory Expense.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Expense(
      id: doc.id,
      title: data['title'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      category: data['category'] ?? 'Uncategorized',
      date: (data['date'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // 🔎 Convert Expense object → Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
