// finance_app\lib\core\models\goal_entity.dart

import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
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
  final String colorHex;
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
    this.category = 'categoryOther',
    this.priority = GoalPriority.medium,
    this.colorHex = '#4CAF50', // Default Green
    this.isCompleted = false,
    List<Contribution>? contributions,
  })  : id = id ?? const Uuid().v4(),
        startDate = startDate ?? DateTime.now(),
        contributions = contributions ?? [] {
    assert(targetAmount > 0, 'assertTargetPositive'.tr);
    assert(currentAmount >= 0, 'assertCurrentNotNegative'.tr);
    assert(!targetDate.isBefore(startDate ?? DateTime.now()),
        'assertDateNotBefore'.tr);
  }

  // Progress Percentage
  double get progressPercentage {
    if (targetAmount <= 0) return 0.0;
    return (currentAmount / targetAmount * 100).clamp(0.0, 100.0);
  }

  //  Days Remaining
  int get daysRemaining {
    final now = DateTime.now();
    if (targetDate.isBefore(now)) return 0;
    return targetDate.difference(now).inDays;
  }

  // Remaining Amount
  double get remainingAmount =>
      (targetAmount - currentAmount).clamp(0.0, double.infinity);

  // Required Daily Saving
  double get requiredDailySaving {
    final days = daysRemaining;
    if (days <= 0) return remainingAmount;
    return remainingAmount / days;
  }

  //  Add Contribution
  void addContribution(double amount, String note, DateTime date) {
    if (amount <= 0) throw Exception('contributionPositive'.tr);
    if (isCompleted) throw Exception('goalCompletedNoContribution'.tr);

    contributions.add(Contribution(
      amount: amount,
      note: note,
      date: date,
    ));
    currentAmount += amount;

    // التحقق إذا كان الهدف مكتملاً
    if (currentAmount >= targetAmount && !isCompleted) {
      // في الواقع، سنحتاج لتحديث isCompleted في المتحكم
    }
  }

  // Maping for Storing
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

  //   Creating Financial Goal frorm  Map
  factory FinancialGoal.fromMap(Map<String, dynamic> map) {
    try {
      return FinancialGoal(
        id: map['id']?.toString(),
        title: map['title']?.toString() ?? 'goalNoTitle'.tr,
        description: map['description']?.toString() ?? '',
        targetAmount: (map['targetAmount'] as num?)?.toDouble() ?? 0.0,
        currentAmount: (map['currentAmount'] as num?)?.toDouble() ?? 0.0,
        startDate: DateTime.parse(
            map['startDate']?.toString() ?? DateTime.now().toIso8601String()),
        targetDate: DateTime.parse(
            map['targetDate']?.toString() ?? DateTime.now().toIso8601String()),
        category: map['category']?.toString() ?? 'categoryOther',
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
      debugPrint('❌ Error parsing FinancialGoal: $e');
      rethrow;
    }
  }

  // Copy  FinancialGoal   wiht updaings
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

  //  Geting  Translated Category
  String get translatedCategory =>
      FinancialGoal.getTranslatedCategory(category);

  @override
  String toString() {
    return 'FinancialGoal($title: $currentAmount/$targetAmount - ${progressPercentage.toStringAsFixed(1)}%)';
  }

  // Common translated Categories
  static List<String> get commonCategories {
    return [
      'categoryCar'.tr,
      'categoryUmrah'.tr,
      'categoryStudy'.tr,
      'categoryMarriage'.tr,
      'categoryHouse'.tr,
      'categoryInvestment'.tr,
      'categoryTravel'.tr,
      'categoryEmergency'.tr,
      'categoryRetirement'.tr,
      'categoryGift'.tr,
      'categoryHealth'.tr,
      'categoryEducation'.tr,
      'categoryOther'.tr,
    ];
  }

  //   Define  Category Keys as a list
  static List<String> get categoryKeys {
    return [
      'categoryCar',
      'categoryUmrah',
      'categoryStudy',
      'categoryMarriage',
      'categoryHouse',
      'categoryInvestment',
      'categoryTravel',
      'categoryEmergency',
      'categoryRetirement',
      'categoryGift',
      'categoryHealth',
      'categoryEducation',
      'categoryOther',
    ];
  }

  //  Converting the Translated  Category  into a key
  static String getCategoryKey(String translatedCategory) {
    final categories = commonCategories;
    final keys = categoryKeys;

    final index = categories.indexOf(translatedCategory);
    return index != -1 ? keys[index] : 'categoryOther';
  }

  // Converting  a single key into trnqalstatd category
  static String getTranslatedCategory(String categoryKey) {
    final keys = categoryKeys;
    final index = keys.indexOf(categoryKey);
    return index != -1 ? keys[index].tr : 'categoryOther'.tr;
  }

  //  Categories Icons
  static const Map<String, String> categoryIcons = {
    'categoryCar': '🚗',
    'categoryUmrah': '🕋',
    'categoryStudy': '🎓',
    'categoryMarriage': '💍',
    'categoryHouse': '🏠',
    'categoryInvestment': '📈',
    'categoryTravel': '✈️',
    'categoryEmergency': '🚨',
    'categoryRetirement': '👴',
    'categoryGift': '🎁',
    'categoryHealth': '🏥',
    'categoryEducation': '📚',
    'categoryOther': '🎯',
  };

  // Geting Category Icon
  static String getIconForCategory(String category) {
    final key = getCategoryKey(category);
    return categoryIcons[key] ?? '🎯';
  }

  //  Covnerting the priorety into  translated text
  static String priorityToString(GoalPriority priority) {
    switch (priority) {
      case GoalPriority.low:
        return 'priorityLow'.tr;
      case GoalPriority.medium:
        return 'priorityMedium'.tr;
      case GoalPriority.high:
        return 'priorityHigh'.tr;
      case GoalPriority.critical:
        return 'priorityCritical'.tr;
    }
  }
}

//  Contribution Form
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

//  Gaol Color Hexa code for Goals
class GoalColors {
  static const List<String> availableColors = [
    '#4CAF50', // green
    '#2196F3', // blue
    '#FF9800', // orange
    '#9C27B0', // purple
    '#F44336', // red
    '#00BCD4', // Terquaz
    '#FFC107', // yellow
    '#795548', // brown
    '#607D8B', // grey blue
    '#E91E63', // pink
  ];

  // Covnerting  Goals Color Hexa code  into a string
  static ui.Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return ui.Color(int.parse(hex, radix: 16));
  }
}

//  Migrating old Categories into Map
class GoalMigration {
  static final Map<String, String> arabicToKeyMap = {
    'سيارة': 'categoryCar',
    'عمرة': 'categoryUmrah',
    'دراسة': 'categoryStudy',
    'زواج': 'categoryMarriage',
    'منزل': 'categoryHouse',
    'استثمار': 'categoryInvestment',
    'سفر': 'categoryTravel',
    'طوارئ': 'categoryEmergency',
    'تقاعد': 'categoryRetirement',
    'هدية': 'categoryGift',
    'صحة': 'categoryHealth',
    'تعليم': 'categoryEducation',
    'أخرى': 'categoryOther',
  };

  static String migrateOldCategory(String oldCategory) {
    return arabicToKeyMap[oldCategory] ?? 'categoryOther';
  }

  static bool isOldCategory(String category) {
    return arabicToKeyMap.containsKey(category);
  }
}
