import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool soundEnabled = true;
  String locale = 'en';

  SettingsProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    soundEnabled = prefs.getBool('sound_enabled') ?? true;
    locale = prefs.getString('locale') ?? 'en';
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool value) async {
    soundEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', value);
  }

  Future<void> setLocale(String value) async {
    locale = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', value);
  }
}
