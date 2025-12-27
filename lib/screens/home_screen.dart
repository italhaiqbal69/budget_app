import 'package:flutter/material.dart';
// removed unused import
import 'package:shared_preferences/shared_preferences.dart'; // For budget storage
import '../models/expense.dart';
import '../models/income.dart';
import '../database/db_helper.dart';
import 'add_expense_screen.dart';
import 'add_income_screen.dart';
import 'stats_screen.dart';
import 'package:expense_bud/widgets/transaction_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Expense> expenses = [];
  List<Income> incomes = [];
  double monthlyBudget = 0.0; // Stored in shared_prefs

  @override
  void initState() {
    super.initState();
    refreshData();
    loadBudget();
  }

  Future refreshData() async {
    final exp = await DBHelper.instance.getAllExpenses();
    final inc = await DBHelper.instance.getAllIncomes();
    setState(() {
      expenses = exp;
      incomes = inc;
    });
  }

  Future loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => monthlyBudget = prefs.getDouble('monthlyBudget') ?? 0.0);
  }

  Future setBudget(double budget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('monthlyBudget', budget);
    setState(() => monthlyBudget = budget);
  }

  double get totalExpenses => expenses.fold(0.0, (sum, e) => sum + e.amount);
  double get totalIncomes => incomes.fold(0.0, (sum, i) => sum + i.amount);
  double get netBalance => totalIncomes - totalExpenses;

  double get monthlySpent {
    final now = DateTime.now();
    return expenses
        .where((e) => e.date.month == now.month && e.date.year == now.year)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double get monthlyRemaining => monthlyBudget - monthlySpent;

  List<dynamic> get recentTransactions {
    final all = <dynamic>[...expenses, ...incomes];
    all.sort((a, b) => (b as dynamic).date.compareTo((a as dynamic).date));
    return all.take(10).toList(); // Last 10
  }

  @override
  Widget build(BuildContext context) {
    final todaySpent = expenses
        .where((e) => DateTime.now().difference(e.date).inDays == 0)
        .fold(0.0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BudgetBud'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final budget = await showDialog<double>(
                context: context,
                builder: (ctx) {
                  double newBudget = monthlyBudget;
                  return AlertDialog(
                    title: const Text('Set Monthly Budget'),
                    content: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Budget Amount',
                      ),
                      onChanged: (val) => newBudget = double.tryParse(val) ?? 0,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, newBudget),
                        child: const Text('Save'),
                      ),
                    ],
                  );
                },
              );
              if (budget != null) setBudget(budget);
            },
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Net Balance',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Text(
                        'PKR ${netBalance.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: netBalance >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildInfoCard(
                            'Today Spent',
                            'PKR ${todaySpent.toStringAsFixed(0)}',
                            Colors.red,
                          ),
                          _buildInfoCard(
                            'Monthly Remaining',
                            'PKR ${monthlyRemaining.toStringAsFixed(0)}',
                            monthlyRemaining >= 0 ? Colors.green : Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Recent Transactions',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Expanded(
                  child: recentTransactions.isEmpty
                      ? const Center(child: Text('No transactions yet!'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: recentTransactions.length,
                          itemBuilder: (ctx, i) {
                            final tx = recentTransactions[i];
                            if (tx is Expense) {
                              return TransactionItem(
                                isExpense: true,
                                title: tx.title,
                                amount: tx.amount,
                                date: tx.date,
                                category: tx.category,
                                onDelete: () async {
                                  await DBHelper.instance.deleteExpense(tx.id!);
                                  refreshData();
                                },
                              );
                            } else if (tx is Income) {
                              return TransactionItem(
                                isExpense: false,
                                title: tx.title,
                                amount: tx.amount,
                                date: tx.date,
                                category: tx.category,
                                onDelete: () async {
                                  await DBHelper.instance.deleteIncome(tx.id!);
                                  refreshData();
                                },
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                ),
              ],
            )
          : StatsScreen(expenses: expenses, incomes: incomes),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'addExpense',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
              );
              refreshData();
            },
            child: const Icon(Icons.remove),
            backgroundColor: Colors.red,
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'addIncome',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddIncomeScreen()),
              );
              refreshData();
            },
            child: const Icon(Icons.add),
            backgroundColor: Colors.green,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String amount, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: Colors.grey[400])),
        const SizedBox(height: 8),
        Text(
          amount,
          style: TextStyle(
            fontSize: 24,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
