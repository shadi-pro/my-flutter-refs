// lib/features/expense/presentation/bindings/expense_binding.dart
import 'package:get/get.dart';

import '../controllers/expense_controller.dart';

class ExpenseBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExpenseController());
  }
}
