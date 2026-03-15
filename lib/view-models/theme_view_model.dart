import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeViewModel extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  ThemeMode _themeMode = ThemeMode.system;

  ThemeViewModel() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  Future<void> _loadTheme() async {
    final theme = await _storage.read(key: 'themeMode');
    if (theme != null) {
      _themeMode = ThemeMode.values.byName(theme);
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _storage.write(key: 'themeMode', value: mode.name);
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }
}
