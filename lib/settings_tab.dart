import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'app_strings.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final locale = settings.locale;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text(AppStrings.get('sound', locale)),
            value: settings.soundEnabled,
            onChanged: (value) => context.read<SettingsProvider>().setSoundEnabled(value),
          ),
          ListTile(
            title: Text(AppStrings.get('language', locale)),
            trailing: DropdownButton<String>(
              value: locale,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'ar', child: Text('العربية')),
              ],
              onChanged: (value) {
                if (value != null) context.read<SettingsProvider>().setLocale(value);
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(AppStrings.get('about', locale)),
            onTap: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(AppStrings.get('about', locale)),
                content: Text(AppStrings.get('about_text', locale)),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: Text(AppStrings.get('ok', locale))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
