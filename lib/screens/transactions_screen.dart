import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/fintech_widgets.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  int filter = 0;
  final search = TextEditingController();

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactions = filter == 1
        ? mockTransactions.where((item) => item.isIncome).toList()
        : filter == 2
        ? mockTransactions.where((item) => !item.isIncome).toList()
        : mockTransactions;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 100),
      children: [
        Text('Transactions', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 5),
        Text(
          'Your complete money trail',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        TextField(
          controller: search,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search_rounded),
            hintText: 'Search transactions...',
            suffixIcon: Icon(Icons.tune_rounded),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: ['All', 'Income', 'Expenses']
              .asMap()
              .entries
              .map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(entry.value),
                    selected: filter == entry.key,
                    onSelected: (_) => setState(() => filter = entry.key),
                    selectedColor: AppColors.navy,
                    labelStyle: TextStyle(
                      color: filter == entry.key
                          ? Colors.white
                          : AppColors.muted,
                      fontWeight: FontWeight.w700,
                    ),
                    showCheckmark: false,
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'September 2026',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.calendar_month_rounded,
                color: AppColors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'TODAY',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.muted,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 5),
        ...transactions
            .take(3)
            .map(
              (item) => Dismissible(
                key: ValueKey(item.title),
                background: _swipeBackground(
                  Icons.edit_rounded,
                  AppColors.blue,
                ),
                secondaryBackground: _swipeBackground(
                  Icons.delete_outline_rounded,
                  AppColors.coral,
                ),
                onDismissed: (_) {},
                child: TransactionTile(transaction: item),
              ),
            ),
        const SizedBox(height: 18),
        Text(
          'EARLIER THIS MONTH',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.muted,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 5),
        ...transactions
            .skip(3)
            .map((item) => TransactionTile(transaction: item)),
      ],
    );
  }

  Widget _swipeBackground(IconData icon, Color color) => Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.all(20),
    color: color.withValues(alpha: .12),
    child: Icon(icon, color: color),
  );
}
