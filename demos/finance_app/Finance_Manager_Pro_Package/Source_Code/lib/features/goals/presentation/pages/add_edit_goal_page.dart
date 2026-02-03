//  finance_app\lib\features\goals\presentation\pages\add_edit_goal_page.dart

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/goal_controller.dart';
import '../../../../core/models/goal_entity.dart';
import '../../../../core/utils/error_handler.dart';

class AddEditGoalPage extends StatefulWidget {
  final FinancialGoal? existingGoal;

  const AddEditGoalPage({super.key, this.existingGoal});

  @override
  State<AddEditGoalPage> createState() => _AddEditGoalPageState();
}

class _AddEditGoalPageState extends State<AddEditGoalPage> {
  final GoalController _controller = Get.find<GoalController>();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _currentAmountController = TextEditingController();

  // using  FinancialGoal.commonCategories
  late String _selectedCategory;
  GoalPriority _selectedPriority = GoalPriority.medium;
  String _selectedColor = GoalColors.availableColors.first;
  DateTime _startDate = DateTime.now();
  DateTime _targetDate = DateTime.now().add(const Duration(days: 30));

  bool get _isEditing => widget.existingGoal != null;

  @override
  void initState() {
    super.initState();

    if (_isEditing) {
      _loadExistingGoalData();
    } else {
      _currentAmountController.text = '0';
      // using FinancialGoal.commonCategories
      _selectedCategory = FinancialGoal.commonCategories.first;
    }
  }

  void _loadExistingGoalData() {
    final goal = widget.existingGoal!;
    _titleController.text = goal.title;
    _descriptionController.text = goal.description;
    _targetAmountController.text = goal.targetAmount.toStringAsFixed(2);
    _currentAmountController.text = goal.currentAmount.toStringAsFixed(2);

    //  Converting stored key into tranlsated category using   FinancialGoal
    _selectedCategory = FinancialGoal.getTranslatedCategory(goal.category);

    _selectedPriority = goal.priority;
    _selectedColor = goal.colorHex;
    _startDate = goal.startDate;
    _targetDate = goal.targetDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetAmountController.dispose();
    _currentAmountController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _targetDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: Get.locale,
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // إذا كان تاريخ البدء بعد تاريخ الهدف، نحدّث تاريخ الهدف
          if (_targetDate.isBefore(_startDate)) {
            _targetDate = _startDate.add(const Duration(days: 30));
          }
        } else {
          _targetDate = picked;
          // إذا كان تاريخ الهدف قبل تاريخ البدء، نحدّث تاريخ البدء
          if (_targetDate.isBefore(_startDate)) {
            _startDate = _targetDate.subtract(const Duration(days: 30));
          }
        }
      });
    }
  }

  void _saveGoal() {
    if (!_formKey.currentState!.validate()) return;

    try {
      final targetAmount = double.parse(_targetAmountController.text);
      final currentAmount = double.parse(_currentAmountController.text);

      if (targetAmount <= 0) {
        throw Exception('targetAmountMustBePositive'.tr);
      }

      if (currentAmount < 0) {
        throw Exception('currentAmountCannotBeNegative'.tr);
      }

      if (currentAmount > targetAmount) {
        throw Exception('currentAmountCannotExceedTarget'.tr);
      }

      if (_targetDate.isBefore(_startDate)) {
        throw Exception('targetDateCannotBeBeforeStart'.tr);
      }

      // Converting  tranlsated cactegory inot a stored key  usign  FinancialGoal
      final categoryKey = FinancialGoal.getCategoryKey(_selectedCategory);

      final goal = FinancialGoal(
        id: widget.existingGoal?.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        targetAmount: targetAmount,
        currentAmount: currentAmount,
        startDate: _startDate,
        targetDate: _targetDate,
        category: categoryKey,
        priority: _selectedPriority,
        colorHex: _selectedColor,
      );

      if (_isEditing) {
        _controller.updateGoal(goal.id, goal);
      } else {
        _controller.addGoal(goal);
      }

      Get.back();
    } catch (e) {
      ErrorHandler.showError('${'goalSaveError'.tr}: ${e.toString()}');
    }
  }

  void _showDeleteConfirmation() {
    if (!_isEditing) return;

    Get.defaultDialog(
      title: 'confirm_delete_goal'.tr,
      middleText: 'delete_goal_question'.tr,
      textConfirm: 'delete'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Colors.white,
      onConfirm: () {
        _controller.deleteGoal(widget.existingGoal!.id);
        Get.back();
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'editGoal'.tr : 'addNewGoal'.tr),
          centerTitle: true,
          actions: _isEditing
              ? [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: _showDeleteConfirmation,
                    tooltip: 'deleteGoal'.tr,
                  ),
                ]
              : null,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // goalTitle
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'goalTitle'.tr,
                    prefixIcon: const Icon(Icons.flag),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'enterGoalTitle'.tr;
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                //  Goal description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'goalDescription'.tr,
                    border: const OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // Target Amount
                TextFormField(
                  controller: _targetAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'targetAmount'.tr,
                    prefixIcon: const Icon(Icons.attach_money),
                    suffixText: 'currencySymbol'.tr,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enterTargetAmount'.tr;
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'enterValidAmount'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Current Amount
                TextFormField(
                  controller: _currentAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'currentAmount'.tr,
                    prefixIcon: const Icon(Icons.savings),
                    suffixText: 'currencySymbol'.tr,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enterCurrentAmount'.tr;
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount < 0) {
                      return 'enterValidAmount'.tr;
                    }

                    // Checking if the current amount exceed the target amount
                    final target =
                        double.tryParse(_targetAmountController.text);
                    if (target != null && amount > target) {
                      return 'currentCannotExceedTarget'.tr;
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // startDate
                _buildDatePicker(
                  label: 'startDate'.tr,
                  date: _startDate,
                  onTap: () => _selectDate(context, true),
                ),
                const SizedBox(height: 16),

                // targetDate
                _buildDatePicker(
                  label: 'targetDate'.tr,
                  date: _targetDate,
                  onTap: () => _selectDate(context, false),
                ),
                const SizedBox(height: 16),

                // using  FinancialGoal.commonCategories
                _buildDropdown<String>(
                  label: 'selectCategory'.tr,
                  value: _selectedCategory,
                  items: FinancialGoal.commonCategories,
                  onChanged: (value) {
                    setState(() => _selectedCategory = value!);
                  },
                  icon: Icons.category,
                ),
                const SizedBox(height: 16),

                // Priority
                _buildDropdown<GoalPriority>(
                  label: 'priority'.tr,
                  value: _selectedPriority,
                  items: GoalPriority.values,
                  onChanged: (value) {
                    setState(() => _selectedPriority = value!);
                  },
                  icon: Icons.priority_high,
                  displayText: (priority) {
                    return FinancialGoal.priorityToString(priority);
                  },
                ),
                const SizedBox(height: 16),

                // color
                _buildColorSelector(),
                const SizedBox(height: 24),

                //  update/save/edit Goal buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveGoal,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child:
                            Text(_isEditing ? 'updateGoal'.tr : 'saveGoal'.tr),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text('cancel'.tr),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                Text(
                  _formatDate(date),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.calendar_today, color: Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required IconData icon,
    String Function(T)? displayText,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            displayText != null ? displayText(item) : item.toString(),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'selectColor'.tr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: GoalColors.availableColors.map((colorHex) {
            final isSelected = _selectedColor == colorHex;
            final color = GoalColors.hexToColor(colorHex);

            return GestureDetector(
              onTap: () {
                setState(() => _selectedColor = colorHex);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.black, width: 3)
                      : Border.all(color: Colors.grey[300]!, width: 1),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                  ],
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
