import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/fintech_widgets.dart';

class MonthlySummaryUIScreen extends StatelessWidget {
  const MonthlySummaryUIScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Your September Summary ✨',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      centerTitle: true,
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'A month worth of progress',
                style: TextStyle(color: Colors.white.withValues(alpha: .65)),
              ),
              const SizedBox(height: 19),
              _metric('You earned', 'Rs. 180,000', AppColors.green),
              const SizedBox(height: 16),
              _metric('You spent', 'Rs. 112,450', const Color(0xFFFF9F8C)),
              const SizedBox(height: 16),
              _metric('You saved', 'Rs. 67,550', Colors.white),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Where Your Money Went',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: const [
              _SummaryRow(
                icon: Icons.restaurant_rounded,
                label: 'Food',
                amount: 'Rs. 28,400',
                color: AppColors.coral,
              ),
              _SummaryRow(
                icon: Icons.directions_car_filled_rounded,
                label: 'Transport',
                amount: 'Rs. 12,500',
                color: AppColors.blue,
              ),
              _SummaryRow(
                icon: Icons.shopping_bag_rounded,
                label: 'Shopping',
                amount: 'Rs. 18,200',
                color: AppColors.lilac,
              ),
              _SummaryRow(
                icon: Icons.receipt_long_rounded,
                label: 'Bills',
                amount: 'Rs. 15,600',
                color: Color(0xFFF1A33C),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text('AI Insights', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        const _InsightCard(
          icon: Icons.lightbulb_rounded,
          title: 'Spending Insight',
          body: 'You spent more on food than your usual monthly average.',
          color: Color(0xFFF1A33C),
        ),
        const SizedBox(height: 10),
        const _InsightCard(
          icon: Icons.trending_up_rounded,
          title: 'Trend',
          body: 'Your expenses increased compared with August.',
          color: AppColors.blue,
        ),
        const SizedBox(height: 10),
        const _InsightCard(
          icon: Icons.track_changes_rounded,
          title: 'Savings',
          body: 'You saved 37% of your income this month.',
          color: AppColors.green,
        ),
      ],
    ),
  );

  Widget _metric(String label, String value, Color color) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(color: Colors.white.withValues(alpha: .7))),
      Text(
        value,
        style: TextStyle(
          color: color,
          fontSize: 23,
          fontWeight: FontWeight.w800,
        ),
      ),
    ],
  );
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String amount;
  final Color color;
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.amount,
    required this.color,
  });
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    leading: SoftIcon(
      icon: icon,
      color: color,
      background: color.withValues(alpha: .1),
      size: 40,
    ),
    title: Text(label, style: Theme.of(context).textTheme.titleMedium),
    trailing: Text(amount, style: const TextStyle(fontWeight: FontWeight.w800)),
  );
}

class _InsightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final Color color;
  const _InsightCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
  });
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SoftIcon(
            icon: icon,
            color: color,
            background: color.withValues(alpha: .1),
            size: 42,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 5),
                Text(body, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
