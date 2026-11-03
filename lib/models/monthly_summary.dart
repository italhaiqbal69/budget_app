import 'expense.dart';
import 'income.dart';

class MonthlySummaryModel {
  final DateTime month;
  final double totalIncome;
  final double totalExpenses;
  final Map<String, double> categorySpending;
  final MonthlySummaryModel? previousMonth;
  final String? aiNarrative;

  const MonthlySummaryModel({
    required this.month,
    required this.totalIncome,
    required this.totalExpenses,
    required this.categorySpending,
    this.previousMonth,
    this.aiNarrative,
  });

  double get balance => totalIncome - totalExpenses;
  double get previousExpenses => previousMonth?.totalExpenses ?? 0;
  double get expenseChange => totalExpenses - previousExpenses;

  String? get highestSpendingCategory {
    if (categorySpending.isEmpty) return null;
    return categorySpending.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
  }

  Map<String, dynamic> toAIInput() => {
    'month': '${month.year}-${month.month.toString().padLeft(2, '0')}',
    'total_income': totalIncome,
    'total_expenses': totalExpenses,
    'balance': balance,
    'category_spending': categorySpending,
    'previous_month_expenses': previousExpenses,
    'expense_change': expenseChange,
  };
}

class MonthlySummaryCalculator {
  const MonthlySummaryCalculator();

  MonthlySummaryModel calculate({
    required DateTime month,
    required List<Expense> expenses,
    required List<Income> incomes,
  }) {
    final current = _month(month);
    final previous = _month(DateTime(month.year, month.month - 1));
    final currentExpenses = expenses.where(
      (item) => _sameMonth(item.date, current),
    );
    final previousExpenses = expenses.where(
      (item) => _sameMonth(item.date, previous),
    );
    final currentIncomes = incomes.where(
      (item) => _sameMonth(item.date, current),
    );

    return MonthlySummaryModel(
      month: current,
      totalIncome: currentIncomes.fold(0, (sum, item) => sum + item.amount),
      totalExpenses: currentExpenses.fold(0, (sum, item) => sum + item.amount),
      categorySpending: _groupByCategory(currentExpenses),
      previousMonth: MonthlySummaryModel(
        month: previous,
        totalIncome: 0,
        totalExpenses: previousExpenses.fold(
          0,
          (sum, item) => sum + item.amount,
        ),
        categorySpending: _groupByCategory(previousExpenses),
      ),
    );
  }

  DateTime _month(DateTime date) => DateTime(date.year, date.month);
  bool _sameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  Map<String, double> _groupByCategory(Iterable<Expense> items) {
    final result = <String, double>{};
    for (final item in items) {
      if (!isValidCategory(item.category)) continue;
      result.update(
        item.category,
        (value) => value + item.amount,
        ifAbsent: () => item.amount,
      );
    }
    return result;
  }
}
