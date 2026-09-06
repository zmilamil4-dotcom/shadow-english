import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state_provider.dart';
import 'settings_provider.dart';
import 'app_theme.dart';
import 'home_tab.dart';
import 'learn_tab.dart';
import 'practice_tab.dart';
import 'progress_tab.dart';
import 'profile_tab.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final locale = context.watch<SettingsProvider>().locale;

    final tabs = const [
      HomeTab(),
      LearnTab(),
      PracticeTab(),
      ProgressTab(),
      ProfileTab(),
    ];

    return Directionality(
      textDirection: locale == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(index: appState.tabIndex, children: tabs),
        bottomNavigationBar: _BottomBar(appState: appState),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final AppStateProvider appState;
  const _BottomBar({required this.appState});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, -6)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavItem(icon: Icons.home_rounded, label: 'Home', index: 0, appState: appState),
              _NavItem(icon: Icons.menu_book_rounded, label: 'Learn', index: 1, appState: appState),
              _MicNavItem(appState: appState),
              _NavItem(icon: Icons.show_chart_rounded, label: 'Progress', index: 3, appState: appState),
              _NavItem(icon: Icons.person_rounded, label: 'Profile', index: 4, appState: appState),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final AppStateProvider appState;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    final selected = appState.tabIndex == index;
    final color = selected ? AppTheme.accentPurple : AppTheme.textSecondary;
    return InkWell(
      onTap: () => appState.setTab(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _MicNavItem extends StatelessWidget {
  final AppStateProvider appState;
  const _MicNavItem({required this.appState});

  @override
  Widget build(BuildContext context) {
    final selected = appState.tabIndex == 2;
    return GestureDetector(
      onTap: () => appState.setTab(2),
      child: Transform.translate(
        offset: const Offset(0, -18),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentPurple.withOpacity(selected ? 0.6 : 0.35),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.mic_rounded, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
