import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/fintech_widgets.dart';

class AIEntryUIScreen extends StatefulWidget {
  const AIEntryUIScreen({super.key});
  @override
  State<AIEntryUIScreen> createState() => _AIEntryUIScreenState();
}

class _AIEntryUIScreenState extends State<AIEntryUIScreen> {
  bool analyzed = false;
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Add with AI',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      centerTitle: true,
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.lilacSoft,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: AppColors.lilac,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Describe it naturally',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'We’ll turn your words into a ready-to-review transaction.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text('What happened?', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'e.g. Spent Rs. 850 on dinner yesterday',
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton.filledTonal(
            onPressed: () {},
            icon: const Icon(Icons.mic_none_rounded),
            tooltip: 'Voice input',
          ),
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          label: analyzed ? 'Analyze Again' : 'Analyze Transaction',
          icon: Icons.auto_awesome_rounded,
          onPressed: () => setState(() => analyzed = true),
        ),
        if (analyzed) ...[
          const SizedBox(height: 28),
          Text('AI detected', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Expense',
                        style: TextStyle(
                          color: AppColors.coral,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextButton(onPressed: () {}, child: const Text('Edit')),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Rs. 850',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(
                        Icons.restaurant_rounded,
                        color: AppColors.coral,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Food  •  Dinner',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'September 15, 2026',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          PrimaryButton(
            label: 'Confirm & Save',
            icon: Icons.check_rounded,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ],
    ),
  );
}
