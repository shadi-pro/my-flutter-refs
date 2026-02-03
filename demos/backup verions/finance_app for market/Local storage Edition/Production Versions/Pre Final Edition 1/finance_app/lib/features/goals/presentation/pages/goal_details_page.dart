// FILE: lib/features/goals/presentation/pages/goal_details_page.dart

import 'dart:ui' as ui;
import 'package:finance_app/features/goals/presentation/pages/add_edit_goal_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/goal_controller.dart';
import '../../../../core/models/goal_entity.dart';
import '../../../../core/utils/error_handler.dart';

class GoalDetailsPage extends StatefulWidget {
  final String goalId;

  const GoalDetailsPage({super.key, required this.goalId});

  @override
  State<GoalDetailsPage> createState() => _GoalDetailsPageState();
}

class _GoalDetailsPageState extends State<GoalDetailsPage> {
  final GoalController _controller = Get.find<GoalController>();
  final _contributionAmountController = TextEditingController();
  final _contributionNoteController = TextEditingController();

  FinancialGoal? _goal;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGoal();
  }

  Future<void> _loadGoal() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 300));

    final goal = _controller.getGoalById(widget.goalId);
    if (goal == null) {
      ErrorHandler.showError('goal_not_found'.tr);
      Get.back();
      return;
    }

    setState(() {
      _goal = goal;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _contributionAmountController.dispose();
    _contributionNoteController.dispose();
    super.dispose();
  }

  void _showAddContributionDialog() {
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                'add_contribution'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _contributionAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'contribution_amount'.tr,
                  prefixIcon: const Icon(Icons.attach_money),
                  suffixText: 'currency_suffix'.tr,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter_amount'.tr;
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'enter_valid_amount'.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contributionNoteController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'contribution_note'.tr,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: Text('cancel'.tr),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _addContribution,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text('save_contribution'.tr),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addContribution() {
    try {
      final amount = double.tryParse(_contributionAmountController.text);
      if (amount == null || amount <= 0) {
        throw Exception('enter_valid_amount'.tr);
      }

      if (_goal == null) return;

      _controller.addContribution(
        _goal!.id,
        amount,
        _contributionNoteController.text.trim(),
      );

      _contributionAmountController.clear();
      _contributionNoteController.clear();

      Get.back();
      _loadGoal(); // إعادة تحميل الهدف لتحديث البيانات
    } catch (e) {
      ErrorHandler.showError('خطأ في إضافة المساهمة: ${e.toString()}');
    }
  }

  void _showEditGoal() {
    if (_goal == null) return;
    Get.to(() => AddEditGoalPage(existingGoal: _goal));
  }

  void _showDeleteConfirmation() {
    Get.defaultDialog(
      title: 'confirm_delete_goal'.tr,
      middleText: 'delete_goal_question'.tr,
      textConfirm: 'delete'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Colors.white,
      onConfirm: () {
        _controller.deleteGoal(widget.goalId);
        Get.back();
        Get.back();
      },
    );
  }

  void _showContributionDetails(Contribution contribution) {
    Get.defaultDialog(
      title: 'contribution_details'.tr,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
              'amount'.tr, '${contribution.amount} ${'currency_suffix'.tr}'),
          _buildDetailRow('date'.tr, _formatDate(contribution.date)),
          if (contribution.note.isNotEmpty)
            _buildDetailRow('note'.tr, contribution.note),
        ],
      ),
      textConfirm: 'ok'.tr,
      onConfirm: Get.back,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _goal == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final goal = _goal!;
    final icon = GoalCategories.getIconForCategory(goal.category);
    final color = GoalColors.hexToColor(goal.colorHex);

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('goal_details'.tr),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _showEditGoal,
              tooltip: 'edit_goal'.tr,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _showDeleteConfirmation,
              tooltip: 'delete_goal'.tr,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // بطاقة الهدف الرئيسية
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: color.withOpacity(0.2),
                            radius: 28,
                            child: Text(
                              icon,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  goal.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (goal.description.isNotEmpty)
                                  Text(
                                    goal.description,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          _buildPriorityChip(goal.priority),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // شريط التقدم
                      _buildProgressSection(goal, color),

                      const SizedBox(height: 24),

                      // معلومات إضافية
                      _buildGoalInfo(goal, color),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // زر إضافة مساهمة
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showAddContributionDialog,
                  icon: const Icon(Icons.add),
                  label: Text('add_contribution'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // سجل المساهمات
              _buildContributionsList(goal),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection(FinancialGoal goal, ui.Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'progress'.tr,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              '${goal.progressPercentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: goal.progressPercentage >= 100 ? Colors.green : color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: goal.progressPercentage / 100,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            goal.progressPercentage >= 100 ? Colors.green : color,
          ),
          minHeight: 12,
          borderRadius: BorderRadius.circular(6),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'saved'.tr,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  '${goal.currentAmount.toStringAsFixed(0)} ${'currency_suffix'.tr}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'target'.tr,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  '${goal.targetAmount.toStringAsFixed(0)} ${'currency_suffix'.tr}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'remaining'.tr,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  '${goal.remainingAmount.toStringAsFixed(0)} ${'currency_suffix'.tr}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
        if (!goal.isCompleted) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'daily_saving_needed'.tr,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${goal.requiredDailySaving.toStringAsFixed(1)} ${'currency_suffix'.tr}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${goal.daysRemaining} ${'days_left'.tr}',
                  style: TextStyle(
                    fontSize: 14,
                    color: goal.daysRemaining <= 7 ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGoalInfo(FinancialGoal goal, ui.Color color) {
    return Column(
      children: [
        _buildInfoRow(
          icon: Icons.category,
          label: 'category'.tr,
          value: goal.category,
          color: color,
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          icon: Icons.calendar_today,
          label: 'start_date'.tr,
          value: _formatDate(goal.startDate),
          color: Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          icon: Icons.flag,
          label: 'target_date'.tr,
          value: _formatDate(goal.targetDate),
          color: Colors.green,
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          icon: Icons.timeline,
          label: 'duration'.tr,
          value:
              '${goal.targetDate.difference(goal.startDate).inDays} ${'days'.tr}',
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required ui.Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityChip(GoalPriority priority) {
    final Map<GoalPriority, Map<String, dynamic>> priorityInfo = {
      GoalPriority.low: {'label': 'low'.tr, 'color': Colors.green},
      GoalPriority.medium: {'label': 'medium'.tr, 'color': Colors.orange},
      GoalPriority.high: {'label': 'high'.tr, 'color': Colors.red},
      GoalPriority.critical: {'label': 'critical'.tr, 'color': Colors.purple},
    };

    final info = priorityInfo[priority] ?? priorityInfo[GoalPriority.medium]!;

    return Chip(
      label: Text(info['label']),
      backgroundColor: info['color'].withOpacity(0.1),
      labelStyle: TextStyle(
        color: info['color'],
        fontWeight: FontWeight.bold,
      ),
      avatar: Icon(Icons.priority_high, color: info['color'], size: 16),
    );
  }

  Widget _buildContributionsList(FinancialGoal goal) {
    if (goal.contributions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'no_contributions'.tr,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'add_your_first_contribution'.tr,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'contributions_history'.tr,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        // إجمالي المساهمات
        Card(
          color: Colors.green[50],
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'total_contributions'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${goal.contributions.length} ${'contributions'.tr}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // قائمة المساهمات
        ...goal.contributions.reversed.map((contribution) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green.withOpacity(0.1),
                child: const Icon(Icons.attach_money, color: Colors.green),
              ),
              title: Text(
                '${contribution.amount} ${'currency_suffix'.tr}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (contribution.note.isNotEmpty) Text(contribution.note),
                  Text(
                    _formatDate(contribution.date),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_left),
              onTap: () => _showContributionDetails(contribution),
            ),
          );
        }).toList(),
      ],
    );
  }
}
