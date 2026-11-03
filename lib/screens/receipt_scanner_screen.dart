import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../database/db_helper.dart';
import '../models/ai_models.dart';
import '../models/expense.dart';
import '../services/ai_service.dart';

class ReceiptScannerScreen extends StatefulWidget {
  final AIService aiService;

  const ReceiptScannerScreen({super.key, required this.aiService});

  @override
  State<ReceiptScannerScreen> createState() => _ReceiptScannerScreenState();
}

class _ReceiptScannerScreenState extends State<ReceiptScannerScreen> {
  ReceiptModel? receipt;
  Uint8List? imageBytes;
  bool loading = false;
  String? error;

  Future<void> chooseReceipt(ImageSource source) async {
    final file = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
    );
    if (file == null) return;
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final bytes = await file.readAsBytes();
      final extracted = await widget.aiService.scanReceipt(bytes, file.name);
      if (mounted)
        setState(() {
          imageBytes = bytes;
          receipt = extracted;
        });
    } catch (exception) {
      if (mounted)
        setState(() => error = 'Could not read this receipt: $exception');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> save() async {
    final value = receipt;
    if (value == null) return;
    await DBHelper.instance.insertExpense(
      Expense(
        title: value.merchant,
        amount: value.totalAmount,
        date: value.date ?? DateTime.now(),
        category: value.category,
      ),
    );
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final value = receipt;
    return Scaffold(
      appBar: AppBar(title: const Text('Receipt Scanner')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: loading
                      ? null
                      : () => chooseReceipt(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: loading
                      ? null
                      : () => chooseReceipt(ImageSource.gallery),
                  icon: const Icon(Icons.photo),
                  label: const Text('Gallery'),
                ),
              ),
            ],
          ),
          if (loading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (imageBytes != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Image.memory(
                imageBytes!,
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          if (value != null) ...[
            const SizedBox(height: 20),
            const Text(
              'Review extracted details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Merchant'),
                    subtitle: Text(value.merchant),
                  ),
                  ListTile(
                    title: const Text('Total'),
                    subtitle: Text(
                      '${value.currency} ${value.totalAmount.toStringAsFixed(2)}',
                    ),
                  ),
                  ListTile(
                    title: const Text('Category'),
                    subtitle: Text(value.category),
                  ),
                  ListTile(
                    title: const Text('Date'),
                    subtitle: Text(
                      value.date?.toIso8601String().split('T').first ??
                          'Needs review',
                    ),
                  ),
                  if (value.uncertainFields.isNotEmpty)
                    ListTile(
                      leading: const Icon(Icons.warning_amber),
                      title: const Text('Needs review'),
                      subtitle: Text(value.uncertainFields.join(', ')),
                    ),
                ],
              ),
            ),
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
