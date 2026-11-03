import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/fintech_widgets.dart';
import 'add_transaction_screen.dart';
import 'analytics_screen.dart';
import 'profile_screen.dart';
import 'transactions_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  Future<void> openAdd() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _Dashboard(onAdd: openAdd),
      const TransactionsScreen(),
      const AnalyticsScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: selectedIndex, children: pages),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAdd,
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => setState(() => selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.space_dashboard_outlined),
            selectedIcon: Icon(Icons.space_dashboard_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'Activity',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights_rounded),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  final VoidCallback onAdd;
  const _Dashboard({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 100),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good morning 👋',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Here's your financial overview",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.navy,
              child: Text(
                'T',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _BalanceCard(onAdd: onAdd),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'September 2026',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
          ],
        ),
        _SpendingOverview(),
        const SizedBox(height: 25),
        SectionHeader(
          title: 'Recent Transactions',
          action: 'See all',
          onAction: () {},
        ),
        ...mockTransactions
            .take(4)
            .map((transaction) => TransactionTile(transaction: transaction)),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final VoidCallback onAdd;
  const _BalanceCard({required this.onAdd});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: AppColors.navy,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: AppColors.navy.withValues(alpha: .2),
          blurRadius: 22,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Balance',
              style: TextStyle(color: Colors.white.withValues(alpha: .7)),
            ),
            IconButton(
              onPressed: onAdd,
              icon: const Icon(
                Icons.add_circle_outline_rounded,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        const Text(
          'Rs. 125,450',
          style: TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 23),
        Row(
          children: [
            Expanded(
              child: _BalanceMetric(
                label: 'Income',
                amount: 'Rs. 180,000',
                icon: Icons.arrow_downward_rounded,
                color: Color(0xFF77E0AE),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: _BalanceMetric(
                label: 'Expenses',
                amount: 'Rs. 54,550',
                icon: Icons.arrow_upward_rounded,
                color: Color(0xFFFF9F8C),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _BalanceMetric extends StatelessWidget {
  final String label;
  final String amount;
  final IconData icon;
  final Color color;
  const _BalanceMetric({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 29,
        height: 29,
        decoration: BoxDecoration(
          color: color.withValues(alpha: .18),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 16),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: .6),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              amount,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _SpendingOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spending Overview',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Icon(Icons.more_horiz_rounded, color: AppColors.muted),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: ['Week', 'Month', 'Year']
                .map(
                  (label) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(label),
                        selected: label == 'Month',
                        onSelected: (_) {},
                        showCheckmark: false,
                        labelStyle: TextStyle(
                          color: label == 'Month'
                              ? Colors.white
                              : AppColors.muted,
                          fontWeight: FontWeight.w700,
                        ),
                        selectedColor: AppColors.blue,
                        backgroundColor: AppColors.canvas,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 92,
            child: CustomPaint(painter: _SparklinePainter()),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 14,
            runSpacing: 12,
            children: categorySpending.keys
                .take(5)
                .map(
                  (label) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.circle, color: AppColors.blue, size: 7),
                      const SizedBox(width: 5),
                      Text(
                        label,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    ),
  );
}

class _SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height * .72)
      ..cubicTo(
        size.width * .15,
        size.height * .18,
        size.width * .28,
        size.height * .82,
        size.width * .42,
        size.height * .48,
      )
      ..cubicTo(
        size.width * .56,
        size.height * .12,
        size.width * .72,
        size.height * .76,
        size.width,
        size.height * .25,
      );
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(0, size.height * .88),
      Offset(size.width, size.height * .88),
      Paint()
        ..color = AppColors.line
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
