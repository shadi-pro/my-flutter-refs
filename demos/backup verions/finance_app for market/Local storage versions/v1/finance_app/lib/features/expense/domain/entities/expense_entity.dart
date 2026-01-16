// lib/features/expense/domain/entities/expense_entity.dart
import 'package:uuid/uuid.dart';

class ExpenseEntity {
  final String id;
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final bool isIncome;
  final String? receiptImage;
  final String paymentMethod;

  ExpenseEntity({
    String? id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    required this.isIncome,
    this.receiptImage,
    this.paymentMethod = 'نقدي',
  }) : id = id ?? Uuid().v4();

  ExpenseEntity copyWith({
    String? id,
    double? amount,
    String? category,
    String? description,
    DateTime? date,
    bool? isIncome,
    String? receiptImage,
    String? paymentMethod,
  }) {
    return ExpenseEntity(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
      isIncome: isIncome ?? this.isIncome,
      receiptImage: receiptImage ?? this.receiptImage,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'description': description,
      'date': date.toIso8601String(),
      'isIncome': isIncome,
      'receiptImage': receiptImage,
      'paymentMethod': paymentMethod,
    };
  }

  factory ExpenseEntity.fromMap(Map<String, dynamic> map) {
    return ExpenseEntity(
      id: map['id'],
      amount: map['amount']?.toDouble() ?? 0.0,
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      date: DateTime.parse(map['date']),
      isIncome: map['isIncome'] ?? false,
      receiptImage: map['receiptImage'],
      paymentMethod: map['paymentMethod'] ?? 'نقدي',
    );
  }
}
