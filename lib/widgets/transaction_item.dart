import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart'; // For categories

class TransactionItem extends StatelessWidget {
  final bool isExpense;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final VoidCallback onDelete;

  const TransactionItem({
    super.key,
    required this.isExpense,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final categoryInfo = categories.firstWhere(
      (c) => c['name'] == category,
      orElse: () => {'icon': '📦'},
    );
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isExpense ? Colors.red[900] : Colors.green[900],
          child: Text(categoryInfo['icon']),
        ),
        title: Text(title),
        subtitle: Text(
          '${category} • ${DateFormat('MMM dd, yyyy').format(date)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${isExpense ? '-' : '+'}₹${amount.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isExpense ? Colors.red : Colors.green,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
