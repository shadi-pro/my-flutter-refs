//  lib/features/goals/presentation/controllers/goal_controller.dart

import 'package:get/get.dart';
import 'package:finance_app/core/models/goal_entity.dart';
import 'package:finance_app/core/security/simple_encryption.dart';
import 'package:finance_app/core/utils/error_handler.dart';

class GoalController extends GetxController {
  final goals = <FinancialGoal>[].obs;
  final isLoading = false.obs;
  final selectedGoal = Rx<FinancialGoal?>(null);

  @override
  void onInit() {
    super.onInit();
    loadGoals();
  }

  // Load Goals from storage
  Future<void> loadGoals() async {
    isLoading.value = true;
    try {
      final storedData = SimpleEncryption.read('financial_goals');

      if (storedData == null || storedData is! List) {
        goals.value = [];
        return;
      }

      final loadedGoals = <FinancialGoal>[];

      for (var item in storedData) {
        try {
          if (item is Map<String, dynamic>) {
            final goal = FinancialGoal.fromMap(item);
            loadedGoals.add(goal);
          }
        } catch (e) {
          // Silent fail for individual items
        }
      }

      goals.value = loadedGoals;
    } catch (e) {
      ErrorHandler.showError('${'loadDataError'.tr}: ${'financial_goals'.tr}');
      goals.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // Saving Goals to storage
  Future<void> _saveGoals() async {
    try {
      final data = goals.map((goal) => goal.toMap()).toList();
      await SimpleEncryption.write('financial_goals', data);
    } catch (e) {
      ErrorHandler.showError('save_goal_error'.trParams({'e': e.toString()}));
      rethrow;
    }
  }

  // Add new Goal
  Future<void> addGoal(FinancialGoal goal) async {
    try {
      if (goal.targetAmount <= 0) {
        throw Exception('validation_target_amount_positive'.tr);
      }

      if (goal.targetDate.isBefore(DateTime.now())) {
        throw Exception('future_date'.tr);
      }

      goals.add(goal);
      await _saveGoals();

      ErrorHandler.showSuccess('goal_saved_success'.tr);
    } catch (e) {
      ErrorHandler.showError('add_goal_failed'.trParams({'e': e.toString()}));
      rethrow;
    }
  }

  // Update existing Goal
  Future<void> updateGoal(String goalId, FinancialGoal updatedGoal) async {
    try {
      final index = goals.indexWhere((goal) => goal.id == goalId);
      if (index == -1) {
        throw Exception('not_existed_goal'.tr);
      }

      goals[index] = updatedGoal;
      await _saveGoals();

      ErrorHandler.showSuccess('goal_updated_success'.tr);
    } catch (e) {
      ErrorHandler.showError(
          'update_goal_failed'.trParams({'e': e.toString()}));
      rethrow;
    }
  }

  // Delete Goal
  Future<void> deleteGoal(String goalId) async {
    try {
      final index = goals.indexWhere((goal) => goal.id == goalId);
      if (index == -1) {
        throw Exception('not_existed_goal'.tr);
      }

      final deletedGoal = goals[index];
      goals.removeAt(index);
      await _saveGoals();

      ErrorHandler.showSuccess('goal_deleted_success'.tr);
    } catch (e) {
      ErrorHandler.showError(
          'delete_goal_failed'.trParams({'e': e.toString()}));
      rethrow;
    }
  }

  // Add contribution to goal
  Future<void> addContribution(
      String goalId, double amount, String note) async {
    try {
      final index = goals.indexWhere((goal) => goal.id == goalId);
      if (index == -1) {
        throw Exception('not_existed_goal'.tr);
      }

      if (amount <= 0) {
        throw Exception('invalidAmount'.tr);
      }

      final goal = goals[index];
      goal.addContribution(amount, note, DateTime.now());

      // Check if goal is completed
      if (goal.currentAmount >= goal.targetAmount && !goal.isCompleted) {
        goals[index] = goal.copyWith(isCompleted: true);

        ErrorHandler.showSuccess(
            'goal_achieved'.trParams({'title': goal.title}));
      } else {
        goals[index] = goal;
      }

      await _saveGoals();

      ErrorHandler.showSuccess('success_Contribution_added'.tr);
    } catch (e) {
      ErrorHandler.showError(
          'add_contribution_failed'.trParams({'e': e.toString()}));
      rethrow;
    }
  }

  // Get goal by ID
  FinancialGoal? getGoalById(String goalId) {
    try {
      return goals.firstWhere((goal) => goal.id == goalId);
    } catch (e) {
      return null;
    }
  }

  // Active Goals (not completed yet  )
  List<FinancialGoal> get activeGoals {
    return goals.where((goal) => !goal.isCompleted).toList();
  }

  // Completed Goals
  List<FinancialGoal> get completedGoals {
    return goals.where((goal) => goal.isCompleted).toList();
  }

  // Goals about to finish (less than 7 days)
  List<FinancialGoal> get upcomingDeadlines {
    return activeGoals.where((goal) => goal.daysRemaining <= 7).toList();
  }

  // Total target amount for active goals
  double get totalTargetAmount {
    return activeGoals.fold(0.0, (sum, goal) => sum + goal.targetAmount);
  }

  // Total current savings for active goals
  double get totalCurrentAmount {
    return activeGoals.fold(0.0, (sum, goal) => sum + goal.currentAmount);
  }

  // Overall progress percentage
  double get overallProgress {
    if (totalTargetAmount == 0) return 0.0;
    return (totalCurrentAmount / totalTargetAmount * 100).clamp(0.0, 100.0);
  }

  // Get goals by category
  Map<String, List<FinancialGoal>> getGoalsByCategory() {
    final Map<String, List<FinancialGoal>> categoryMap = {};

    for (var goal in goals) {
      categoryMap.putIfAbsent(goal.category, () => []);
      categoryMap[goal.category]!.add(goal);
    }

    return categoryMap;
  }

  // Get goals by priority
  Map<GoalPriority, List<FinancialGoal>> getGoalsByPriority() {
    final Map<GoalPriority, List<FinancialGoal>> priorityMap = {};

    for (var goal in goals) {
      priorityMap.putIfAbsent(goal.priority, () => []);
      priorityMap[goal.priority]!.add(goal);
    }

    return priorityMap;
  }

  // Sort goals by priority
  void sortGoalsByPriority() {
    final priorityOrder = {
      GoalPriority.critical: 0,
      GoalPriority.high: 1,
      GoalPriority.medium: 2,
      GoalPriority.low: 3,
    };

    goals.sort((a, b) {
      final priorityA = priorityOrder[a.priority] ?? 3;
      final priorityB = priorityOrder[b.priority] ?? 3;

      if (priorityA != priorityB) {
        return priorityA.compareTo(priorityB);
      }

      // Sort by date if same priority
      return a.targetDate.compareTo(b.targetDate);
    });
  }

  // Simulate regular payment (future feature - Recurring Bills)
  Future<void> simulateRegularPayment(
      String goalId, double monthlyAmount) async {
    // This method will be used in future [Recurring Bills]

    final month = DateTime.now().month;
    final year = DateTime.now().year;
    await addContribution(
        goalId,
        monthlyAmount,
        'monthly_payment'
            .trParams({'month': month.toString(), 'year': year.toString()}));
  }
}
