import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:finance_app/features/expense/presentation/controllers/expense_controller.dart';
import 'package:finance_app/core/security/simple_encryption.dart';

class BudgetController extends GetxController {
  final _storage = GetStorage();

  // الميزانية الشهرية
  final monthlyBudget = 0.0.obs;

  // الميزانية حسب الفئات
  final categoryBudgets = <String, double>{}.obs;

  // الفئات الأساسية للميزانية
  final List<String> defaultCategories = [
    'طعام',
    'مواصلات',
    'تسوق',
    'ترفيه',
    'صحة',
    'تعليم',
    'سكن',
    'فواتير',
  ];

  @override
  void onInit() {
    super.onInit();
    loadBudgetData();
  }

  // تحميل بيانات الميزانية
  Future<void> loadBudgetData() async {
    try {
      // ✅ استخدام SimpleEncryption لقراءة الميزانية الشهرية
      final storedMonthlyBudget = SimpleEncryption.read('monthlyBudget');
      monthlyBudget.value = (storedMonthlyBudget as num?)?.toDouble() ?? 0.0;

      // ✅ استخدام SimpleEncryption لقراءة ميزانيات الفئات
      final storedCategoryBudgets =
          SimpleEncryption.read('categoryBudgets') ?? {};
      categoryBudgets.value = Map<String, double>.from(storedCategoryBudgets);

      // تهيئة الفئات إذا كانت فارغة
      if (categoryBudgets.isEmpty) {
        for (var category in defaultCategories) {
          categoryBudgets[category] = 0.0;
        }
      }

      print('✅ Budget data loaded successfully');
    } catch (e) {
      print('خطأ في تحميل بيانات الميزانية: $e');
      _initializeDefaultBudgets();
    }
  }

  // تهيئة الميزانية الافتراضية
  void _initializeDefaultBudgets() {
    for (var category in defaultCategories) {
      categoryBudgets[category] = 0.0;
    }
    monthlyBudget.value = 0.0;
  }

  // تحديث الميزانية الشهرية
  Future<void> setMonthlyBudget(double amount) async {
    monthlyBudget.value = amount;

    // ✅ استخدام SimpleEncryption لحفظ الميزانية
    await SimpleEncryption.write('monthlyBudget', amount);

    update();
    print('💰 Monthly budget updated: $amount');
  }

  // تحديث ميزانية فئة محددة
  Future<void> setCategoryBudget(String category, double amount) async {
    categoryBudgets[category] = amount;
    await _saveCategoryBudgets();
    update();
    print('📊 Category budget updated: $category = $amount');
  }

  // حفظ ميزانيات الفئات
  Future<void> _saveCategoryBudgets() async {
    // ✅ استخدام SimpleEncryption لحفظ ميزانيات الفئات
    await SimpleEncryption.write('categoryBudgets', categoryBudgets);
  }

  // باقي الدوال كما هي بدون تغيير...
  double get totalCategoryBudgets {
    return categoryBudgets.values.fold(0.0, (sum, budget) => sum + budget);
  }

  // التحقق من تجاوز الميزانية
  double get remainingBudget {
    final expenseController = Get.find<ExpenseController>();
    return monthlyBudget.value - expenseController.totalExpense.value;
  }

  // نسبة الإنفاق من الميزانية
  double get spendingPercentage {
    if (monthlyBudget.value <= 0) return 0;
    final expenseController = Get.find<ExpenseController>();
    return (expenseController.totalExpense.value / monthlyBudget.value) * 100;
  }

  // الحصول على الميزانية المتبقية لكل فئة
  Map<String, double> getRemainingCategoryBudgets() {
    final expenseController = Get.find<ExpenseController>();
    final categoryExpenses = expenseController.getExpensesByCategory(false);

    final Map<String, double> remaining = {};

    for (var category in categoryBudgets.keys) {
      final budget = categoryBudgets[category] ?? 0.0;
      final spent = categoryExpenses[category] ?? 0.0;
      remaining[category] = budget - spent;
    }

    return remaining;
  }

  // الحصول على تحذيرات الميزانية
  List<String> getBudgetAlerts() {
    final List<String> alerts = [];
    final expenseController = Get.find<ExpenseController>();

    // تحذير الميزانية الشهرية
    if (spendingPercentage >= 80) {
      alerts.add(
          '⚠️ أنت أنفقت ${spendingPercentage.toStringAsFixed(0)}% من ميزانيتك');
    }

    if (spendingPercentage >= 100) {
      alerts.add('🚨 تجاوزت ميزانيتك الشهرية!');
    }

    // تحذيرات الفئات
    final remainingBudgets = getRemainingCategoryBudgets();
    for (var entry in remainingBudgets.entries) {
      if (entry.value < 0) {
        alerts.add(
            '📌 تجاوزت ميزانية "${entry.key}" بمقدار ${entry.value.abs().toStringAsFixed(2)} ج.م');
      }
    }

    return alerts;
  }

  // إعادة تعيين الميزانية
  Future<void> resetBudget() async {
    try {
      monthlyBudget.value = 0.0;
      categoryBudgets.clear();
      _initializeDefaultBudgets();

      // ✅ استخدام SimpleEncryption لحذف بيانات الميزانية
      await SimpleEncryption.remove('monthlyBudget');
      await SimpleEncryption.remove('categoryBudgets');

      // Alternative: You can also write null values
      // await SimpleEncryption.write('monthlyBudget', null);
      // await SimpleEncryption.write('categoryBudgets', null);

      update();
      print('🔄 تم إعادة تعيين الميزانية');
    } catch (e) {
      print('⚠️ خطأ في إعادة تعيين الميزانية: $e');
      // Fallback: Reset in memory even if storage fails
      monthlyBudget.value = 0.0;
      categoryBudgets.clear();
      _initializeDefaultBudgets();
      update();
    }
  }
}
