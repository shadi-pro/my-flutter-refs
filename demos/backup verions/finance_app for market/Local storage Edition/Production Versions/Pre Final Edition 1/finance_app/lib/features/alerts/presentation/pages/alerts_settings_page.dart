// lib/features/alerts/presentation/pages/alerts_settings_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/alert_controller.dart';

class AlertsSettingsPage extends StatelessWidget {
  AlertsSettingsPage({super.key});
  final AlertController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('alerts'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Budet alerts
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.account_balance_wallet,
                            color: Colors.orange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'budget_alerts'.tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Obx(() => Switch(
                              value: _controller.budgetAlertsEnabled.value,
                              onChanged: (value) {
                                _controller.budgetAlertsEnabled.value = value;
                                _controller.saveAlertSettings();
                              },
                            )),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Obx(() => Column(
                          children: [
                            Text(
                              'budget_alert_threshold'.trParams({
                                'value': _controller.budgetAlertThreshold.value
                                    .toInt()
                                    .toString()
                              }),
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Slider(
                              value: _controller.budgetAlertThreshold.value,
                              min: 50,
                              max: 100,
                              divisions: 10,
                              label:
                                  '${_controller.budgetAlertThreshold.value.toInt()}%',
                              onChanged: _controller.budgetAlertsEnabled.value
                                  ? (value) {
                                      _controller.budgetAlertThreshold.value =
                                          value;
                                      _controller.saveAlertSettings();
                                    }
                                  : null,
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            //  Large Expenese alerts
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.red),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'large_expense_alert'.tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Obx(() => Switch(
                              value:
                                  _controller.largeExpenseAlertsEnabled.value,
                              onChanged: (value) {
                                _controller.largeExpenseAlertsEnabled.value =
                                    value;
                                _controller.saveAlertSettings();
                              },
                            )),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Obx(() => Column(
                          children: [
                            Text(
                              'large_expense_alert_threshold'.trParams({
                                'value': _controller.largeExpenseThreshold.value
                                    .toInt()
                                    .toString(),
                                'currency': 'currency_suffix'.tr
                              }),
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Slider(
                              value: _controller.largeExpenseThreshold.value,
                              min: 100,
                              max: 2000,
                              divisions: 19,
                              label:
                                  '${_controller.largeExpenseThreshold.value.toInt()} ${'currency_suffix'.tr}',
                              onChanged: _controller
                                      .largeExpenseAlertsEnabled.value
                                  ? (value) {
                                      _controller.largeExpenseThreshold.value =
                                          value;
                                      _controller.saveAlertSettings();
                                    }
                                  : null,
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            //  Daily Breif
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.summarize, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'daily_summary'.tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'daily_summary_desc'.tr,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Obx(() => Switch(
                          value: _controller.dailySummaryEnabled.value,
                          onChanged: (value) {
                            _controller.dailySummaryEnabled.value = value;
                            _controller.saveAlertSettings();
                          },
                        )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            //  Seleting Alerts
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  _controller.showLargeExpenseAlert(600, 'تسوق');
                },
                icon: const Icon(Icons.notifications_active),
                label: Text('test_alerts'.tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
