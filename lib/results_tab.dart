import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sentences_data.dart';
import 'app_state_provider.dart';
import 'settings_provider.dart';
import 'app_strings.dart';
import 'primary_button.dart';

class ResultsTab extends StatelessWidget {
  const ResultsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<SettingsProvider>().locale;
    final appState = context.watch<AppStateProvider>();

    if (!appState.lastAttemptSuccess) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(AppStrings.get('no_result_yet', locale),
                textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 72),
            const SizedBox(height: 16),
            Text(AppStrings.get('recording_saved', locale),
                textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(AppStrings.get('good_job', locale),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            PrimaryButton(
              label: AppStrings.get('try_again', locale),
              icon: Icons.replay,
              onPressed: () => context.read<AppStateProvider>().tryAgain(),
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: AppStrings.get('next_sentence', locale),
              icon: Icons.arrow_forward,
              onPressed: () => context.read<AppStateProvider>().nextSentence(sentencesData.length),
            ),
          ],
        ),
      ),
    );
  }
}
