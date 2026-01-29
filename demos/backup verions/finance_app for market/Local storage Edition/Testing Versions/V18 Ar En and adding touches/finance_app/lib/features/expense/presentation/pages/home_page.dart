// finance_app\lib\features\expense\presentation\pages\home_page.dart

import 'dart:ui' as ui;
import 'package:finance_app/core/models/enums.dart';
import 'package:finance_app/features/alerts/presentation/pages/alerts_settings_page.dart';
import 'package:finance_app/features/backup/presentation/pages/backup_page.dart';
import 'package:finance_app/features/expense/domain/entities/expense_entity.dart';
import 'package:finance_app/features/expense/presentation/pages/budget_page.dart';
import 'package:finance_app/features/expense/presentation/pages/edit_expense_page.dart';
import 'package:finance_app/features/expense/presentation/pages/reports_page.dart';
import 'package:finance_app/features/search/presentation/controllers/expense_search_controller.dart';
import 'package:finance_app/features/search/presentation/pages/filter_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/expense_controller.dart';
import 'add_expense_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ExpenseController controller = Get.find();
  final ExpenseSearchController searchController =
      Get.find<ExpenseSearchController>(tag: ExpenseSearchController.TAG);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('app_title'.tr), // ✅ localized
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                Get.defaultDialog(
                  title: 'clear_all_data'.tr,
                  middleText: 'confirm_clear_all'.tr,
                  textConfirm: 'yes'.tr,
                  textCancel: 'no'.tr,
                  confirmTextColor: Colors.white,
                  onConfirm: () {
                    controller.clearAllData();
                    searchController.resetFilters();
                    Get.back();
                  },
                );
              },
              tooltip: 'clear_all_data'.tr,
            ),
            IconButton(
              icon: const Icon(Icons.bar_chart),
              onPressed: () {
                Get.to(() => ReportsPage());
              },
              tooltip: 'reports'.tr,
            ),
            IconButton(
              icon: const Icon(Icons.account_balance_wallet),
              onPressed: () {
                Get.to(() => BudgetPage());
              },
              tooltip: 'budget'.tr,
            ),
            IconButton(
              icon: const Icon(Icons.notification_add),
              onPressed: () {
                Get.to(() => AlertsSettingsPage());
              },
              tooltip: 'alerts'.tr,
            ),
            IconButton(
              icon: const Icon(Icons.backup),
              onPressed: () {
                Get.to(() => BackupPage());
              },
              tooltip: 'backup'.tr,
            ),
            IconButton(
              icon: Icon(
                Get.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Get.isDarkMode ? Colors.yellow[300] : Colors.grey[700],
              ),
              onPressed: () {
                Get.changeThemeMode(
                    Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
              },
              tooltip: Get.isDarkMode ? 'light_mode'.tr : 'dark_mode'.tr,
            ),
            IconButton(
              icon: const Icon(Icons.language),
              tooltip: 'language'.tr,
              onPressed: () {
                if (Get.locale?.languageCode == 'ar') {
                  Get.updateLocale(const Locale('en'));
                } else {
                  Get.updateLocale(const Locale('ar'));
                }
              },
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // شريط البحث
              _buildSearchBar(),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // بطاقة الملخص
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                'balance'.tr,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${controller.balance.value.toStringAsFixed(2)} ${'currency_suffix'.tr}',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: controller.balance.value >= 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      const Icon(Icons.arrow_downward,
                                          color: Colors.green),
                                      const SizedBox(height: 4),
                                      Text(
                                        'income'.tr,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        controller.totalIncome.value
                                            .toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Icon(Icons.arrow_upward,
                                          color: Colors.red),
                                      const SizedBox(height: 4),
                                      Text(
                                        'expense'.tr,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        controller.totalExpense.value
                                            .toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // عنوان قسم المعاملات مع عداد النتائج
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() {
                            final filteredExpenses =
                                searchController.filteredExpenses;

                            final totalExpenses = controller.expenses.length;

                            if (searchController.searchQuery.value.isNotEmpty ||
                                searchController.selectedCategory.value !=
                                    'all'.tr ||
                                searchController.selectedType.value !=
                                    'all'.tr) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'search_results'.tr,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${filteredExpenses.length} ${'of'.tr} ${totalExpenses} ${'transactions'.tr}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              );
                            }

                            return Text(
                              'recent_transactions'.tr,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }),
                          Row(
                            children: [
                              if (searchController
                                      .searchQuery.value.isNotEmpty ||
                                  searchController.selectedCategory.value !=
                                      'all'.tr ||
                                  searchController.selectedType.value !=
                                      'all'.tr)
                                IconButton(
                                  icon: const Icon(Icons.clear, size: 20),
                                  onPressed: () {
                                    searchController.resetFilters();
                                  },
                                  tooltip: 'clear_filters'.tr,
                                ),
                              TextButton(
                                onPressed: () {
                                  Get.to(() => FilterPage());
                                },
                                child: Text('filter'.tr),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // قائمة المعاملات (مع البحث)
                      Expanded(
                        child: Obx(() {
                          final filteredExpenses =
                              searchController.filteredExpenses;

                          if (filteredExpenses.isEmpty) {
                            if (controller.expenses.isEmpty) {
                              return _buildEmptyState();
                            } else if (searchController
                                    .searchQuery.value.isNotEmpty ||
                                searchController.selectedCategory.value !=
                                    'all'.tr ||
                                searchController.selectedType.value !=
                                    'all'.tr) {
                              return _buildNoResultsState();
                            }
                            return _buildEmptyState();
                          }

                          return ListView.builder(
                            itemCount: filteredExpenses.length,
                            itemBuilder: (context, index) {
                              final expense = filteredExpenses[index];

                              // ✅ البحث عن الأصلية باستخدام id
                              final originalIndex = controller.expenses
                                  .indexWhere((e) => e.id == expense['id']);

                              return _buildExpenseItem(expense, originalIndex);
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),

        // زر الإضافة الجديد
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Get.to(() => const AddExpensePage());
          },
          icon: const Icon(Icons.add),
          label: Text('add_new'.tr),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Get.isDarkMode ? Colors.grey[900] : Colors.grey[50],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: TextEditingController(
                text: searchController.searchQuery.value,
              ),
              decoration: InputDecoration(
                hintText: 'search_transactions'.tr,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          searchController.searchQuery.value = '';
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Get.isDarkMode ? Colors.grey[800] : Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                hintStyle: TextStyle(
                  color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
              onChanged: (value) {
                searchController.searchQuery.value = value;
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              Get.to(() => FilterPage());
            },
            tooltip: 'advanced_filter'.tr,
            style: IconButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'no_transactions'.tr,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'start_first_transaction'.tr,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'no_search_results'.tr,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            searchController.searchQuery.value.isNotEmpty
                ? '${'search'.tr}: "${searchController.searchQuery.value}"'
                : 'applied_filters'.tr,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              searchController.resetFilters();
            },
            child: Text('clear_all_filters'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(dynamic expense, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: expense['isIncome']
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
            child: Icon(
              expense['isIncome'] ? Icons.download : Icons.upload,
              color: expense['isIncome'] ? Colors.green : Colors.red,
            ),
          ),
          title: Text(
            expense['category'],
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (expense['description'].toString().isNotEmpty)
                Text(expense['description'].toString(),
                    style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 2),
              Text(
                _formatDate(expense['date']),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${expense['amount']} ${'currency_suffix'.tr}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: expense['isIncome'] ? Colors.green : Colors.red,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 20),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(Icons.edit, size: 18, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text('edit'.tr),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete, size: 18, color: Colors.red),
                        const SizedBox(width: 8),
                        Text('delete'.tr),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'duplicate',
                    child: Row(
                      children: [
                        const Icon(Icons.content_copy,
                            size: 18, color: Colors.purple),
                        const SizedBox(width: 8),
                        Text('duplicate'.tr),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  _handleExpenseAction(value, index, expense);
                },
              ),
            ],
          ),
          onTap: () {
            _showExpenseDetails(expense, index);
          },
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('yyyy/MM/dd', Get.locale?.languageCode ?? 'en')
          .format(date);
    } catch (e) {
      return dateString;
    }
  }

  void _showExpenseDetails(dynamic expense, int index) {
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
              'transaction_details'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('${'amount'.tr}:',
                '${expense['amount']} ${'currency_suffix'.tr}'),
            _buildDetailRow('${'type'.tr}:',
                expense['isIncome'] ? 'income'.tr : 'expense'.tr),
            _buildDetailRow('${'category'.tr}:', expense['category']),
            if (expense['description'].toString().isNotEmpty)
              _buildDetailRow(
                  '${'description'.tr}:', expense['description'].toString()),
            _buildDetailRow('${'date'.tr}:', _formatDate(expense['date'])),
            _buildDetailRow('${'payment_method'.tr}:',
                expense['paymentMethod'] ?? 'cash'.tr),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: Text('close'.tr),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.defaultDialog(
                        title: 'confirm_delete'.tr,
                        middleText: 'delete_transaction_question'.tr,
                        textConfirm: 'delete'.tr,
                        textCancel: 'cancel'.tr,
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          if (index >= 0 &&
                              index < controller.expenses.length) {
                            controller.deleteExpense(index);
                            searchController.resetFilters();
                            Get.back();
                          } else {
                            Get.snackbar(
                              'error'.tr,
                              'transaction_not_found'.tr,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text('delete'.tr),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleExpenseAction(String action, int index, dynamic expense) {
    switch (action) {
      case 'edit':
        _editExpense(index, expense);
        break;
      case 'delete':
        _deleteExpense(index);
        break;
      case 'duplicate':
        _duplicateExpense(expense);
        break;
    }
  }

  void _editExpense(int index, dynamic expense) {
    Get.to(() => EditExpensePage(
          expenseIndex: index,
          expenseData: expense,
        ));
  }

  void _deleteExpense(int index) {
    Get.defaultDialog(
      title: 'confirm_delete'.tr,
      middleText: 'delete_transaction_question'.tr,
      textConfirm: 'delete'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (index >= 0 && index < controller.expenses.length) {
          controller.deleteExpense(index);
          searchController.resetFilters();
          Get.back();
          Get.snackbar(
            'deleted'.tr,
            'transaction_deleted_success'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green[100],
            colorText: Colors.green[900],
          );
        }
      },
    );
  }

  void _duplicateExpense(dynamic expense) {
    try {
      final newExpense = ExpenseEntity(
        amount: (expense['amount'] as num).toDouble(),
        category: ExpenseCategory.fromString(expense['category']),
        description: expense['description']?.toString() ?? '',
        date: DateTime.now(),
        isIncome: expense['isIncome'] == true,
        paymentMethod: PaymentMethod.fromString(
          expense['paymentMethod']?.toString() ?? 'cash'.tr,
        ),
      );

      controller.addExpense(newExpense);

      Get.snackbar(
        'duplicated'.tr,
        'transaction_duplicated_success'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue[100],
        colorText: Colors.blue[900],
      );
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'duplicate_failed'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
