import 'package:flutter/material.dart';

import '../models/mock_transaction.dart';
import '../theme/app_theme.dart';

final mockTransactions = <MockTransaction>[
  MockTransaction(
    title: 'Salary',
    category: 'Income',
    amount: 180000,
    date: DateTime(2026, 9, 15),
    type: MockTransactionType.income,
    icon: Icons.work_outline_rounded,
    color: AppColors.green,
  ),
  MockTransaction(
    title: 'KFC',
    category: 'Food',
    amount: 1250,
    date: DateTime(2026, 9, 16, 19, 30),
    type: MockTransactionType.expense,
    icon: Icons.restaurant_rounded,
    color: AppColors.coral,
  ),
  MockTransaction(
    title: 'Careem',
    category: 'Transport',
    amount: 650,
    date: DateTime(2026, 9, 16, 17, 20),
    type: MockTransactionType.expense,
    icon: Icons.directions_car_filled_rounded,
    color: AppColors.blue,
  ),
  MockTransaction(
    title: 'Carrefour',
    category: 'Groceries',
    amount: 4850,
    date: DateTime(2026, 9, 14, 18),
    type: MockTransactionType.expense,
    icon: Icons.shopping_cart_rounded,
    color: AppColors.lilac,
  ),
  MockTransaction(
    title: 'Netflix',
    category: 'Entertainment',
    amount: 1100,
    date: DateTime(2026, 9, 12),
    type: MockTransactionType.expense,
    icon: Icons.play_circle_fill_rounded,
    color: const Color(0xFFE45775),
  ),
  MockTransaction(
    title: 'Electricity',
    category: 'Bills',
    amount: 7800,
    date: DateTime(2026, 9, 10),
    type: MockTransactionType.expense,
    icon: Icons.bolt_rounded,
    color: const Color(0xFFF1A33C),
  ),
];

final categorySpending = <String, double>{
  'Food': 28400,
  'Transport': 12500,
  'Shopping': 18200,
  'Bills': 15600,
  'Entertainment': 7750,
};
