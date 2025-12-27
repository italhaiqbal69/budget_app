import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../models/income.dart';

class StatsScreen extends StatefulWidget {
  final List<Expense> expenses;
  final List<Income> incomes;

  const StatsScreen({super.key, required this.expenses, required this.incomes});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  double totalExpenses = 0;
  double totalIncomes = 0;
  double netBalance = 0;

  @override
  void initState() {
    super.initState();
    totalExpenses = widget.expenses.fold(0, (sum, e) => sum + e.amount);
    totalIncomes = widget.incomes.fold(0, (sum, i) => sum + i.amount);
    netBalance = totalIncomes - totalExpenses;
  }

  // Group expenses by category
  Map<String, double> getCategoryData(bool isExpense) {
    Map<String, double> categoryMap = {};
    final items = isExpense
        ? widget.expenses.cast<dynamic>()
        : widget.incomes.cast<dynamic>();
    for (var item in items) {
      categoryMap.update(
        item.category,
        (value) => value + item.amount,
        ifAbsent: () => item.amount,
      );
    }
    return categoryMap;
  }

  // Get last 7 days net (income - expense per day)
  List<double> getLast7DaysNet() {
    List<double> dailyNet = List.filled(7, 0.0);
    final now = DateTime.now();

    for (var expense in widget.expenses) {
      final daysAgo = now.difference(expense.date).inDays;
      if (daysAgo >= 0 && daysAgo < 7) {
        dailyNet[6 - daysAgo] -= expense.amount;
      }
    }

    for (var income in widget.incomes) {
      final daysAgo = now.difference(income.date).inDays;
      if (daysAgo >= 0 && daysAgo < 7) {
        dailyNet[6 - daysAgo] += income.amount;
      }
    }
    return dailyNet;
  }

  @override
  Widget build(BuildContext context) {
    final expenseCategories = getCategoryData(true);
    final incomeCategories = getCategoryData(false);
    final last7Days = getLast7DaysNet();

    final hasData = widget.expenses.isNotEmpty || widget.incomes.isNotEmpty;

    return Scaffold(
      body: !hasData
          ? const Center(
              child: Text(
                'No transactions yet!\nAdd some to see stats.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'Net Balance',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'PKR ${netBalance.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: netBalance >= 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Incomes',
                                    style: TextStyle(color: Colors.grey[400]),
                                  ),
                                  Text(
                                    '₹${totalIncomes.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Expenses',
                                    style: TextStyle(color: Colors.grey[400]),
                                  ),
                                  Text(
                                    '₹${totalExpenses.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            '${widget.expenses.length + widget.incomes.length} transactions',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Expense Pie Chart
                  const Text(
                    'Expenses by Category',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  if (expenseCategories.isNotEmpty)
                    SizedBox(
                      height: 250,
                      child: PieChart(
                        PieChartData(
                          sections: expenseCategories.entries.map((entry) {
                            final categoryInfo = categories.firstWhere(
                              (c) => c['name'] == entry.key,
                            );
                            return PieChartSectionData(
                              value: entry.value,
                              title:
                                  '${categoryInfo['icon']}\n₹${entry.value.toStringAsFixed(0)}',
                              color: Colors
                                  .primaries[categories.indexOf(categoryInfo) %
                                      Colors.primaries.length]
                                  .withRed(200),
                              radius: 80,
                              titleStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                          sectionsSpace: 4,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    )
                  else
                    const Text(
                      'No expenses yet.',
                      style: TextStyle(color: Colors.grey),
                    ),

                  const SizedBox(height: 20),

                  // Income Pie Chart
                  const Text(
                    'Incomes by Category',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  if (incomeCategories.isNotEmpty)
                    SizedBox(
                      height: 250,
                      child: PieChart(
                        PieChartData(
                          sections: incomeCategories.entries.map((entry) {
                            final categoryInfo = categories.firstWhere(
                              (c) => c['name'] == entry.key,
                            );
                            return PieChartSectionData(
                              value: entry.value,
                              title:
                                  '${categoryInfo['icon']}\n₹${entry.value.toStringAsFixed(0)}',
                              color: Colors
                                  .primaries[categories.indexOf(categoryInfo) %
                                      Colors.primaries.length]
                                  .withGreen(200),
                              radius: 80,
                              titleStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                          sectionsSpace: 4,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    )
                  else
                    const Text(
                      'No incomes yet.',
                      style: TextStyle(color: Colors.grey),
                    ),

                  const SizedBox(height: 40),

                  // Bar Chart - Last 7 Days Net
                  const Text(
                    'Last 7 Days Net Balance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 250,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: last7Days.reduce((a, b) => a > b ? a : b) * 1.2,
                        minY: last7Days.reduce((a, b) => a < b ? a : b) * 1.2,
                        barGroups: List.generate(7, (i) {
                          final color = last7Days[i] >= 0
                              ? Colors.green
                              : Colors.red;
                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: last7Days[i],
                                color: color,
                                width: 20,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6),
                                ),
                              ),
                            ],
                          );
                        }),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final day = DateTime.now().subtract(
                                  Duration(days: 6 - value.toInt()),
                                );
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    DateFormat('EEE').format(day),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                        ),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
