// finance_app\lib\features\expense\presentation\pages\home_page.dart

import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/core/models/enums.dart';
import 'package:finance_app/features/alerts/presentation/pages/alerts_settings_page.dart';
import 'package:finance_app/features/backup/presentation/pages/backup_page.dart';
import 'package:finance_app/features/expense/domain/entities/expense_entity.dart';
import 'package:finance_app/features/expense/presentation/pages/budget_page.dart';
import 'package:finance_app/features/expense/presentation/pages/edit_expense_page.dart';
import 'package:finance_app/features/expense/presentation/pages/reports_page.dart';
import 'package:finance_app/features/goals/presentation/pages/goals_list_page.dart';
import 'package:finance_app/features/search/presentation/controllers/expense_search_controller.dart';
import 'package:finance_app/features/search/presentation/pages/filter_page.dart';
import 'package:intl/intl.dart';

import '../controllers/expense_controller.dart';
import 'add_expense_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ExpenseController controller = Get.find();
  final ExpenseSearchController searchController =
      Get.find<ExpenseSearchController>(tag: ExpenseSearchController.TAG);

  // Helper method to check if text is Arabic
  bool _isArabicText(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }

  // Convert Arabic category to translation key
  String _convertArabicToCategoryKey(String arabic) {
    final Map<String, String> arabicToKey = {
      'طعام': 'food',
      'مواصلات': 'transportation',
      'تسوق': 'marketing',
      'ترفيه': 'entertainment',
      'صحة': 'health',
      'تعليم': 'learn',
      'سكن': 'living',
      'فواتير': 'bills',
      'مرتب': 'salary',
      'استثمار': 'investment',
      'هدايا': 'gifts',
      'أخرى': 'others',
    };
    return arabicToKey[arabic] ?? 'others';
  }

  // Convert Arabic payment method to translation key
  String _convertArabicToPaymentKey(String arabic) {
    final Map<String, String> arabicToKey = {
      'نقدي': 'cash',
      'بطاقة ائتمان': 'credit_card',
      'تحويل بنكي': 'bank_transfer',
      'محفظة إلكترونية': 'e_wallet',
      'شيك': 'cheque',
    };
    return arabicToKey[arabic] ?? 'cash';
  }

  // Get translated category name (handles both old Arabic and new key data)
  String _getTranslatedCategory(String categoryFromData) {
    if (_isArabicText(categoryFromData)) {
      // Old data: Arabic text -> convert to key -> translate
      final key = _convertArabicToCategoryKey(categoryFromData);
      return key.tr;
    } else {
      // New data: already a key -> translate directly
      return categoryFromData.tr;
    }
  }

  // Get translated payment method name
  String _getTranslatedPaymentMethod(String paymentFromData) {
    if (_isArabicText(paymentFromData)) {
      final key = _convertArabicToPaymentKey(paymentFromData);
      return key.tr;
    } else {
      return paymentFromData.tr;
    }
  }

  void _handleMoreOptions(String value) {
    switch (value) {
      case 'goals':
        Get.to(() => GoalsListPage());
        break;

      case 'budget':
        Get.to(() => BudgetPage());
        break;

      case 'alerts':
        Get.to(() => AlertsSettingsPage());
        break;

      case 'backup':
        Get.to(() => BackupPage());
        break;

      case 'clear_data':
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
        break;

      case 'theme': // theme Switching
        Get.changeThemeMode(
          Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
        );
        Get.snackbar(
          Get.isDarkMode ? 'light_mode'.tr : 'dark_mode'.tr,
          'theme_changed'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        break;

      case 'language': // language Switching
        final isArabic = Get.locale?.languageCode == 'ar';
        Get.updateLocale(isArabic ? const Locale('en') : const Locale('ar'));
        Get.snackbar(
          isArabic ? 'English' : 'العربية',
          'language_changed'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('app_title'.tr),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.bar_chart, size: 22),
              onPressed: () {
                Get.to(() => ReportsPage());
              },
              tooltip: 'reports'.tr,
              padding: const EdgeInsets.all(4),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 22),
              tooltip: 'more_options'.tr,
              padding: const EdgeInsets.all(4),
              onSelected: (value) {
                _handleMoreOptions(value);
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'goals',
                  child: Row(
                    children: [
                      const Icon(Icons.flag, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Text('financial_goals'.tr),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'budget',
                  child: Row(
                    children: [
                      const Icon(Icons.account_balance_wallet,
                          color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Text('budget'.tr),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'alerts',
                  child: Row(
                    children: [
                      const Icon(Icons.notifications,
                          color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      Text('alerts'.tr),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'backup',
                  child: Row(
                    children: [
                      const Icon(Icons.backup, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Text('backup'.tr),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'clear_data',
                  child: Row(
                    children: [
                      const Icon(Icons.delete_outline,
                          color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Text('clear_all_data'.tr),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'theme',
                  child: Row(
                    children: [
                      Icon(
                        Get.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: Get.isDarkMode ? Colors.yellow : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(Get.isDarkMode ? 'light_mode'.tr : 'dark_mode'.tr),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'language',
                  child: Row(
                    children: [
                      const Icon(Icons.language,
                          color: Colors.purple, size: 20),
                      const SizedBox(width: 8),
                      Text('language'.tr),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary card
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

                      // Transactions Section Title + results count
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

                      // Virtual Scrolling + Pull-to-Refresh
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

                          // Virtual Scrolling: display 100 items max
                          final displayExpenses =
                              filteredExpenses.take(100).toList();
                          final hasMoreTransactions =
                              filteredExpenses.length > 100;

                          return RefreshIndicator(
                            onRefresh: () async {
                              // Pull-to-Refresh: Reload data
                              await controller.loadExpenses();
                              searchController.invalidateCache();

                              // Success message
                              Get.snackbar(
                                'refreshed'.tr,
                                'data_refreshed_success'.tr,
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.green[100],
                                colorText: Colors.green[900],
                              );
                            },
                            child: ListView.builder(
                              itemCount: displayExpenses.length +
                                  (hasMoreTransactions ? 1 : 0),
                              itemBuilder: (context, index) {
                                // Display more button [if there are more]
                                if (hasMoreTransactions &&
                                    index == displayExpenses.length) {
                                  return _buildShowAllButton(
                                      filteredExpenses.length);
                                }

                                final expense = displayExpenses[index];

                                // Search for the index using id
                                final originalIndex = controller.expenses
                                    .indexWhere((e) => e.id == expense['id']);

                                // Adding dismissible for swipe to remove
                                return _buildExpenseItemWithSwipe(
                                    expense, originalIndex);
                              },
                            ),
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

        // Add new button
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
        ));
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
    ));
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

  // Show all button for additional transactions
  Widget _buildShowAllButton(int totalTransactions) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: OutlinedButton.icon(
        onPressed: () {
          // Show all transactions in separate page or expand list
          Get.defaultDialog(
            title: 'all_transactions'.tr,
            content: SizedBox(
              width: double.maxFinite,
              child: Text(
                '${'showing'.tr} 100 ${'of'.tr} $totalTransactions ${'transactions'.tr}\n${'consider_search_filter'.tr}',
                textAlign: TextAlign.center,
              ),
            ),
            textConfirm: 'ok'.tr,
            onConfirm: Get.back,
          );
        },
        icon: const Icon(Icons.unfold_more, size: 18),
        label: Text(
          '${'show_all'.tr} ($totalTransactions)',
          style: const TextStyle(fontSize: 14),
        ),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Handling Swipe to Delete process
  Widget _buildExpenseItemWithSwipe(dynamic expense, int index) {
    return Dismissible(
      key: Key(expense['id'] ?? UniqueKey().toString()),
      direction: DismissDirection.endToStart,
      background: _buildDismissibleBackground(),
      secondaryBackground: _buildDismissibleBackground(),
      confirmDismiss: (direction) async {
        return await _confirmDelete(index);
      },
      onDismissed: (direction) {
        if (index >= 0 && index < controller.expenses.length) {
          controller.deleteExpense(index);
          searchController.resetFilters();
          Get.snackbar(
            'deleted'.tr,
            'transaction_deleted_success'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green[100],
            colorText: Colors.green[900],
          );
        }
      },
      child: _buildExpenseItem(expense,
          index), // Calling the basic build function after swipe removing
    );
  }

  // Building Swipe removing background
  Widget _buildDismissibleBackground() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(Icons.delete, color: Colors.white, size: 24),
          const SizedBox(width: 8),
          Text(
            'delete'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  // Delete confirmation function
  Future<bool> _confirmDelete(int index) async {
    final result = await Get.defaultDialog<bool>(
      title: 'confirm_delete'.tr,
      middleText: 'delete_transaction_question'.tr,
      textConfirm: 'delete'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );
    return result ?? false;
  }

  // Basic function for building transaction item
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
            _getTranslatedCategory(expense['category']),
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
            _buildDetailRow('${'category'.tr}:',
                _getTranslatedCategory(expense['category'])),
            if (expense['description'].toString().isNotEmpty)
              _buildDetailRow(
                  '${'description'.tr}:', expense['description'].toString()),
            _buildDetailRow('${'date'.tr}:', _formatDate(expense['date'])),
            _buildDetailRow(
                '${'payment_method'.tr}:',
                _getTranslatedPaymentMethod(
                    expense['paymentMethod'] ?? 'cash')),
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
      // Handle both old (Arabic) and new (key) data for duplication
      String categoryKey;
      if (_isArabicText(expense['category'])) {
        categoryKey = _convertArabicToCategoryKey(expense['category']);
      } else {
        categoryKey = expense['category'];
      }

      String paymentKey;
      if (_isArabicText(expense['paymentMethod'] ?? 'cash')) {
        paymentKey =
            _convertArabicToPaymentKey(expense['paymentMethod'] ?? 'cash');
      } else {
        paymentKey = expense['paymentMethod'] ?? 'cash';
      }

      final newExpense = ExpenseEntity(
        amount: (expense['amount'] as num).toDouble(),
        category: ExpenseCategory.fromKey(categoryKey),
        description: expense['description']?.toString() ?? '',
        date: DateTime.now(),
        isIncome: expense['isIncome'] == true,
        paymentMethod: PaymentMethod.fromKey(paymentKey),
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
        ));
  }
}
