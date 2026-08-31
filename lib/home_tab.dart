import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state_provider.dart';
import 'settings_provider.dart';
import 'app_strings.dart';
import 'primary_button.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<SettingsProvider>().locale;
    final appState = context.read<AppStateProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text(AppStrings.get('welcome', locale),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(AppStrings.get('welcome_sub', locale),
                style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 32),
            PrimaryButton(
              label: AppStrings.get('start_speaking', locale),
              icon: Icons.mic,
              onPressed: () => appState.setTab(1),
            ),
            const SizedBox(height: 40),
            Text(AppStrings.get('what_you_can_do', locale),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _FeatureRow(icon: Icons.volume_up, text: AppStrings.get('feature_1', locale)),
            _FeatureRow(icon: Icons.record_voice_over, text: AppStrings.get('feature_2', locale)),
            _FeatureRow(icon: Icons.check_circle_outline, text: AppStrings.get('feature_3', locale)),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(text)),
      ]),
    );
  }
}
