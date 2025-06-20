import 'package:flutter/material.dart';

abstract final class Dimens {
  const Dimens();

  /// General padding used to separate UI items
  static const paddingAll = 12.0;

  /// General horizontal padding used to separate UI items
  static const paddingHorizontal = 16.0;

  /// General vertical padding used to separate UI items
  static const paddingVertical = 18.0;

  /// Padding for screen edges
  double get paddingScreenAll;

  /// Horizontal padding for screen edges
  double get paddingScreenHorizontal;

  /// Vertical padding for screen edges
  double get paddingScreenVertical;

  /// Vertical spacing between items
  double get spacingVertical;

  /// Horizontal spacing between items
  double get spacingHorizontal;

  /// Size of the profile picture
  double get profilePictureSize;

  ///
  double get radius;

  /// Outline circule border radius
  BorderRadius get borderRadius;

  /// Horizontal symmetric padding for screen edges
  EdgeInsets get edgeInsetsScreenHorizontal =>
      EdgeInsets.symmetric(horizontal: paddingScreenHorizontal);

  /// Symmetric padding for screen edges
  EdgeInsets get edgeInsetsScreenSymmetric => EdgeInsets.symmetric(
    horizontal: paddingScreenHorizontal,
    vertical: paddingScreenVertical,
  );

  static const Dimens desktop = _DimensDesktop();
  static const Dimens mobile = _DimensMobile();

  /// Get dimensions definition based on screen size
  factory Dimens.of(BuildContext context) => switch (MediaQuery.sizeOf(
    context,
  ).width) {
    > 600 && < 840 => desktop,
    _ => mobile,
  };
}

/// Mobile dimensions
final class _DimensMobile extends Dimens {
  @override
  final double paddingScreenAll = Dimens.paddingAll;

  @override
  final double paddingScreenHorizontal = Dimens.paddingHorizontal;

  @override
  final double paddingScreenVertical = Dimens.paddingVertical;

  @override
  final double profilePictureSize = 64.0;

  @override
  final double spacingVertical = 6.0;

  @override
  final double spacingHorizontal = 8.0;

  const _DimensMobile();

  @override
  double get radius => 12.0;

  @override
  BorderRadius get borderRadius => BorderRadius.circular(radius);
}

/// Desktop/Web dimensions
final class _DimensDesktop extends Dimens {
  @override
  final double paddingScreenAll = Dimens.paddingAll;

  @override
  final double paddingScreenHorizontal = 100.0;

  @override
  final double paddingScreenVertical = 64.0;

  @override
  final double profilePictureSize = 128.0;

  @override
  final double spacingVertical = 12.0;

  @override
  final double spacingHorizontal = 8.0;

  @override
  double get radius => 12.0;

  const _DimensDesktop();

  @override
  BorderRadius get borderRadius => BorderRadius.circular(radius);
}
