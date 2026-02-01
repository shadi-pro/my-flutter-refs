// lib/features/expense/domain/entities/expense_entity.dart

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/models/enums.dart';

class ExpenseEntity {
  final String id;
  final double amount;
  final ExpenseCategory category;
  final String description;
  final DateTime date;
  final bool isIncome;
  final String? receiptImage;
  final PaymentMethod paymentMethod;

  ExpenseEntity({
    String? id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    required this.isIncome,
    this.receiptImage,
    required this.paymentMethod,
  })  : id = id ?? const Uuid().v4(),
        assert(amount > 0, 'المبلغ يجب أن يكون أكبر من صفر');

  ExpenseEntity copyWith({
    String? id,
    double? amount,
    ExpenseCategory? category,
    String? description,
    DateTime? date,
    bool? isIncome,
    String? receiptImage,
    PaymentMethod? paymentMethod,
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
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'category': category.translationKey,
      'description': description.trim(),
      'date': date.toIso8601String(),
      'isIncome': isIncome,
      'receiptImage': receiptImage,
      'paymentMethod': paymentMethod.translationKey,
    };
  }

  factory ExpenseEntity.fromMap(Map<String, dynamic> map) {
    try {
      final String categoryKey = map['category']?.toString() ?? 'others';
      final String paymentMethodKey =
          map['paymentMethod']?.toString() ?? 'cash';
      final String descriptionStr = map['description']?.toString().trim() ?? '';
      final dynamic amountValue = map['amount'];

      return ExpenseEntity(
        id: map['id']?.toString() ?? const Uuid().v4(),
        amount: _parseAmount(amountValue),
        category: ExpenseCategory.fromKey(categoryKey),
        description: descriptionStr,
        date: _parseDate(map['date']?.toString()),
        isIncome: _parseBoolean(map['isIncome']),
        receiptImage: map['receiptImage']?.toString(),
        paymentMethod: PaymentMethod.fromKey(paymentMethodKey),
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('❌ Error in ExpenseEntity.fromMap: $e');
        debugPrint('Stack trace: $stackTrace');
      }

      // Fallback to default values
      return ExpenseEntity(
        amount: 0.0,
        category: ExpenseCategory.other,
        description: 'معاملة غير صالحة',
        date: DateTime.now(),
        isIncome: false,
        paymentMethod: PaymentMethod.cash,
      );
    }
  }

  static double _parseAmount(dynamic amountValue) {
    try {
      if (amountValue == null) return 0.0;
      if (amountValue is int) return amountValue.toDouble();
      if (amountValue is double) return amountValue;
      if (amountValue is String) {
        final double? parsed = double.tryParse(amountValue);
        return parsed ?? 0.0;
      }
      if (amountValue is num) return amountValue.toDouble();
      return 0.0;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error parsing amount: $amountValue, error: $e');
      }
      return 0.0;
    }
  }

  static DateTime _parseDate(String? dateString) {
    try {
      if (dateString == null || dateString.isEmpty) {
        return DateTime.now();
      }
      return DateTime.parse(dateString);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error parsing date: $dateString, error: $e');
      }
      return DateTime.now();
    }
  }

  static bool _parseBoolean(dynamic value) {
    try {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is String) return value.toLowerCase() == 'true';
      if (value is int) return value > 0;
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error parsing boolean: $value, error: $e');
      }
      return false;
    }
  }

  @override
  String toString() {
    return 'ExpenseEntity(id: $id, amount: $amount, category: ${category.displayName}, '
        'description: $description, date: $date, isIncome: $isIncome, '
        'paymentMethod: ${paymentMethod.displayName})';
  }

  // Get amount with sign (positive for income, negative for expense)
  double get signedAmount => isIncome ? amount : -amount;

  // Check if this expense is similar to another (for duplicate detection)
  bool isSimilarTo(ExpenseEntity other) {
    return amount == other.amount &&
        category == other.category &&
        description.trim() == other.description.trim() &&
        date.difference(other.date).inDays.abs() < 7;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExpenseEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
