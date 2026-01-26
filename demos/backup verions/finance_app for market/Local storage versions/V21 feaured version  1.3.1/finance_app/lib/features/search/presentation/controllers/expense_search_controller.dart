// lib/features/search/presentation/controllers/expense_search_controller.dart

import 'dart:async';

import 'package:get/get.dart';
import '../../../expense/presentation/controllers/expense_controller.dart';
import '../../../expense/domain/entities/expense_entity.dart';
import '../../../../core/utils/error_handler.dart';

class ExpenseSearchController extends GetxController {
  static const String TAG = 'ExpenseSearchController';

  final searchQuery = ''.obs;
  final selectedCategory = 'الكل'.obs;
  final selectedType = 'الكل'.obs;
  final minAmount = 0.0.obs;
  final maxAmount = 1000000.0.obs;
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);
  final isFilterActive = false.obs;

  // 🔧 إضافة cache ذكي مع تتبع التغييرات
  List<Map<String, dynamic>>? _cachedFilteredMaps;
  List<ExpenseEntity>? _cachedFilteredEntities;
  String _lastFilterHash = '';
  bool _shouldInvalidateCache = true;

  // 🔧 إضافة timer للبحث
  Timer? _searchTimer;

  @override
  void onClose() {
    _searchTimer?.cancel();
    _searchTimer = null;
    _cachedFilteredMaps = null;
    _cachedFilteredEntities = null;
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();

    // 🔧 إضافة worker لإبطال cache عند أي تغيير
    everAll([
      searchQuery,
      selectedCategory,
      selectedType,
      minAmount,
      maxAmount,
      startDate,
      endDate
    ], (_) {
      _shouldInvalidateCache = true;
      updateFilterStatus();
    });
  }

  // 🔧 دالة لحساب hash للفلاتر الحالية
  String _getFilterHash() {
    return '${searchQuery.value}_${selectedCategory.value}_${selectedType.value}_'
        '${minAmount.value}_${maxAmount.value}_'
        '${startDate.value?.millisecondsSinceEpoch}_${endDate.value?.millisecondsSinceEpoch}';
  }

  // 🔧 دالة لإبطال cache
  void invalidateCache() {
    _shouldInvalidateCache = true;
    _cachedFilteredMaps = null;
    _cachedFilteredEntities = null;
  }

  void updateFilterStatus() {
    isFilterActive.value = searchQuery.value.isNotEmpty ||
        selectedCategory.value != 'الكل' ||
        selectedType.value != 'الكل' ||
        minAmount.value > 0.0 ||
        maxAmount.value < 1000000.0 ||
        startDate.value != null ||
        endDate.value != null;
  }

  List<Map<String, dynamic>> get filteredExpenses {
    try {
      // 🔧 التحقق من cache أولاً
      final currentHash = _getFilterHash();
      if (!_shouldInvalidateCache &&
          _cachedFilteredMaps != null &&
          _lastFilterHash == currentHash) {
        return _cachedFilteredMaps!;
      }

      final expenseController = Get.find<ExpenseController>();

      // 🔧 تحسين: استخدام List<ExpenseEntity> مباشرة (أسرع)
      List<ExpenseEntity> expenseEntities =
          List.from(expenseController.expenses);

      // 🔧 تطبيق الفلاتر على List<ExpenseEntity> مباشرة
      if (searchQuery.value.isNotEmpty) {
        expenseEntities = expenseEntities.where((expense) {
          return expense.category.arabicName
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              expense.description
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase());
        }).toList();
      }

      if (selectedCategory.value != 'الكل') {
        expenseEntities = expenseEntities.where((expense) {
          return expense.category.arabicName == selectedCategory.value;
        }).toList();
      }

      if (selectedType.value != 'الكل') {
        expenseEntities = expenseEntities.where((expense) {
          if (selectedType.value == 'دخل') return expense.isIncome == true;
          if (selectedType.value == 'مصروف') return expense.isIncome == false;
          return true;
        }).toList();
      }

      expenseEntities = expenseEntities.where((expense) {
        return expense.amount >= minAmount.value &&
            expense.amount <= maxAmount.value;
      }).toList();

      if (startDate.value != null) {
        expenseEntities = expenseEntities.where((expense) {
          return expense.date.isAfter(startDate.value!);
        }).toList();
      }

      if (endDate.value != null) {
        expenseEntities = expenseEntities.where((expense) {
          return expense.date.isBefore(endDate.value!);
        }).toList();
      }

      // 🔧 التحويل النهائي إلى Map مرة واحدة فقط
      final List<Map<String, dynamic>> result =
          expenseEntities.map((expense) => expense.toMap()).toList();

      // 🔧 الترتيب على List<Map> (أسرع بعد الفلترة)
      result.sort((a, b) {
        try {
          final dateA = DateTime.parse(a['date']);
          final dateB = DateTime.parse(b['date']);
          return dateB.compareTo(dateA);
        } catch (e) {
          return 0;
        }
      });

      // 🔧 تحديث cache
      _cachedFilteredMaps = result;
      _cachedFilteredEntities = expenseEntities;
      _lastFilterHash = currentHash;
      _shouldInvalidateCache = false;

      return result;
    } catch (e) {
      ErrorHandler.showError('خطأ في تصفية البيانات: $e');
      return [];
    }
  }

  List<ExpenseEntity> get filteredExpenseEntities {
    try {
      // 🔧 استخدام cache إذا متوفر
      if (_cachedFilteredEntities != null && !_shouldInvalidateCache) {
        return _cachedFilteredEntities!;
      }

      // 🔧 إذا لم يكن في cache، احسب من filteredExpenses (التي ستحدث cache)
      if (filteredExpenses.isNotEmpty && _cachedFilteredEntities != null) {
        return _cachedFilteredEntities!;
      }

      // 🔧 الحساب المباشر (نفس منطق filteredExpenses لكن يرجع Entities مباشرة)
      final expenseController = Get.find<ExpenseController>();
      List<ExpenseEntity> expenses = List.from(expenseController.expenses);

      if (searchQuery.value.isNotEmpty) {
        expenses = expenses.where((expense) {
          return expense.category.arabicName
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              expense.description
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase());
        }).toList();
      }

      if (selectedCategory.value != 'الكل') {
        expenses = expenses.where((expense) {
          return expense.category.arabicName == selectedCategory.value;
        }).toList();
      }

      if (selectedType.value != 'الكل') {
        expenses = expenses.where((expense) {
          if (selectedType.value == 'دخل') return expense.isIncome == true;
          if (selectedType.value == 'مصروف') return expense.isIncome == false;
          return true;
        }).toList();
      }

      expenses = expenses.where((expense) {
        return expense.amount >= minAmount.value &&
            expense.amount <= maxAmount.value;
      }).toList();

      if (startDate.value != null) {
        expenses = expenses.where((expense) {
          return expense.date.isAfter(startDate.value!);
        }).toList();
      }

      if (endDate.value != null) {
        expenses = expenses.where((expense) {
          return expense.date.isBefore(endDate.value!);
        }).toList();
      }

      expenses.sort((a, b) => b.date.compareTo(a.date));

      // 🔧 تحديث cache
      _cachedFilteredEntities = expenses;
      _shouldInvalidateCache = false;

      return expenses;
    } catch (e) {
      ErrorHandler.showError('خطأ في تصفية البيانات: $e');
      return [];
    }
  }

  int get filteredCount => filteredExpenses.length;

  void resetFilters() {
    searchQuery.value = '';
    selectedCategory.value = 'الكل';
    selectedType.value = 'الكل';
    minAmount.value = 0.0;
    maxAmount.value = 1000000.0;
    startDate.value = null;
    endDate.value = null;
    invalidateCache(); // 🔧 إبطال cache عند إعادة التعيين
    ErrorHandler.showSuccess('تم إعادة تعيين جميع الفلاتر');
  }

  Map<String, dynamic> getFilterSummary() {
    return {
      'searchQuery': searchQuery.value,
      'category': selectedCategory.value,
      'type': selectedType.value,
      'amountRange': '${minAmount.value} - ${maxAmount.value}',
      'dateRange': startDate.value != null && endDate.value != null
          ? '${startDate.value!.toIso8601String()} to ${endDate.value!.toIso8601String()}'
          : 'غير محدد',
      'resultCount': filteredCount,
    };
  }

  // دالة مساعدة للبحث السريع
  List<ExpenseEntity> quickSearch(String query) {
    final expenseController = Get.find<ExpenseController>();
    return expenseController.expenses.where((expense) {
      return expense.category.arabicName.contains(query) ||
          expense.description.contains(query) ||
          expense.amount.toString().contains(query);
    }).toList();
  }
}
