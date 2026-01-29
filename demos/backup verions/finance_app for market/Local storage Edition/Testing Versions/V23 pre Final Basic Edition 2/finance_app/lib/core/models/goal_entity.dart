// FILE: lib/core/models/goal_entity.dart

import 'dart:ui' as ui;
import 'package:uuid/uuid.dart';

enum GoalPriority { low, medium, high, critical }

class FinancialGoal {
  final String id;
  final String title;
  final String description;
  final double targetAmount;
  double currentAmount;
  final DateTime startDate;
  final DateTime targetDate;
  final String category;
  final GoalPriority priority;
  final String colorHex; // لون مميز لكل هدف
  final bool isCompleted;
  final List<Contribution> contributions;

  FinancialGoal({
    String? id,
    required this.title,
    this.description = '',
    required this.targetAmount,
    this.currentAmount = 0.0,
    DateTime? startDate,
    required this.targetDate,
    this.category = 'عام',
    this.priority = GoalPriority.medium,
    this.colorHex = '#4CAF50', // أخضر افتراضي
    this.isCompleted = false,
    List<Contribution>? contributions,
  })  : id = id ?? const Uuid().v4(),
        startDate = startDate ?? DateTime.now(),
        contributions = contributions ?? [] {
    assert(targetAmount > 0, 'المبلغ المستهدف يجب أن يكون أكبر من صفر');
    assert(currentAmount >= 0, 'المبلغ الحالي لا يمكن أن يكون سالباً');
    assert(!targetDate.isBefore(startDate ?? DateTime.now()),
        'تاريخ الهدف لا يمكن أن يكون قبل تاريخ البدء');
  }

  // نسبة الإنجاز
  double get progressPercentage {
    if (targetAmount <= 0) return 0.0;
    return (currentAmount / targetAmount * 100).clamp(0.0, 100.0);
  }

  // الأيام المتبقية
  int get daysRemaining {
    final now = DateTime.now();
    if (targetDate.isBefore(now)) return 0;
    return targetDate.difference(now).inDays;
  }

  // المبلغ المتبقي
  double get remainingAmount =>
      (targetAmount - currentAmount).clamp(0.0, double.infinity);

  // متوسط التوفير اليومي المطلوب
  double get requiredDailySaving {
    final days = daysRemaining;
    if (days <= 0) return remainingAmount;
    return remainingAmount / days;
  }

  // إضافة مساهمة
  void addContribution(double amount, String note, DateTime date) {
    if (amount <= 0) throw Exception('المبلغ يجب أن يكون أكبر من صفر');
    if (isCompleted) throw Exception('الهدف مكتمل، لا يمكن إضافة مساهمات');

    contributions.add(Contribution(
      amount: amount,
      note: note,
      date: date,
    ));
    currentAmount += amount;

    // التحقق من اكتمال الهدف
    if (currentAmount >= targetAmount && !isCompleted) {
      // في الواقع، سنحتاج لتحديث isCompleted في المتحكم
    }
  }

  // تحويل إلى Map للتخزين
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'startDate': startDate.toIso8601String(),
      'targetDate': targetDate.toIso8601String(),
      'category': category,
      'priority': priority.index,
      'colorHex': colorHex,
      'isCompleted': isCompleted,
      'contributions': contributions.map((c) => c.toMap()).toList(),
    };
  }

  // إنشاء من Map
  factory FinancialGoal.fromMap(Map<String, dynamic> map) {
    try {
      return FinancialGoal(
        id: map['id']?.toString(),
        title: map['title']?.toString() ?? 'هدف بدون عنوان',
        description: map['description']?.toString() ?? '',
        targetAmount: (map['targetAmount'] as num?)?.toDouble() ?? 0.0,
        currentAmount: (map['currentAmount'] as num?)?.toDouble() ?? 0.0,
        startDate: DateTime.parse(
            map['startDate']?.toString() ?? DateTime.now().toIso8601String()),
        targetDate: DateTime.parse(
            map['targetDate']?.toString() ?? DateTime.now().toIso8601String()),
        category: map['category']?.toString() ?? 'عام',
        priority: GoalPriority.values[
            (map['priority'] as num?)?.toInt() ?? GoalPriority.medium.index],
        colorHex: map['colorHex']?.toString() ?? '#4CAF50',
        isCompleted: map['isCompleted'] == true,
        contributions: (map['contributions'] as List<dynamic>?)
                ?.map((item) =>
                    Contribution.fromMap(item as Map<String, dynamic>))
                .toList() ??
            [],
      );
    } catch (e) {
      print('❌ Error parsing FinancialGoal: $e');
      rethrow;
    }
  }

  // نسخة معدلة
  FinancialGoal copyWith({
    String? id,
    String? title,
    String? description,
    double? targetAmount,
    double? currentAmount,
    DateTime? startDate,
    DateTime? targetDate,
    String? category,
    GoalPriority? priority,
    String? colorHex,
    bool? isCompleted,
    List<Contribution>? contributions,
  }) {
    return FinancialGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      startDate: startDate ?? this.startDate,
      targetDate: targetDate ?? this.targetDate,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      colorHex: colorHex ?? this.colorHex,
      isCompleted: isCompleted ?? this.isCompleted,
      contributions: contributions ?? this.contributions,
    );
  }

  @override
  String toString() {
    return 'FinancialGoal($title: $currentAmount/$targetAmount - ${progressPercentage.toStringAsFixed(1)}%)';
  }
}

// نموذج المساهمة
class Contribution {
  final String id;
  final double amount;
  final String note;
  final DateTime date;

  Contribution({
    String? id,
    required this.amount,
    required this.note,
    required this.date,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

  factory Contribution.fromMap(Map<String, dynamic> map) {
    return Contribution(
      id: map['id']?.toString(),
      amount: (map['amount'] as num).toDouble(),
      note: map['note']?.toString() ?? '',
      date: DateTime.parse(
          map['date']?.toString() ?? DateTime.now().toIso8601String()),
    );
  }
}

// فئات الأهداف الشائعة
class GoalCategories {
  static const List<String> commonCategories = [
    'سيارة',
    'عمرة',
    'دراسة',
    'زواج',
    'منزل',
    'استثمار',
    'سفر',
    'طوارئ',
    'تقاعد',
    'هدية',
    'صحة',
    'تعليم',
    'أخرى',
  ];

  static const Map<String, String> categoryIcons = {
    'سيارة': '🚗',
    'عمرة': '🕋',
    'دراسة': '🎓',
    'زواج': '💍',
    'منزل': '🏠',
    'استثمار': '📈',
    'سفر': '✈️',
    'طوارئ': '🚨',
    'تقاعد': '👴',
    'هدية': '🎁',
    'صحة': '🏥',
    'تعليم': '📚',
    'أخرى': '🎯',
  };

  static String getIconForCategory(String category) {
    return categoryIcons[category] ?? '🎯';
  }
}

// ألوان مخصصة للأهداف
class GoalColors {
  static const List<String> availableColors = [
    '#4CAF50', // أخضر
    '#2196F3', // أزرق
    '#FF9800', // برتقالي
    '#9C27B0', // بنفسجي
    '#F44336', // أحمر
    '#00BCD4', // تركواز
    '#FFC107', // أصفر
    '#795548', // بني
    '#607D8B', // رمادي أزرق
    '#E91E63', // وردي
  ];

  static ui.Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return ui.Color(int.parse(hex, radix: 16));
  }
}
