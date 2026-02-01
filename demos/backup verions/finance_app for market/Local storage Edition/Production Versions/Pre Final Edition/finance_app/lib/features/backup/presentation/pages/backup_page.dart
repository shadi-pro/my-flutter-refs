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
        title: Text('backup'.tr),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  Info Card backup copy
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
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
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.center,
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

              // Action section Title
              Text(
                'actions'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // 1. Creating full backup version
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.save, color: Colors.green),
                  title: Text('create_backup'.tr),
                  subtitle: Text('save_copy'.tr),
                  trailing: Obx(() => _controller.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.chevron_right)),
                  onTap: _controller.createBackup,
                ),
              ),

              const SizedBox(height: 8),

              // 2. restore backup version
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.restore, color: Colors.orange),
                  title: Text('restore'.tr),
                  subtitle: Text('restore_backup_desc'.tr),
                  trailing: Obx(() => _controller.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.chevron_right)),
                  onTap: _controller.restoreBackup,
                ),
              ),

              const SizedBox(height: 8),

              // 3. Export Text data
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.description, color: Colors.blue),
                  title: Text('export_data'.tr),
                  subtitle: Text('save_copy'.tr),
                  trailing: Obx(() => _controller.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.chevron_right)),
                  onTap: _controller.exportSimpleBackup,
                ),
              ),

              const SizedBox(height: 24),

              // Important Tips section
              Text(
                'important_tips'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TipsRow(
                        icon: Icons.schedule,
                        text: 'tip_weekly_backup'.tr,
                      ),
                      const SizedBox(height: 8),
                      TipsRow(
                        icon: Icons.folder,
                        text: 'tip_save_location'.tr,
                      ),
                      const SizedBox(height: 8),
                      TipsRow(
                        icon: Icons.security,
                        text: 'tip_dont_share'.tr,
                      ),
                      const SizedBox(height: 8),
                      TipsRow(
                        icon: Icons.devices,
                        text: 'tip_cross_device'.tr,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              //  Addition Statistics
              FutureBuilder<int>(
                future: _controller.getBackupFileCount(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final fileCount = snapshot.data ?? 0;

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.analytics, color: Colors.purple),
                              const SizedBox(width: 8),
                              Text(
                                'backup_stats'.tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                'backup_files'.tr,
                                fileCount.toString(),
                                Icons.folder,
                                Colors.blue,
                              ),
                              Obx(() => _buildStatItem(
                                    'last_backup'.tr,
                                    _controller.lastBackupDate.value != null
                                        ? DateFormat('MM/dd').format(
                                            _controller.lastBackupDate.value!)
                                        : '--',
                                    Icons.calendar_today,
                                    Colors.green,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Security Note
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.security, color: Colors.orange, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'security_note'.tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'security_note_desc'.tr,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              //  Advanced Options button
              OutlinedButton.icon(
                onPressed: () {
                  _showAdvancedOptions();
                },
                icon: const Icon(Icons.settings),
                label: Text('advanced_options'.tr),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  void _showAdvancedOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'advanced_options'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // advanced options
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text('clear_backup_history'.tr),
              subtitle: Text('clear_backup_history_desc'.tr),
              onTap: () {
                Get.back();
                _controller.clearBackupData();
              },
            ),

            ListTile(
              leading: const Icon(Icons.info, color: Colors.blue),
              title: Text('system_info'.tr),
              subtitle: Text('system_info_desc'.tr),
              onTap: () {
                Get.back();
                _showSystemInfo();
              },
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: Get.back,
                child: Text('close'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSystemInfo() {
    Get.dialog(
      AlertDialog(
        title: Text('system_info'.tr),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'local_storage'.tr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('• ${'storage_getstorage'.tr}'),
              Text('• ${'storage_encryption'.tr}'),
              Text('• ${'storage_temp_files'.tr}'),
              const SizedBox(height: 16),
              Text(
                'compatibility'.tr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('• ${'compat_android_ios'.tr}'),
              Text('• ${'compat_restore_any'.tr}'),
              Text('• ${'compat_data_format'.tr}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text('ok'.tr),
          ),
        ],
      ),
    );
  }
}

// Tips Row Widget
class TipsRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const TipsRow({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
