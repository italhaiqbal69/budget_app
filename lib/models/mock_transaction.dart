import 'package:flutter/material.dart';

enum MockTransactionType { income, expense }

class MockTransaction {
  final String title;
  final String category;
  final double amount;
  final DateTime date;
  final MockTransactionType type;
  final IconData icon;
  final Color color;

  const MockTransaction({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.type,
    required this.icon,
    required this.color,
  });

  bool get isIncome => type == MockTransactionType.income;
}
