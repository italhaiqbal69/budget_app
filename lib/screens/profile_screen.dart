import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 22, 20, 100),
    children: [
      Text('Profile', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 5),
      Text(
        'Make BudgetBud work your way',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 24),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.navy,
                child: Text(
                  'T',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Talha Khan',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Personal account',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 28),
      Text('Preferences', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 10),
      _settings(context, [
        const _Setting(
          icon: Icons.currency_exchange_rounded,
          title: 'Currency',
          value: 'PKR',
        ),
        const _Setting(
          icon: Icons.category_outlined,
          title: 'Categories',
          value: '9 categories',
        ),
        const _Setting(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Monthly Budget',
          value: 'Rs. 100,000',
        ),
        const _Setting(
          icon: Icons.notifications_none_rounded,
          title: 'Notifications',
          value: 'On',
        ),
        const _Setting(
          icon: Icons.dark_mode_outlined,
          title: 'Theme',
          value: 'Light',
        ),
      ]),
      const SizedBox(height: 22),
      Text('AI Preferences', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 10),
      _settings(context, [
        const _Setting(
          icon: Icons.document_scanner_outlined,
          title: 'Receipt scanning',
          value: 'Enabled',
          toggle: true,
        ),
        const _Setting(
          icon: Icons.auto_awesome_outlined,
          title: 'AI insights',
          value: 'Enabled',
          toggle: true,
        ),
        const _Setting(
          icon: Icons.mic_none_rounded,
          title: 'Voice input',
          value: 'Disabled',
          toggle: true,
        ),
      ]),
      const SizedBox(height: 22),
      _settings(context, [
        const _Setting(
          icon: Icons.ios_share_rounded,
          title: 'Export Data',
          value: '',
        ),
        const _Setting(
          icon: Icons.lock_outline_rounded,
          title: 'Privacy',
          value: '',
        ),
        const _Setting(
          icon: Icons.info_outline_rounded,
          title: 'About BudgetBud',
          value: 'v1.0.0',
        ),
      ]),
    ],
  );

  Widget _settings(BuildContext context, List<_Setting> items) => Card(
    child: Column(
      children: items
          .map(
            (item) => ListTile(
              leading: Icon(item.icon, color: AppColors.blue),
              title: Text(
                item.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: item.value.isEmpty ? null : Text(item.value),
              trailing: item.toggle
                  ? Switch(value: item.value == 'Enabled', onChanged: (_) {})
                  : const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.muted,
                    ),
            ),
          )
          .toList(),
    ),
  );
}

class _Setting {
  final IconData icon;
  final String title;
  final String value;
  final bool toggle;
  const _Setting({
    required this.icon,
    required this.title,
    required this.value,
    this.toggle = false,
  });
}
