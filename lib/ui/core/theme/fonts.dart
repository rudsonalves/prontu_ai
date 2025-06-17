import 'package:flutter/material.dart';

class FontsTheme {
  FontsTheme._();

  static const String display = 'Marcellus';
  static const String body = 'Questrial';
}

abstract final class AppFontsStyle {
  const AppFontsStyle();

  /// Font size for display text
  TextStyle get displayTextStyle;

  /// Font size for body text
  TextStyle get bodyTextStyle;

  /// Font size for small text
  TextStyle get bodySmallTextStyle;

  /// Font size for large text
  TextStyle get bodyLargeTextStyle;

  /// Font size for extra large text
  TextStyle get bodyExtraLargeTextStyle;

  /// Font size for extra small text
  TextStyle get bodyExtraSmallTextStyle;

  static const AppFontsStyle desktop = _FontsThemeStyleDesktop();
  static const AppFontsStyle mobile = _FontsThemeStyleMobile();

  /// Get dimensions definition based on screen size
  factory AppFontsStyle.of(BuildContext context) => switch (MediaQuery.sizeOf(
    context,
  ).width) {
    > 600 && < 840 => desktop,
    _ => mobile,
  };
}

/// Font Styles for mobile devices
final class _FontsThemeStyleMobile extends AppFontsStyle {
  const _FontsThemeStyleMobile();

  @override
  TextStyle get bodyExtraSmallTextStyle =>
      const TextStyle(fontFamily: FontsTheme.body, fontSize: 10.0);

  @override
  TextStyle get bodySmallTextStyle =>
      const TextStyle(fontFamily: FontsTheme.body, fontSize: 12.0);

  @override
  TextStyle get bodyTextStyle =>
      const TextStyle(fontFamily: FontsTheme.body, fontSize: 14.0);

  @override
  TextStyle get bodyExtraLargeTextStyle =>
      const TextStyle(fontFamily: FontsTheme.body, fontSize: 22.0);

  @override
  TextStyle get bodyLargeTextStyle =>
      const TextStyle(fontFamily: FontsTheme.body, fontSize: 18.0);

  @override
  TextStyle get displayTextStyle =>
      const TextStyle(fontFamily: FontsTheme.display, fontSize: 20.0);
}

/// Font Styles for desktop devices
final class _FontsThemeStyleDesktop extends AppFontsStyle {
  const _FontsThemeStyleDesktop();

  @override
  TextStyle get bodyExtraSmallTextStyle =>
      const TextStyle(fontFamily: FontsTheme.body, fontSize: 12.0);

  @override
  TextStyle get bodySmallTextStyle =>
      const TextStyle(fontFamily: FontsTheme.body, fontSize: 14.0);

  @override
  TextStyle get bodyTextStyle =>
      const TextStyle(fontFamily: FontsTheme.body, fontSize: 16.0);

  @override
  TextStyle get bodyLargeTextStyle =>
      const TextStyle(fontFamily: FontsTheme.body, fontSize: 18.0);

  @override
  TextStyle get bodyExtraLargeTextStyle =>
      const TextStyle(fontFamily: FontsTheme.body, fontSize: 24.0);

  @override
  TextStyle get displayTextStyle =>
      const TextStyle(fontFamily: FontsTheme.display, fontSize: 24.0);
}
