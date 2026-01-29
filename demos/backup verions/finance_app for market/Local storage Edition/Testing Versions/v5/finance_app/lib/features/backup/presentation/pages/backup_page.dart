// lib/features/backup/presentation/pages/backup_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/backup_controller.dart';

class BackupPage extends StatelessWidget {
  BackupPage({super.key});
  final BackupController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('النسخ الاحتياطي'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معلومات النسخ الاحتياطية
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.backup, size: 64, color: Colors.blue),
                    const SizedBox(height: 16),
                    Obx(() => Text(
                          _controller.backupInfo,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    const SizedBox(height: 8),
                    Obx(() {
                      if (_controller.lastBackupDate.value != null) {
                        return Text(
                          DateFormat('yyyy/MM/dd HH:mm')
                              .format(_controller.lastBackupDate.value!),
                          style: const TextStyle(color: Colors.grey),
                        );
                      }
                      return const SizedBox();
                    }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // إجراءات النسخ الاحتياطي
            const Text(
              'الإجراءات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // إنشاء نسخة احتياطية كاملة
            Card(
              child: ListTile(
                leading: const Icon(Icons.save, color: Colors.green),
                title: const Text('إنشاء نسخة احتياطية'),
                subtitle: const Text('حفظ جميع البيانات في ملف'),
                trailing: Obx(() => _controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.chevron_right)),
                onTap: _controller.createBackup,
              ),
            ),

            // تصدير تقرير نصي
            Card(
              child: ListTile(
                leading: const Icon(Icons.description, color: Colors.blue),
                title: const Text('تصدير تقرير نصي'),
                subtitle: const Text('مشاركة ملخص البيانات'),
                onTap: _controller.exportSimpleBackup,
              ),
            ),

            // استعادة نسخة احتياطية
            Card(
              child: ListTile(
                leading: const Icon(Icons.restore, color: Colors.orange),
                title: const Text('استعادة نسخة احتياطية'),
                subtitle: const Text('تحميل بيانات من ملف'),
                onTap: () {
                  Get.snackbar(
                    'قريباً',
                    'سيتم إضافة هذه الميزة قريباً',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // نصائح مهمة
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 نصائح مهمة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('• أنشئ نسخة احتياطية أسبوعياً'),
                    Text('• احفظ الملف في مكان آمن'),
                    Text('• لا تشارك ملفاتك مع الآخرين'),
                    Text('• يمكنك استعادة البيانات على أي جهاز'),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // ملاحظة أمان
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.security, color: Colors.orange),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'بياناتك محفوظة محلياً على جهازك ولا نصل إليها',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
