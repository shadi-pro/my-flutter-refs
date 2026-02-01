// FILE: lib/features/goals/presentation/pages/goal_stats_page.dart
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../controllers/goal_controller.dart';
import '../../../../core/models/goal_entity.dart';

class GoalStatsPage extends StatelessWidget {
  GoalStatsPage({super.key});
  final GoalController _controller = Get.find<GoalController>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('goal_statistics'.tr),
          centerTitle: true,
        ),
        body: Obx(() {
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_controller.goals.isEmpty) {
            return _buildEmptyState();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // بطاقة الإحصائيات الرئيسية
                _buildMainStatsCard(),
                const SizedBox(height: 24),

                // مخطط توزيع الأهداف حسب الفئة
                if (_controller.goals.isNotEmpty)
                  _buildCategoryDistributionChart(),
                const SizedBox(height: 24),

                // مخطط توزيع الأهداف حسب الأولوية
                if (_controller.goals.isNotEmpty)
                  _buildPriorityDistributionChart(),
                const SizedBox(height: 24),

                // جدول تحليل التقدم
                if (_controller.activeGoals.isNotEmpty)
                  _buildProgressAnalysisTable(),
                const SizedBox(height: 24),

                // نصائح وإرشادات
                _buildTipsSection(),
                const SizedBox(height: 32),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            'no_goals_for_stats'.tr,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Text(
            'add_goals_to_see_statistics'.tr,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
            label: Text('back_to_goals'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildMainStatsCard() {
    final activeGoals = _controller.activeGoals;
    final completedGoals = _controller.completedGoals;
    final upcomingDeadlines = _controller.upcomingDeadlines;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'overall_statistics'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'total_goals'.tr,
                  _controller.goals.length.toString(),
                  Icons.flag,
                  Colors.blue,
                ),
                _buildStatItem(
                  'active_goals'.tr,
                  activeGoals.length.toString(),
                  Icons.timeline,
                  Colors.green,
                ),
                _buildStatItem(
                  'completed'.tr,
                  completedGoals.length.toString(),
                  Icons.check_circle,
                  Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'total_target'.tr,
                  '${_controller.totalTargetAmount.toStringAsFixed(0)} ${'currency_suffix'.tr}',
                  Icons.flag,
                  Colors.orange,
                ),
                _buildStatItem(
                  'total_saved'.tr,
                  '${_controller.totalCurrentAmount.toStringAsFixed(0)} ${'currency_suffix'.tr}',
                  Icons.savings,
                  Colors.green,
                ),
                _buildStatItem(
                  'overall_progress'.tr,
                  '${_controller.overallProgress.toStringAsFixed(1)}%',
                  Icons.trending_up,
                  _controller.overallProgress >= 50
                      ? Colors.green
                      : Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (upcomingDeadlines.isNotEmpty) ...[
              Divider(color: Colors.grey[300]),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning, color: Colors.orange, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '${upcomingDeadlines.length} ${'upcoming_deadlines'.tr}',
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDistributionChart() {
    final categoryMap = <String, int>{};
    final categoryColors = <String, Color>{};

    for (var goal in _controller.goals) {
      categoryMap.update(
        goal.category,
        (value) => value + 1,
        ifAbsent: () => 1,
      );

      if (!categoryColors.containsKey(goal.category)) {
        categoryColors[goal.category] = GoalColors.hexToColor(goal.colorHex);
      }
    }

    if (categoryMap.isEmpty) return const SizedBox();

    final categories = categoryMap.keys.toList();
    final colors = categories.map((cat) => categoryColors[cat]!).toList();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'distribution_by_category'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: List.generate(categories.length, (i) {
                          final category = categories[i];
                          final count = categoryMap[category]!;
                          final percentage =
                              (count / _controller.goals.length * 100);

                          return PieChartSectionData(
                            color: colors[i],
                            value: percentage.toDouble(),
                            title: '${percentage.toStringAsFixed(0)}%',
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(categories.length, (i) {
                        final category = categories[i];
                        final count = categoryMap[category]!;
                        final icon =
                            GoalCategories.getIconForCategory(category);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: colors[i],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(icon, style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  category,
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '($count)',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
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

  Widget _buildPriorityDistributionChart() {
    final priorityCounts = {
      'low': 0,
      'medium': 0,
      'high': 0,
      'critical': 0,
    };

    final priorityColors = {
      'low': Colors.green,
      'medium': Colors.orange,
      'high': Colors.red,
      'critical': Colors.purple,
    };

    for (var goal in _controller.goals) {
      final priorityName = goal.priority.toString().split('.').last;
      priorityCounts[priorityName] = priorityCounts[priorityName]! + 1;
    }

    final priorities = ['critical', 'high', 'medium', 'low'];
    final data = priorities
        .where((p) => priorityCounts[p]! > 0)
        .map((priority) => priorityCounts[priority]!)
        .toList();

    final labels = priorities
        .where((p) => priorityCounts[p]! > 0)
        .map((priority) => priority.tr)
        .toList();

    final colors = priorities
        .where((p) => priorityCounts[p]! > 0)
        .map((priority) => priorityColors[priority]!)
        .toList();

    if (data.isEmpty) return const SizedBox();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'distribution_by_priority'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: data.reduce((a, b) => a > b ? a : b).toDouble() * 1.2,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.white,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${labels[groupIndex]}\n${data[groupIndex]} ${'goals'.tr}',
                          const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < labels.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                labels[index],
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  barGroups: List.generate(data.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: data[index].toDouble(),
                          color: colors[index],
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressAnalysisTable() {
    final activeGoals = _controller.activeGoals;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'progress_analysis'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                dataRowMinHeight: 40,
                columns: [
                  DataColumn(label: Text('goal'.tr)),
                  DataColumn(
                    label: Text('progress'.tr),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('days_left'.tr),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('daily_needed'.tr),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('status'.tr),
                  ),
                ],
                rows: activeGoals.map((goal) {
                  final status = _getGoalStatus(goal);
                  final statusColor = _getStatusColor(status);

                  return DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 120,
                          child: Text(
                            goal.title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          '${goal.progressPercentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: goal.progressPercentage >= 100
                                ? Colors.green
                                : Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          goal.daysRemaining.toString(),
                          style: TextStyle(
                            color: goal.daysRemaining <= 7
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          goal.requiredDailySaving.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status.tr,
                            style: TextStyle(
                              fontSize: 10,
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGoalStatus(FinancialGoal goal) {
    if (goal.isCompleted) return 'completed';

    final progress = goal.progressPercentage;
    final daysLeft = goal.daysRemaining;

    if (progress >= 100) return 'completed';
    if (progress >= 80) return 'almost_there';
    if (daysLeft <= 7 && progress < 50) return 'at_risk';
    if (daysLeft <= 14) return 'approaching_deadline';
    if (progress >= 50) return 'on_track';
    if (progress >= 30) return 'needs_attention';
    return 'just_started';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'almost_there':
        return Colors.lightGreen;
      case 'on_track':
        return Colors.blue;
      case 'needs_attention':
        return Colors.orange;
      case 'approaching_deadline':
        return Colors.orangeAccent;
      case 'at_risk':
        return Colors.red;
      case 'just_started':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Widget _buildTipsSection() {
    final activeGoals = _controller.activeGoals;

    if (activeGoals.isEmpty) return const SizedBox();

    final atRiskGoals = activeGoals.where((goal) {
      final status = _getGoalStatus(goal);
      return status == 'at_risk' || status == 'needs_attention';
    }).toList();

    final upcomingGoals =
        activeGoals.where((goal) => goal.daysRemaining <= 14).toList();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'tips_and_recommendations'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (atRiskGoals.isNotEmpty) ...[
              _buildTipItem(
                Icons.warning,
                Colors.orange,
                'at_risk_goals'.tr,
                '${atRiskGoals.length} ${'goals_need_attention'.tr}',
              ),
              const SizedBox(height: 8),
            ],
            if (upcomingGoals.isNotEmpty) ...[
              _buildTipItem(
                Icons.access_time,
                Colors.blue,
                'upcoming_deadlines'.tr,
                '${upcomingGoals.length} ${'goals_due_soon'.tr}',
              ),
              const SizedBox(height: 8),
            ],
            _buildTipItem(
              Icons.insights,
              Colors.green,
              'average_progress'.tr,
              '${_controller.overallProgress.toStringAsFixed(1)}% ${'of_all_goals'.tr}',
            ),
            const SizedBox(height: 8),
            _buildTipItem(
              Icons.savings,
              Colors.purple,
              'daily_saving_needed'.tr,
              '${_calculateAverageDailyNeeded(activeGoals).toStringAsFixed(1)} ${'currency_suffix'.tr} ${'per_day'.tr}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(
      IconData icon, Color color, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _calculateAverageDailyNeeded(List<FinancialGoal> goals) {
    if (goals.isEmpty) return 0.0;

    double totalDailyNeeded = 0.0;
    int count = 0;

    for (var goal in goals) {
      if (!goal.isCompleted && goal.daysRemaining > 0) {
        totalDailyNeeded += goal.requiredDailySaving;
        count++;
      }
    }

    return count > 0 ? totalDailyNeeded / count : 0.0;
  }
}
