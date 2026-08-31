import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state_provider.dart';
import 'settings_provider.dart';
import 'app_strings.dart';
import 'home_tab.dart';
import 'practice_tab.dart';
import 'results_tab.dart';
import 'settings_tab.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final locale = context.watch<SettingsProvider>().locale;

    final tabs = const [HomeTab(), PracticeTab(), ResultsTab(), SettingsTab()];

    return Directionality(
      textDirection: locale == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: IndexedStack(index: appState.tabIndex, children: tabs),
        bottomNavigationBar: NavigationBar(
          selectedIndex: appState.tabIndex,
          onDestinationSelected: appState.setTab,
          destinations: [
            NavigationDestination(icon: const Icon(Icons.home), label: AppStrings.get('home', locale)),
            NavigationDestination(icon: const Icon(Icons.mic), label: AppStrings.get('practice', locale)),
            NavigationDestination(icon: const Icon(Icons.emoji_events), label: AppStrings.get('results', locale)),
            NavigationDestination(icon: const Icon(Icons.settings), label: AppStrings.get('settings', locale)),
          ],
        ),
      ),
    );
  }
}
