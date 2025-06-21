import '/app_theme_mode.dart';

class SplashViewModel {
  final AppThemeMode _themeMode;

  SplashViewModel({
    required AppThemeMode themeMode,
  }) : _themeMode = themeMode;

  bool get isDark => _themeMode.isDark;
}
