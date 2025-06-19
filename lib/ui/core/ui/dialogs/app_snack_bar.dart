import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '/ui/core/theme/dimens.dart';
import '/ui/core/theme/fonts.dart';

showSnackError(BuildContext context, String message) {
  AppSnackBar.showBottom(
    context,
    title: 'Erro!',
    iconTitle: Symbols.error_rounded,
    message: message,
    duration: const Duration(seconds: 2),
    isError: true,
  );
}

showSnackSuccess(BuildContext context, String message) {
  AppSnackBar.showBottom(
    context,
    title: 'Sucesso!',
    iconTitle: Symbols.check_rounded,
    message: message,
    duration: const Duration(seconds: 2),
    isError: false,
  );
}

class AppSnackBar {
  static void showBottom(
    BuildContext context, {
    String? title,
    IconData? iconTitle,
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
    VoidCallback? onClosed,
    bool isError = false,
  }) {
    final scaffoldMessager = ScaffoldMessenger.of(context);

    // Remove any existing Snackbar
    scaffoldMessager.clearSnackBars();

    // Create the SnackBar
    final snackBar = _createSnackBar(
      context,
      title: title,
      iconTitle: iconTitle,
      message: message,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      isError: isError,
    );

    final scaffoldController = scaffoldMessager.showSnackBar(snackBar);

    scaffoldController.closed.then((_) {
      if (onClosed != null) onClosed();
    });

    return;
  }

  static SnackBar _createSnackBar(
    BuildContext context, {
    String? title,
    IconData? iconTitle,
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
    required bool isError,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final radius = Dimens.of(context).radius;
    final textStyle = AppFontsStyle.of(context);

    return SnackBar(
      duration: duration,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
      ),
      elevation: 5,
      backgroundColor: isError
          ? colorScheme.onErrorContainer
          : colorScheme.onPrimaryContainer,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) Text(title, style: textStyle.displayTextStyle),
          if (title != null) const Divider(),
          if (iconTitle != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                iconTitle,
                color: isError ? Colors.red : Colors.green,
                size: 64,
              ),
            ),
          Text(message, style: textStyle.bodyTextStyle),
        ],
      ),
      action: (actionLabel != null && onActionPressed != null)
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onActionPressed,
              textColor: colorScheme.onPrimary,
            )
          : null,
    );
  }
}
