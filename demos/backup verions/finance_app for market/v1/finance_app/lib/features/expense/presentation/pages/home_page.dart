// lib/features/expense/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/expense_controller.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text('الرصيد الحالي'),
                    Obx(() => Text(
                          '${controller.balance.value} ج.م',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Icon(Icons.arrow_downward,
                                color: Colors.green),
                            const Text('الدخل'),
                            Obx(() => Text('${controller.totalIncome.value}')),
                          ],
                        ),
                        Column(
                          children: [
                            const Icon(Icons.arrow_upward, color: Colors.red),
                            const Text('المصروفات'),
                            Obx(() => Text('${controller.totalExpense.value}')),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.expenses.length,
                  itemBuilder: (context, index) {
                    final expense = controller.expenses[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            expense['isIncome'] ? Icons.download : Icons.upload,
                          ),
                        ),
                        title: Text(expense['category']),
                        subtitle: Text(expense['description']),
                        trailing: Text('${expense['amount']} ج.م'),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // إضافة معاملة تجريبية
          controller.addExpense({
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'amount': 150.0,
            'category': 'تسوق',
            'description': 'شراء ملابس',
            'date': DateTime.now().toString(),
            'isIncome': false,
            'paymentMethod': 'بطاقة ائتمان'
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
