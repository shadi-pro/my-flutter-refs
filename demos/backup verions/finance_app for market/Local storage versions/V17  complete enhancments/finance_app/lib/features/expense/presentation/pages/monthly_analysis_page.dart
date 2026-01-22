// lib/features/expense/presentation/pages/monthly_analysis_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/expense_controller.dart';

class MonthlyAnalysisPage extends StatelessWidget {
  MonthlyAnalysisPage({super.key});
  final ExpenseController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final monthlyData = _getMonthlyData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('تحليل شهري - مقارنة الأشهر'),
        centerTitle: true,
      ),
      body: monthlyData.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 1. الرسم البياني
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'مقارنة الدخل والمصروفات خلال 6 أشهر',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 300,
                            child: _buildMonthlyChart(monthlyData),
                          ),
                          const SizedBox(height: 16),
                          _buildChartLegend(),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 2. جدول البيانات
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'مقارنة مفصلة لكل شهر',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildComparisonTable(monthlyData),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 3. إحصائيات إضافية
                  _buildAdditionalStats(monthlyData),
                ],
              ),
            ),
    );
  }

  // ============ دوال مساعدة ============

  List<Map<String, dynamic>> _getMonthlyData() {
    final List<Map<String, dynamic>> data = [];
    final now = DateTime.now();

    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthName = _getMonthName(month.month);

      final monthlyExpenses = controller.expenses.where((expense) {
        return expense.date.month == month.month &&
            expense.date.year == month.year;
      }).toList();

      double income = 0;
      double expense = 0;

      for (var exp in monthlyExpenses) {
        if (exp.isIncome) {
          income += exp.amount;
        } else {
          expense += exp.amount;
        }
      }

      data.add({
        'month': monthName,
        'monthShort': _getMonthShortName(month.month),
        'year': month.year,
        'income': income,
        'expense': expense,
        'balance': income - expense,
        'transactionCount': monthlyExpenses.length,
      });
    }

    return data;
  }

  Widget _buildMonthlyChart(List<Map<String, dynamic>> data) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxAmount(data) * 1.2,
        minY: 0,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.white,
            tooltipPadding: const EdgeInsets.all(8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final month = data[groupIndex]['monthShort'];
              final value = rod.toY.toStringAsFixed(2);
              final type = rodIndex == 0 ? 'الدخل' : 'المصروف';
              return BarTooltipItem(
                '$month\n$type: $value ج.م',
                const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      data[index]['monthShort'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 32,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: _getChartInterval(data),
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: _getChartInterval(data),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: Colors.grey, width: 1),
            left: BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        barGroups: List.generate(data.length, (index) {
          return BarChartGroupData(
            x: index,
            groupVertically: true,
            barRods: [
              BarChartRodData(
                toY: data[index]['income'],
                color: Colors.green,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
              BarChartRodData(
                toY: data[index]['expense'],
                color: Colors.red,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildChartLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('الدخل', Colors.green),
        const SizedBox(width: 24),
        _buildLegendItem('المصروفات', Colors.red),
      ],
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildComparisonTable(List<Map<String, dynamic>> data) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 24,
        dataRowMinHeight: 40,
        columns: const [
          DataColumn(label: Text('الشهر')),
          DataColumn(label: Text('الدخل', textAlign: TextAlign.center)),
          DataColumn(label: Text('المصروف', textAlign: TextAlign.center)),
          DataColumn(label: Text('الرصيد', textAlign: TextAlign.center)),
          DataColumn(label: Text('المعاملات', textAlign: TextAlign.center)),
        ],
        rows: data.map((monthData) {
          return DataRow(cells: [
            DataCell(Text('${monthData['month']}')),
            DataCell(Text(
              '${monthData['income'].toStringAsFixed(2)}',
              style: TextStyle(color: Colors.green[700]),
              textAlign: TextAlign.center,
            )),
            DataCell(Text(
              '${monthData['expense'].toStringAsFixed(2)}',
              style: TextStyle(color: Colors.red[700]),
              textAlign: TextAlign.center,
            )),
            DataCell(Text(
              '${monthData['balance'].toStringAsFixed(2)}',
              style: TextStyle(
                color: monthData['balance'] >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )),
            DataCell(Text(
              monthData['transactionCount'].toString(),
              textAlign: TextAlign.center,
            )),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildAdditionalStats(List<Map<String, dynamic>> data) {
    // ✅ الإصلاح هنا:
    final totalTransactions =
        data.fold(0, (sum, month) => sum + (month['transactionCount'] as int));

    final totalBalance =
        data.fold(0.0, (sum, month) => sum + (month['balance'] as double));

    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.receipt_long, color: Colors.blue, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    totalTransactions.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const Text('إجمالي المعاملات',
                      style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(
                    totalBalance >= 0 ? Icons.trending_up : Icons.trending_down,
                    color: totalBalance >= 0 ? Colors.green : Colors.red,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    totalBalance.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: totalBalance >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                  const Text('صافي الفترة', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد بيانات كافية للتحليل',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'أضف معاملات لترى التحليل الشهري',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  double _getMaxAmount(List<Map<String, dynamic>> data) {
    double max = 0;
    for (var item in data) {
      if ((item['income'] as double) > max) max = item['income'] as double;
      if ((item['expense'] as double) > max) max = item['expense'] as double;
    }
    return max == 0 ? 1000 : max;
  }

  double _getChartInterval(List<Map<String, dynamic>> data) {
    final maxAmount = _getMaxAmount(data);
    if (maxAmount < 1000) return 200;
    if (maxAmount < 5000) return 1000;
    if (maxAmount < 20000) return 5000;
    return 10000;
  }

  String _getMonthName(int month) {
    final months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];
    return months[month - 1];
  }

  String _getMonthShortName(int month) {
    final months = [
      'ينا',
      'فبر',
      'مار',
      'أبر',
      'ماي',
      'يون',
      'يول',
      'أغس',
      'سبت',
      'أكت',
      'نوف',
      'ديس'
    ];
    return months[month - 1];
  }
}
