import 'package:flutter/material.dart';
import '../models/income.dart';
import '../database/db_helper.dart';
import '../models/expense.dart'; // For categories
import '../services/app_services.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  double amount = 0;
  String category = 'Other';
  DateTime selectedDate = DateTime.now();
  bool suggestingCategory = false;

  Future<void> suggestCategory() async {
    if (title.trim().isEmpty) return;
    setState(() => suggestingCategory = true);
    try {
      final suggestion = await AppServices.ai.categorize(
        title: title,
        type: 'income',
        amount: amount,
      );
      if (mounted) setState(() => category = suggestion.category);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category suggestion is unavailable.')),
        );
      }
    } finally {
      if (mounted) setState(() => suggestingCategory = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Income')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (val) => title = val,
                validator: (val) => val!.isEmpty ? 'Enter title' : null,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: suggestingCategory ? null : suggestCategory,
                  icon: suggestingCategory
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(),
                        )
                      : const Icon(Icons.auto_awesome),
                  label: const Text('Suggest category'),
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onChanged: (val) => amount = double.tryParse(val) ?? 0,
                validator: (val) => val!.isEmpty ? 'Enter amount' : null,
              ),
              DropdownButtonFormField(
                value: category,
                items: categories
                    .map(
                      (c) => DropdownMenuItem(
                        value: c['name'],
                        child: Text('${c['icon']} ${c['name']}'),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => category = val as String),
              ),
              ListTile(
                title: Text(
                  'Date: ${selectedDate.toLocal().toString().split(' ')[0]}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) setState(() => selectedDate = date);
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final income = Income(
                      title: title,
                      amount: amount,
                      date: selectedDate,
                      category: category,
                    );
                    await DBHelper.instance.insertIncome(income);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Income'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
