import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/fintech_widgets.dart';

class ReceiptScannerUIScreen extends StatefulWidget {
  const ReceiptScannerUIScreen({super.key});
  @override
  State<ReceiptScannerUIScreen> createState() => _ReceiptScannerUIScreenState();
}

class _ReceiptScannerUIScreenState extends State<ReceiptScannerUIScreen> {
  bool scanned = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Scan Receipt',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      centerTitle: true,
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      children: [
        Text(
          'Take a photo or upload a receipt',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 22),
        InkWell(
          onTap: () => setState(() => scanned = true),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 205,
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  scanned
                      ? Icons.check_circle_rounded
                      : Icons.document_scanner_rounded,
                  color: scanned ? const Color(0xFF77E0AE) : Colors.white,
                  size: 52,
                ),
                const SizedBox(height: 13),
                Text(
                  scanned ? 'Receipt ready to review' : 'Tap to scan a receipt',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'JPG or PNG up to 10 MB',
                  style: TextStyle(color: Colors.white.withValues(alpha: .65)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => setState(() => scanned = true),
                icon: const Icon(Icons.camera_alt_rounded),
                label: const Text('Take Photo'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => setState(() => scanned = true),
                icon: const Icon(Icons.photo_library_rounded),
                label: const Text('Gallery'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ),
          ],
        ),
        if (scanned) ...[
          const SizedBox(height: 28),
          Text(
            'Receipt Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(17),
              child: Column(
                children: const [
                  _ReceiptField(label: 'Merchant', value: 'Carrefour'),
                  _ReceiptField(label: 'Total', value: 'Rs. 4,850'),
                  _ReceiptField(label: 'Date', value: '16 Sep 2026'),
                  _ReceiptField(label: 'Category', value: 'Groceries'),
                  Divider(height: 24),
                  _ReceiptField(label: 'Milk', value: 'Rs. 320'),
                  _ReceiptField(label: 'Bread', value: 'Rs. 180'),
                  _ReceiptField(label: 'Chicken', value: 'Rs. 1,200'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          PrimaryButton(
            label: 'Confirm Transaction',
            icon: Icons.check_rounded,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ],
    ),
  );
}

class _ReceiptField extends StatelessWidget {
  final String label;
  final String value;
  const _ReceiptField({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(label, style: Theme.of(context).textTheme.bodyMedium),
    trailing: Text(value, style: Theme.of(context).textTheme.titleMedium),
  );
}
