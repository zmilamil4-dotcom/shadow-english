import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'state/app_state_provider.dart';
import 'state/settings_provider.dart';
import 'utils/theme.dart';

void main() {
  runApp(const EchoSpeakApp());
}

class EchoSpeakApp extends StatelessWidget {
  const EchoSpeakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
      ],
      child: MaterialApp(
        title: 'EchoSpeak',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashScreen(),
      ),
    );
  }
}
