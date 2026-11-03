import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/fintech_widgets.dart';
import 'monthly_summary_ui_screen.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 100),
      children: [
        Text('Analytics', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 5),
        Text(
          'A clearer view of your habits',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        const Row(
          children: [
            MetricCard(
              label: 'Income',
              value: 'Rs. 180k',
              color: AppColors.green,
              icon: Icons.arrow_downward_rounded,
            ),
            SizedBox(width: 10),
            MetricCard(
              label: 'Expenses',
              value: 'Rs. 54.5k',
              color: AppColors.coral,
              icon: Icons.arrow_upward_rounded,
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Row(
          children: [
            MetricCard(
              label: 'Saved',
              value: 'Rs. 125k',
              color: AppColors.blue,
              icon: Icons.savings_outlined,
            ),
            SizedBox(width: 10),
            MetricCard(
              label: 'Savings rate',
              value: '69.7%',
              color: AppColors.lilac,
              icon: Icons.trending_up_rounded,
            ),
          ],
        ),
        const SizedBox(height: 27),
        Text(
          'Expense Breakdown',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 15),
        _breakdownCard(),
        const SizedBox(height: 27),
        Text('Spending Trend', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 15),
        _trendCard(),
        const SizedBox(height: 27),
        _insightCard(context),
      ],
    );
  }

  Widget _breakdownCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            SizedBox(
              width: 145,
              height: 145,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 42,
                  sections: [
                    PieChartSectionData(
                      value: 28,
                      color: AppColors.coral,
                      radius: 25,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      value: 19,
                      color: AppColors.blue,
                      radius: 25,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      value: 16,
                      color: AppColors.lilac,
                      radius: 25,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      value: 15,
                      color: const Color(0xFFF1A33C),
                      radius: 25,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      value: 22,
                      color: const Color(0xFF57B6A6),
                      radius: 25,
                      showTitle: false,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                children: categorySpending.entries
                    .take(4)
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.circle,
                              size: 8,
                              color: AppColors.blue,
                            ),
                            const SizedBox(width: 7),
                            Expanded(child: Text(item.key)),
                            Text(
                              'Rs. ${(item.value / 1000).toStringAsFixed(1)}k',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _trendCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 20, 18, 12),
        child: SizedBox(
          height: 170,
          child: BarChart(
            BarChartData(
              maxY: 50,
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              barGroups: List.generate(
                6,
                (index) => BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: [25, 34, 20, 45, 31, 40][index].toDouble(),
                      color: index == 4 ? AppColors.blue : AppColors.line,
                      width: 18,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _insightCard(BuildContext context) {
    return Card(
      color: AppColors.navy,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.auto_awesome_rounded, color: Color(0xFFB9B0FF)),
                SizedBox(width: 8),
                Text(
                  'AI Insights',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'Your food spending increased this month.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Transport spending decreased by 12%.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MonthlySummaryUIScreen(),
                ),
              ),
              child: const Text(
                'View Full Analysis',
                style: TextStyle(
                  color: Color(0xFFB9B0FF),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
