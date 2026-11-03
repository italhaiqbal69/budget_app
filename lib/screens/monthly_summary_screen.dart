import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/expense.dart';
import '../models/income.dart';
import '../models/monthly_summary.dart';
import '../services/ai_service.dart';

class MonthlySummaryScreen extends StatefulWidget {
  final List<Expense> expenses;
  final List<Income> incomes;
  final AIService aiService;

  const MonthlySummaryScreen({
    super.key,
    required this.expenses,
    required this.incomes,
    required this.aiService,
  });

  @override
  State<MonthlySummaryScreen> createState() => _MonthlySummaryScreenState();
}

class _MonthlySummaryScreenState extends State<MonthlySummaryScreen> {
  String? narrative;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final calculated = const MonthlySummaryCalculator().calculate(
      month: DateTime.now(),
      expenses: widget.expenses,
      incomes: widget.incomes,
    );
    final topCategory = calculated.highestSpendingCategory;
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('MMMM yyyy').format(calculated.month)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Income: PKR ${calculated.totalIncome.toStringAsFixed(0)}'),
          Text('Expenses: PKR ${calculated.totalExpenses.toStringAsFixed(0)}'),
          Text('Balance: PKR ${calculated.balance.toStringAsFixed(0)}'),
          const SizedBox(height: 16),
          if (topCategory != null)
            Text(
              'Highest spending: $topCategory (PKR ${calculated.categorySpending[topCategory]!.toStringAsFixed(0)})',
            ),
          const SizedBox(height: 16),
          ...calculated.categorySpending.entries.map(
            (entry) => ListTile(
              title: Text(entry.key),
              trailing: Text('PKR ${entry.value.toStringAsFixed(0)}'),
            ),
          ),
          if (calculated.previousExpenses > 0)
            Text(
              'Change from last month: PKR ${calculated.expenseChange.toStringAsFixed(0)}',
            ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: loading
                ? null
                : () async {
                    setState(() => loading = true);
                    try {
                      final text = await widget.aiService.generateSummary(
                        calculated.toAIInput(),
                      );
                      if (mounted) setState(() => narrative = text);
                    } catch (_) {
                      if (mounted)
                        setState(
                          () => narrative =
                              'AI insights are currently unavailable. The totals above are calculated from your saved transactions.',
                        );
                    } finally {
                      if (mounted) setState(() => loading = false);
                    }
                  },
            icon: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(),
                  )
                : const Icon(Icons.auto_awesome),
            label: const Text('Generate insights'),
          ),
          if (narrative != null)
            Card(
              margin: const EdgeInsets.only(top: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(narrative!),
              ),
            ),
        ],
      ),
    );
  }
}
