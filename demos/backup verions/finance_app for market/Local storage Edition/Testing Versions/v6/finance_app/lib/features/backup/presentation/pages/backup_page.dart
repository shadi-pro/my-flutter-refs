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
        title: const Text('Backup & Restore'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
              'Actions',
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
                title: const Text('Create Full Backup'),
                subtitle: const Text('Save all data to a file'),
                trailing: Obx(() => _controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.chevron_right)),
                onTap: _controller.createBackup,
              ),
            ),

            // Restore Backup - NOW WORKING
            Card(
              child: ListTile(
                leading: const Icon(Icons.restore, color: Colors.orange),
                title: const Text('Restore Backup'),
                subtitle: const Text('Load data from backup file'),
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
                title: const Text('Export Text Report'),
                subtitle: const Text('Share transaction summary'),
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
                      '💡 Important Tips',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('• Create weekly backups'),
                    Text('• Store backup files in a safe place'),
                    Text('• Don\'t share backup files with others'),
                    Text('• You can restore on any device'),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Security Note
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
                      'Your data is stored locally on your device and never uploaded anywhere',
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
