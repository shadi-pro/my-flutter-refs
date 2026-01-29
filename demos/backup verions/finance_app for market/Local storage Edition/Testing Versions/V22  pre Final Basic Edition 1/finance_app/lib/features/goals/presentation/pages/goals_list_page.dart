// FILE: lib/features/goals/presentation/pages/goals_list_page.dart
import 'dart:ui' as ui;
import 'package:finance_app/features/goals/presentation/pages/add_edit_goal_page.dart';
import 'package:finance_app/features/goals/presentation/pages/goal_details_page.dart';
import 'package:finance_app/features/goals/presentation/pages/goal_stats_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/goal_controller.dart';
import '../../../../core/models/goal_entity.dart';

class GoalsListPage extends StatelessWidget {
  GoalsListPage({super.key});
  final GoalController _controller = Get.find<GoalController>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('financial_goals'.tr),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Get.to(() => AddEditGoalPage());
              },
              tooltip: 'add_goal'.tr,
            ),
            IconButton(
              icon: const Icon(Icons.analytics),
              onPressed: () {
                Get.to(() => GoalStatsPage());
              },
              tooltip: 'goal_stats'.tr,
            ),
          ],
        ),
        body: Obx(() {
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_controller.goals.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              // شريط الإحصائيات السريعة
              _buildQuickStats(),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // الأهداف النشطة
                    if (_controller.activeGoals.isNotEmpty) ...[
                      _buildSectionTitle('active_goals'.tr),
                      ..._controller.activeGoals
                          .map((goal) => _buildGoalCard(goal))
                          .toList(),
                      const SizedBox(height: 24),
                    ],

                    // الأهداف المكتملة
                    if (_controller.completedGoals.isNotEmpty) ...[
                      _buildSectionTitle('completed_goals'.tr),
                      ..._controller.completedGoals
                          .map(
                              (goal) => _buildGoalCard(goal, isCompleted: true))
                          .toList(),
                    ],
                  ],
                ),
              ),
            ],
          );
        }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Get.to(() => AddEditGoalPage());
          },
          icon: const Icon(Icons.add),
          label: Text('add_new_goal'.tr),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.flag, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            'no_goals_yet'.tr,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Text(
            'start_by_adding_your_first_goal'.tr,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              Get.to(() => AddEditGoalPage());
            },
            icon: const Icon(Icons.add),
            label: Text('create_first_goal'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.green[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'total_goals'.tr,
            _controller.goals.length.toString(),
            Icons.flag,
            Colors.green,
          ),
          _buildStatItem(
            'total_saved'.tr,
            '${_controller.totalCurrentAmount.toStringAsFixed(0)} ${'currency_suffix'.tr}',
            Icons.savings,
            Colors.blue,
          ),
          _buildStatItem(
            'progress'.tr,
            '${_controller.overallProgress.toStringAsFixed(0)}%',
            Icons.trending_up,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildGoalCard(FinancialGoal goal, {bool isCompleted = false}) {
    final icon = GoalCategories.getIconForCategory(goal.category);
    final color = GoalColors.hexToColor(goal.colorHex);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3), width: 1),
      ),
      child: InkWell(
        onTap: () {
          Get.to(() => GoalDetailsPage(goalId: goal.id));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color.withOpacity(0.2),
                    child: Text(icon, style: const TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (goal.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            goal.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (isCompleted)
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 24)
                  else
                    _buildPriorityBadge(goal.priority),
                ],
              ),

              const SizedBox(height: 16),

              // شريط التقدم
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'progress'.tr,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        '${goal.progressPercentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: goal.progressPercentage >= 100
                              ? Colors.green
                              : Colors.blue,
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
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${goal.currentAmount.toStringAsFixed(0)}/${goal.targetAmount.toStringAsFixed(0)} ${'currency_suffix'.tr}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${goal.daysRemaining} ${'days_left'.tr}',
                        style: TextStyle(
                          fontSize: 12,
                          color: goal.daysRemaining <= 7
                              ? Colors.red
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // معلومات إضافية
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(goal.category),
                    backgroundColor: color.withOpacity(0.1),
                    labelStyle: TextStyle(color: color),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  ),
                  Text(
                    DateFormat('yyyy/MM/dd').format(goal.targetDate),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(GoalPriority priority) {
    final Map<GoalPriority, Map<String, dynamic>> priorityInfo = {
      GoalPriority.low: {'label': 'low'.tr, 'color': Colors.green},
      GoalPriority.medium: {'label': 'medium'.tr, 'color': Colors.orange},
      GoalPriority.high: {'label': 'high'.tr, 'color': Colors.red},
      GoalPriority.critical: {'label': 'critical'.tr, 'color': Colors.purple},
    };

    final info = priorityInfo[priority] ?? priorityInfo[GoalPriority.medium]!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: info['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: info['color'].withOpacity(0.3)),
      ),
      child: Text(
        info['label'],
        style: TextStyle(
          fontSize: 10,
          color: info['color'],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
