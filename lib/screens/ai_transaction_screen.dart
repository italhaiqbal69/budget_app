import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../models/ai_models.dart';
import '../models/expense.dart';
import '../models/income.dart';
import '../services/ai_service.dart';

class AITransactionScreen extends StatefulWidget {
  final AIService aiService;

  const AITransactionScreen({super.key, required this.aiService});

  @override
  State<AITransactionScreen> createState() => _AITransactionScreenState();
}

class _AITransactionScreenState extends State<AITransactionScreen> {
  final inputController = TextEditingController();
  AITransactionResult? result;
  bool loading = false;
  String? error;

  Future<void> parse() async {
    if (inputController.text.trim().isEmpty) return;
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final parsed = await widget.aiService.parseTransaction(
        inputController.text.trim(),
      );
      if (mounted) setState(() => result = parsed);
    } catch (exception) {
      if (mounted)
        setState(() => error = 'Could not parse this transaction: $exception');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> save() async {
    final parsed = result;
    if (parsed == null) return;
    if (parsed.type == 'expense') {
      await DBHelper.instance.insertExpense(
        Expense(
          title: parsed.description.isEmpty
              ? parsed.merchant
              : parsed.description,
          amount: parsed.amount,
          date: parsed.date,
          category: parsed.category,
        ),
      );
    } else {
      await DBHelper.instance.insertIncome(
        Income(
          title: parsed.description.isEmpty
              ? parsed.merchant
              : parsed.description,
          amount: parsed.amount,
          date: parsed.date,
          category: parsed.category,
        ),
      );
    }
    if (mounted) Navigator.pop(context, true);
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Transaction Entry')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: inputController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Describe the transaction',
              hintText: 'Spent 850 on dinner yesterday',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: loading ? null : parse,
            icon: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(),
                  )
                : const Icon(Icons.auto_awesome),
            label: const Text('Create preview'),
          ),
          if (error != null) ...[
            const SizedBox(height: 16),
            Text(
              error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          if (result != null) ...[
            const SizedBox(height: 24),
            const Text(
              'Review before saving',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: Icon(
                  result!.type == 'income' ? Icons.add : Icons.remove,
                ),
                title: Text(
                  '${result!.currency} ${result!.amount.toStringAsFixed(2)}',
                ),
                subtitle: Text(
                  '${result!.category} • ${result!.merchant}\n${result!.description}',
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('Date: ${result!.date.toIso8601String().split('T').first}'),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: save,
              icon: const Icon(Icons.check),
              label: const Text('Confirm and save'),
            ),
          ],
        ],
      ),
    );
  }
}
