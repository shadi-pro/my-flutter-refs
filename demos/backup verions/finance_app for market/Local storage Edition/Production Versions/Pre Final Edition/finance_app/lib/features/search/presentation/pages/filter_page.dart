// lib/features/search/presentation/pages/filter_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/expense_search_controller.dart';
import '../../../expense/presentation/controllers/expense_controller.dart';
import '../../../../core/models/enums.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final ExpenseSearchController searchController =
      Get.find<ExpenseSearchController>(tag: ExpenseSearchController.TAG);
  final ExpenseController expenseController = Get.find<ExpenseController>();

  String? _selectedCategory;
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedCategory = searchController.selectedCategory.value;
    _selectedType = searchController.selectedType.value;
  }

  @override
  Widget build(BuildContext context) {
    final uniqueCategories = _getUniqueCategories();
    final categories = ['all'.tr, ...uniqueCategories];
    final types = ['all'.tr, 'income'.tr, 'expense'.tr];

    return Scaffold(
      appBar: AppBar(
        title: Text('filter_transactions'.tr),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              searchController.resetFilters();
              setState(() {
                _selectedCategory = 'all'.tr;
                _selectedType = 'all'.tr;
              });
              Get.back();
            },
            child: Text('reset_all'.tr),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchSection(),
            const SizedBox(height: 24),
            _buildFilterSection(
              'category'.tr,
              Icons.category,
              categories,
              _selectedCategory ?? 'all'.tr,
              (value) {
                setState(() {
                  _selectedCategory = value;
                });
                searchController.selectedCategory.value = value;
              },
            ),
            const SizedBox(height: 24),
            _buildFilterSection(
              'type'.tr,
              Icons.swap_vert,
              types,
              _selectedType ?? 'all'.tr,
              (value) {
                setState(() {
                  _selectedType = value;
                });
                searchController.selectedType.value = value;
              },
            ),
            const SizedBox(height: 24),
            _buildAmountRangeSection(),
            const SizedBox(height: 32),
            _buildResultsStats(),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.search, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'search'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: TextEditingController(
                text: searchController.searchQuery.value,
              ),
              decoration: InputDecoration(
                hintText: 'filter_search_hint'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Get.isDarkMode ? Colors.grey[800] : Colors.grey[50],
              ),
              onChanged: (value) {
                searchController.searchQuery.value = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    IconData icon,
    List<String> options,
    String selectedValue,
    Function(String) onSelected,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options.map((option) {
                return ChoiceChip(
                  label: Text(option),
                  selected: selectedValue == option,
                  onSelected: (isSelected) {
                    if (isSelected) {
                      onSelected(option);
                    }
                  },
                  selectedColor: Colors.blue.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: selectedValue == option
                        ? Colors.blue
                        : Get.isDarkMode
                            ? Colors.white
                            : Colors.black,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRangeSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'filter_amount_range'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${'min'.tr}: ${searchController.minAmount.value.toInt()} ${'currency_suffix'.tr}',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${'max'.tr}: ${searchController.maxAmount.value.toInt()} ${'currency_suffix'.tr}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            RangeSlider(
              values: RangeValues(
                searchController.minAmount.value.clamp(0.0, 10000.0),
                searchController.maxAmount.value.clamp(0.0, 10000.0),
              ),
              min: 0,
              max: 10000,
              divisions: 100,
              onChanged: (values) {
                setState(() {
                  searchController.minAmount.value = values.start;
                  searchController.maxAmount.value = values.end;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsStats() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'search_results'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final filteredCount = searchController.filteredExpenses.length;
              final totalCount = expenseController.expenses.length;

              return Column(
                children: [
                  Text(
                    'found'.trParams({
                      'filtered': filteredCount.toString(),
                      'total': totalCount.toString()
                    }),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: totalCount > 0 ? filteredCount / totalCount : 0,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      filteredCount > 0 ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('apply_filters'.tr),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () {
              searchController.resetFilters();
              setState(() {
                _selectedCategory = 'all'.tr;
                _selectedType = 'all'.tr;
              });
              Get.back();
            },
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('clear_all_filters'.tr),
          ),
        ),
      ],
    );
  }

  // Getting unique categories
  List<String> _getUniqueCategories() {
    final categories = <String>{};
    for (var expense in expenseController.expenses) {
      categories.add(expense.category.translationKey.tr);
    }
    return categories.toList()..sort();
  }
}
