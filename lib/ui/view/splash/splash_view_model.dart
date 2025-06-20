import 'package:flutter/material.dart';
import '/app_theme_mode.dart';

class SplashViewModel extends ChangeNotifier {
  final AppThemeMode _themeMode;

  SplashViewModel({required AppThemeMode themeMode}) : _themeMode = themeMode {
    _themeMode.addListener(_onThemeChanged);
  }

  ChangeNotifier get themeMode => _themeMode;

  bool get isDark => _themeMode.isDark;

  void toggleTheme() => _themeMode.toggle();

  void _onThemeChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _themeMode.removeListener(_onThemeChanged);
    super.dispose();
  }
}
