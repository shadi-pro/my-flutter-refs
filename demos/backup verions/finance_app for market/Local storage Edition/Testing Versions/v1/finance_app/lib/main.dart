import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/expense/presentation/controllers/expense_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. تهيئة الـ Controller هنا قبل استخدامه
    Get.put(ExpenseController());

    return GetMaterialApp(
      title: 'Finance App',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

// 3. HomePage مبسط للاختبار
class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ExpenseController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مالي - Finance App'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('GetX يعمل!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  Get.snackbar('نجاح', 'Controller: ${controller.hashCode}'),
              child: const Text('اختبر Controller'),
            ),
          ],
        ),
      ),
    );
  }
}
