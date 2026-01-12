import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class ExpenseController extends GetxController {
  final _storage = GetStorage();
  final expenses = [].obs;
  final isLoading = false.obs;
  final totalIncome = 0.0.obs;
  final totalExpense = 0.0.obs;
  final balance = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadExpenses();
  }

  // تحميل البيانات من التخزين المحلي
  Future<void> loadExpenses() async {
    isLoading.value = true;

    try {
      final storedExpenses = _storage.read('expenses');

      if (storedExpenses == null || storedExpenses.isEmpty) {
        // إذا لا توجد بيانات، أضف بيانات تجريبية
        await addTestData();
      } else {
        expenses.value = List.from(storedExpenses);
        calculateRealTotals();
      }
    } catch (e) {
      print('خطأ في تحميل البيانات: $e');
      await addTestData();
    } finally {
      isLoading.value = false;
    }
  }

  // إضافة بيانات تجريبية
  Future<void> addTestData() async {
    expenses.value = [
      {
        'id': '1',
        'amount': 5000.0,
        'category': 'مرتب',
        'description': 'مرتب شهر يناير',
        'date': DateTime.now().toIso8601String(),
        'isIncome': true,
        'paymentMethod': 'تحويل بنكي'
      },
      {
        'id': '2',
        'amount': 300.0,
        'category': 'طعام',
        'description': 'سوق الأسبوع',
        'date': DateTime.now().toIso8601String(),
        'isIncome': false,
        'paymentMethod': 'نقدي'
      },
      {
        'id': '3',
        'amount': 150.0,
        'category': 'مواصلات',
        'description': 'بنزين السيارة',
        'date': DateTime.now().toIso8601String(),
        'isIncome': false,
        'paymentMethod': 'بطاقة ائتمان'
      },
    ];

    await _saveToStorage();
    calculateRealTotals();
  }

  // حساب الإجماليات الحقيقية
  void calculateRealTotals() {
    double income = 0;
    double expense = 0;

    for (var item in expenses) {
      if (item['isIncome'] == true) {
        income += (item['amount'] as num).toDouble();
      } else {
        expense += (item['amount'] as num).toDouble();
      }
    }

    totalIncome.value = income;
    totalExpense.value = expense;
    balance.value = income - expense;

    // تحديث مباشر
    update();
  }

  // إضافة معاملة جديدة
  Future<void> addExpense(Map<String, dynamic> expense) async {
    try {
      // التأكد من وجود ID
      if (expense['id'] == null) {
        expense['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      }

      // التأكد من أن المبلغ رقم
      expense['amount'] = (expense['amount'] as num).toDouble();

      expenses.add(expense);
      await _saveToStorage();
      calculateRealTotals();

      Get.snackbar(
        'تم الحفظ ✅',
        'تم إضافة المعاملة بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('خطأ في إضافة المعاملة: $e');
      Get.snackbar(
        'خطأ ❌',
        'فشل في إضافة المعاملة',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.red,
      );
    }
  }

  // تحديث معاملة
  Future<void> updateExpense(int index, Map<String, dynamic> expense) async {
    try {
      expenses[index] = expense;
      await _saveToStorage();
      calculateRealTotals();

      Get.snackbar(
        'تم التحديث ✅',
        'تم تحديث المعاملة بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('خطأ في تحديث المعاملة: $e');
      Get.snackbar(
        'خطأ ❌',
        'فشل في تحديث المعاملة',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.red,
      );
    }
  }

  // حذف معاملة
  Future<void> deleteExpense(int index) async {
    try {
      final deletedExpense = expenses[index];
      expenses.removeAt(index);
      await _saveToStorage();
      calculateRealTotals();

      Get.snackbar(
        'تم الحذف ✅',
        'تم حذف المعاملة بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('خطأ في حذف المعاملة: $e');
      Get.snackbar(
        'خطأ ❌',
        'فشل في حذف المعاملة',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.red,
      );
    }
  }

  // مسح كل البيانات
  Future<void> clearAllData() async {
    try {
      expenses.clear();
      await _storage.remove('expenses');
      calculateRealTotals();

      Get.snackbar(
        'تم المسح ✅',
        'تم مسح كل البيانات بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('خطأ في مسح البيانات: $e');
      Get.snackbar(
        'خطأ ❌',
        'فشل في مسح البيانات',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.red,
      );
    }
  }

  // الحصول على إحصائيات الشهر الحالي
  Map<String, dynamic> getMonthlyStats() {
    final now = DateTime.now();
    final monthlyExpenses = expenses.where((expense) {
      try {
        final date = DateTime.parse(expense['date']);
        return date.month == now.month && date.year == now.year;
      } catch (e) {
        return false;
      }
    }).toList();

    double monthlyIncome = 0;
    double monthlyExpense = 0;

    for (var expense in monthlyExpenses) {
      if (expense['isIncome'] == true) {
        monthlyIncome += (expense['amount'] as num).toDouble();
      } else {
        monthlyExpense += (expense['amount'] as num).toDouble();
      }
    }

    return {
      'income': monthlyIncome,
      'expense': monthlyExpense,
      'balance': monthlyIncome - monthlyExpense,
      'count': monthlyExpenses.length,
    };
  }

  // الحصول على المعاملات حسب الفئة
  Map<String, double> getExpensesByCategory(bool isIncome) {
    final Map<String, double> categoryTotals = {};

    final filteredExpenses =
        expenses.where((expense) => expense['isIncome'] == isIncome);

    for (var expense in filteredExpenses) {
      final category = expense['category'];
      final amount = (expense['amount'] as num).toDouble();

      categoryTotals.update(
        category,
        (value) => value + amount,
        ifAbsent: () => amount,
      );
    }

    return categoryTotals;
  }

  // حفظ البيانات في التخزين المحلي
  Future<void> _saveToStorage() async {
    try {
      await _storage.write('expenses', expenses.toList());
    } catch (e) {
      print('خطأ في حفظ البيانات: $e');
      rethrow;
    }
  }

  // الحصول على عدد المعاملات
  int get expenseCount => expenses.length;

  // الحصول على أحدث المعاملات
  List get recentExpenses {
    final sorted = List.from(expenses);
    sorted.sort((a, b) {
      try {
        final dateA = DateTime.parse(a['date']);
        final dateB = DateTime.parse(b['date']);
        return dateB.compareTo(dateA);
      } catch (e) {
        return 0;
      }
    });
    return sorted.take(10).toList();
  }
}
