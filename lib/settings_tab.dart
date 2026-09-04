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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            AppStrings.get('language', locale),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // Language
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.language,
                  color: colors.primary,
                ),
              ),
              title: Text(
                AppStrings.get('language', locale),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Choose your app language',
              ),
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: locale,
                  items: const [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: 'ar',
                      child: Text('العربية'),
                    ),
                    DropdownMenuItem(
                      value: 'fr',
                      child: Text('Français'),
                    ),
                    DropdownMenuItem(
                      value: 'es',
                      child: Text('Español'),
                    ),
                    DropdownMenuItem(
                      value: 'de',
                      child: Text('Deutsch'),
                    ),
                    DropdownMenuItem(
                      value: 'it',
                      child: Text('Italiano'),
                    ),
                    DropdownMenuItem(
                      value: 'tr',
                      child: Text('Türkçe'),
                    ),
                    DropdownMenuItem(
                      value: 'pt',
                      child: Text('Português'),
                    ),
                    DropdownMenuItem(
                      value: 'ja',
                      child: Text('日本語'),
                    ),
                    DropdownMenuItem(
                      value: 'ko',
                      child: Text('한국어'),
                    ),
                    DropdownMenuItem(
                      value: 'zh',
                      child: Text('中文'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context
                          .read<SettingsProvider>()
                          .setLocale(value);
                    }
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Sound
          Container(
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
            ),
            child: SwitchListTile(
              secondary: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.volume_up_rounded,
                  color: colors.primary,
                ),
              ),
              title: Text(
                AppStrings.get('sound', locale),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: settings.soundEnabled,
              onChanged: (value) {
                context
                    .read<SettingsProvider>()
                    .setSoundEnabled(value);
              },
            ),
          ),

          const SizedBox(height: 16),

          // About
          Container(
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              leading: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: colors.primary,
                ),
              ),
              title: Text(
                AppStrings.get('about', locale),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(
                      AppStrings.get('about', locale),
                    ),
                    content: Text(
                      AppStrings.get('about_text', locale),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          AppStrings.get('ok', locale),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
