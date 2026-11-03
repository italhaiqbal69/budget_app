import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/fintech_widgets.dart';
import 'ai_entry_ui_screen.dart';
import 'receipt_scanner_ui_screen.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});
  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool isExpense = true;
  String category = 'Food';
  String payment = 'Card';
  final options = const [
    ('Food', Icons.restaurant_rounded),
    ('Transport', Icons.directions_car_filled_rounded),
    ('Shopping', Icons.shopping_bag_rounded),
    ('Bills', Icons.receipt_long_rounded),
    ('Entertainment', Icons.movie_rounded),
    ('Health', Icons.favorite_rounded),
    ('Education', Icons.school_rounded),
    ('Salary', Icons.work_outline_rounded),
    ('Other', Icons.more_horiz_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add transaction',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        children: [
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: true,
                label: Text('Expense'),
                icon: Icon(Icons.arrow_upward_rounded),
              ),
              ButtonSegment(
                value: false,
                label: Text('Income'),
                icon: Icon(Icons.arrow_downward_rounded),
              ),
            ],
            selected: {isExpense},
            onSelectionChanged: (value) =>
                setState(() => isExpense = value.first),
          ),
          const SizedBox(height: 28),
          Text('Amount', style: Theme.of(context).textTheme.bodyMedium),
          const Text(
            'Rs. 0',
            style: TextStyle(
              fontSize: 42,
              color: AppColors.navy,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 22),
          const TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: '0.00', prefixText: 'Rs.  '),
          ),
          const SizedBox(height: 22),
          Text('Category', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options
                .map(
                  (item) => _CategoryChip(
                    label: item.$1,
                    icon: item.$2,
                    selected: category == item.$1,
                    onTap: () => setState(() => category = item.$1),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 22),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'What was this for?',
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _DetailField(
                  icon: Icons.calendar_today_rounded,
                  label: 'Date',
                  value: 'Today',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DetailField(
                  icon: Icons.credit_card_rounded,
                  label: 'Payment',
                  value: payment,
                  onTap: () => setState(
                    () => payment = payment == 'Card' ? 'Cash' : 'Card',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            label: 'Save Transaction',
            icon: Icons.check_rounded,
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AIEntryUIScreen()),
            ),
            icon: const Icon(Icons.auto_awesome_rounded),
            label: const Text('Add with AI'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              foregroundColor: AppColors.lilac,
              side: const BorderSide(color: AppColors.lilac),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReceiptScannerUIScreen()),
            ),
            icon: const Icon(Icons.document_scanner_outlined),
            label: const Text('Scan a receipt'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              foregroundColor: AppColors.blue,
              side: const BorderSide(color: AppColors.line),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: selected ? AppColors.blue : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: selected ? AppColors.blue : AppColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 17,
            color: selected ? Colors.white : AppColors.muted,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.ink,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
  );
}

class _DetailField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  const _DetailField({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.blue, size: 18),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 3),
                Text(value, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
