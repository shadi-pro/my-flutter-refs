import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final bool isDone;
  final DateTime? dueDate;
  final String category;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.isDone = false,
    this.dueDate,
    this.category = "General",
    required this.createdAt,
  });

  // 🔄 Convert Task to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'category': category,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // 🔄 Create Task from Firestore Map (safe parsing)
  factory Task.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      return DateTime.now();
    }

    return Task(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      isDone: map['isDone'] ?? false,
      dueDate: parseDate(map['dueDate']),
      category: map['category'] ?? "General",
      createdAt: parseDate(map['createdAt']),
    );
  }

  // ✨ copyWith for easy updates
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isDone,
    DateTime? dueDate,
    String? category,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
