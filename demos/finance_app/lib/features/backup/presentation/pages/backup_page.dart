// finance_app\lib\features\backup\presentation\pages\backup_page.dart

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
        title: const Text('النسخ الاحتياطي والاستعادة'),
        centerTitle: true,
      ),
      body: SafeArea(
        // ✅ أضف SafeArea
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Backup Info Card
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

              // Actions
              const Text(
                'الإجراءات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Create Full Backup
              Card(
                child: ListTile(
                  leading: const Icon(Icons.save, color: Colors.green),
                  title: const Text('إنشاء نسخة احتياطية كاملة'),
                  subtitle: const Text('حفظ جميع البيانات في ملف'),
                  trailing: Obx(() => _controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.chevron_right)),
                  onTap: _controller.createBackup,
                ),
              ),

              // Restore Backup
              Card(
                child: ListTile(
                  leading: const Icon(Icons.restore, color: Colors.orange),
                  title: const Text('استعادة النسخة الاحتياطية'),
                  subtitle: const Text('تحميل البيانات من ملف النسخ الاحتياطي'),
                  trailing: Obx(() => _controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.chevron_right)),
                  onTap: _controller.restoreBackup,
                ),
              ),

              // Export Text Report
              Card(
                child: ListTile(
                  leading: const Icon(Icons.description, color: Colors.blue),
                  title: const Text('تصدير تقرير نصي'),
                  subtitle: const Text('مشاركة ملخص المعاملات'),
                  onTap: _controller.exportSimpleBackup,
                ),
              ),

              const SizedBox(height: 32),

              // Important Tips
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
                      Text('• قم بإنشاء نسخة احتياطية أسبوعياً'),
                      Text('• احفظ ملفات النسخ الاحتياطي في مكان آمن'),
                      Text('• لا تشارك ملفات النسخ الاحتياطي مع الآخرين'),
                      Text('• يمكنك الاستعادة على أي جهاز'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Security Note - ❌ إزالة Spacer
              Container(
                width: double.infinity, // ✅ تأكيد العرض
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20), // ✅ بدلاً من Spacer
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.security, color: Colors.orange),
                    const SizedBox(width: 12),
                    Expanded(
                      // ✅ هذا Expanded صحيح لأنه داخل Row
                      child: Text(
                        'بياناتك مخزنة محلياً على جهازك ولا يتم رفعها لأي مكان',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
