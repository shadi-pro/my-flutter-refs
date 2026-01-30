// lib/features/search/presentation/controllers/expense_search_controller.dart

import 'dart:async';
import 'package:get/get.dart';
import '../../../expense/presentation/controllers/expense_controller.dart';
import '../../../expense/domain/entities/expense_entity.dart';
import '../../../../core/utils/error_handler.dart';
// ✅ ADD IMPORT for ExpenseCategory
import '../../../../core/models/enums.dart';

class ExpenseSearchController extends GetxController {
  static const String TAG = 'ExpenseSearchController';

  final searchQuery = ''.obs;
  final selectedCategory =
      'all'.tr.obs; // This will store DISPLAY text (translated)
  final selectedType = 'all'.tr.obs;
  final minAmount = 0.0.obs;
  final maxAmount = 1000000.0.obs;
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);
  final isFilterActive = false.obs;

  // Store the actual category KEY for filtering
  final _selectedCategoryKey = 'all'.obs;

  // Cache tracking
  List<Map<String, dynamic>>? _cachedFilteredMaps;
  List<ExpenseEntity>? _cachedFilteredEntities;
  String _lastFilterHash = '';
  bool _shouldInvalidateCache = true;

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

  String _getFilterHash() {
    return '${searchQuery.value}_${_selectedCategoryKey.value}_${selectedType.value}_'
        '${minAmount.value}_${maxAmount.value}_'
        '${startDate.value?.millisecondsSinceEpoch}_${endDate.value?.millisecondsSinceEpoch}';
  }

  void invalidateCache() {
    _shouldInvalidateCache = true;
    _cachedFilteredMaps = null;
    _cachedFilteredEntities = null;
  }

  void updateFilterStatus() {
    isFilterActive.value = searchQuery.value.isNotEmpty ||
        _selectedCategoryKey.value != 'all' ||
        selectedType.value != 'all'.tr ||
        minAmount.value > 0.0 ||
        maxAmount.value < 1000000.0 ||
        startDate.value != null ||
        endDate.value != null;
  }

  // Helper: Check if text is Arabic
  bool _isArabicText(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }

  // Helper: Convert Arabic text or key to display text
  String _getDisplayCategory(String category) {
    if (category == 'all') return 'all'.tr;

    // Check if it's Arabic (old data)
    if (_isArabicText(category)) {
      try {
        final expenseCategory = ExpenseCategory.fromString(category);
        return expenseCategory.translationKey.tr;
      } catch (e) {
        return category; // Fallback
      }
    } else {
      // It's a key, translate it
      return category.tr;
    }
  }

  // Helper: Get category key from display text
  String _getCategoryKey(String displayText) {
    if (displayText == 'all'.tr) return 'all';

    // Find which category key produces this display text
    for (var category in ExpenseCategory.values) {
      if (category.translationKey.tr == displayText) {
        return category.translationKey;
      }
    }

    // If not found, check if it's already a key
    for (var category in ExpenseCategory.values) {
      if (category.translationKey == displayText) {
        return displayText;
      }
    }

    return 'all'; // Fallback
  }

  // Set category from UI (receives display text)
  void setSelectedCategory(String displayText) {
    selectedCategory.value = displayText;
    _selectedCategoryKey.value = _getCategoryKey(displayText);
  }

  // Get available categories for dropdown (with "All" option)
  List<String> getAvailableCategories() {
    final Set<String> categories = {'all'.tr};
    final expenseController = Get.find<ExpenseController>();

    for (var expense in expenseController.expenses) {
      // Get display text for this category
      final displayText = _getDisplayCategory(expense.category.translationKey);
      categories.add(displayText);
    }

    return categories.toList()..sort();
  }

  List<Map<String, dynamic>> get filteredExpenses {
    try {
      final currentHash = _getFilterHash();
      if (!_shouldInvalidateCache &&
          _cachedFilteredMaps != null &&
          _lastFilterHash == currentHash) {
        return _cachedFilteredMaps!;
      }

      final expenseController = Get.find<ExpenseController>();
      List<ExpenseEntity> expenseEntities =
          List.from(expenseController.expenses);

      // Search by query
      if (searchQuery.value.isNotEmpty) {
        expenseEntities = expenseEntities.where((expense) {
          // Search in translated category name
          final categoryDisplay =
              _getDisplayCategory(expense.category.translationKey);
          return categoryDisplay
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              expense.description
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase());
        }).toList();
      }

      // Filter by category (using key, not display text)
      if (_selectedCategoryKey.value != 'all') {
        expenseEntities = expenseEntities.where((expense) {
          // Compare category keys
          return expense.category.translationKey == _selectedCategoryKey.value;
        }).toList();
      }

      // Filter by type
      if (selectedType.value != 'all'.tr) {
        expenseEntities = expenseEntities.where((expense) {
          if (selectedType.value == 'income'.tr)
            return expense.isIncome == true;
          if (selectedType.value == 'expense'.tr)
            return expense.isIncome == false;
          return true;
        }).toList();
      }

      // Filter by amount range
      expenseEntities = expenseEntities.where((expense) {
        return expense.amount >= minAmount.value &&
            expense.amount <= maxAmount.value;
      }).toList();

      // Filter by date range
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

      final List<Map<String, dynamic>> result =
          expenseEntities.map((expense) => expense.toMap()).toList();

      // Sort by date (newest first)
      result.sort((a, b) {
        try {
          final dateA = DateTime.parse(a['date']);
          final dateB = DateTime.parse(b['date']);
          return dateB.compareTo(dateA);
        } catch (e) {
          return 0;
        }
      });

      _cachedFilteredMaps = result;
      _cachedFilteredEntities = expenseEntities;
      _lastFilterHash = currentHash;
      _shouldInvalidateCache = false;

      return result;
    } catch (e) {
      ErrorHandler.showError(
          'filter_error_message'.trParams({'e': e.toString()}));
      return [];
    }
  }

  List<ExpenseEntity> get filteredExpenseEntities {
    try {
      if (_cachedFilteredEntities != null && !_shouldInvalidateCache) {
        return _cachedFilteredEntities!;
      }

      if (filteredExpenses.isNotEmpty && _cachedFilteredEntities != null) {
        return _cachedFilteredEntities!;
      }

      final expenseController = Get.find<ExpenseController>();
      List<ExpenseEntity> expenses = List.from(expenseController.expenses);

      if (searchQuery.value.isNotEmpty) {
        expenses = expenses.where((expense) {
          final categoryDisplay =
              _getDisplayCategory(expense.category.translationKey);
          return categoryDisplay
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              expense.description
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase());
        }).toList();
      }

      if (_selectedCategoryKey.value != 'all') {
        expenses = expenses.where((expense) {
          return expense.category.translationKey == _selectedCategoryKey.value;
        }).toList();
      }

      if (selectedType.value != 'all'.tr) {
        expenses = expenses.where((expense) {
          if (selectedType.value == 'income'.tr)
            return expense.isIncome == true;
          if (selectedType.value == 'expense'.tr)
            return expense.isIncome == false;
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

      _cachedFilteredEntities = expenses;
      _shouldInvalidateCache = false;

      return expenses;
    } catch (e) {
      ErrorHandler.showError(
          'filter_error_message'.trParams({'e': e.toString()}));
      return [];
    }
  }

  int get filteredCount => filteredExpenses.length;

  void resetFilters() {
    searchQuery.value = '';
    selectedCategory.value = 'all'.tr;
    _selectedCategoryKey.value = 'all';
    selectedType.value = 'all'.tr;
    minAmount.value = 0.0;
    maxAmount.value = 1000000.0;
    startDate.value = null;
    endDate.value = null;

    invalidateCache();
    ErrorHandler.showSuccess('filter_reset_message'.tr);
  }

  Map<String, dynamic> getFilterSummary() {
    return {
      'searchQuery': searchQuery.value,
      'category': selectedCategory.value,
      'categoryKey': _selectedCategoryKey.value,
      'type': selectedType.value,
      'amountRange': '${minAmount.value} - ${maxAmount.value}',
      'dateRange': startDate.value != null && endDate.value != null
          ? '${startDate.value!.toIso8601String()} to ${endDate.value!.toIso8601String()}'
          : 'not_specified'.tr,
      'resultCount': filteredCount,
    };
  }

  List<ExpenseEntity> quickSearch(String query) {
    final expenseController = Get.find<ExpenseController>();
    return expenseController.expenses.where((expense) {
      final categoryDisplay =
          _getDisplayCategory(expense.category.translationKey);
      return categoryDisplay.contains(query) ||
          expense.description.contains(query) ||
          expense.amount.toString().contains(query);
    }).toList();
  }
}
