import 'package:flutter/material.dart';

import '/ui/core/theme/dimens.dart';
import '/ui/core/theme/fonts.dart';

class BigButton extends StatefulWidget {
  final Color color;
  final String label;
  final VoidCallback? onPressed;
  final FocusNode? focusNode;
  final IconData? iconData;
  final bool isRunning;

  const BigButton({
    super.key,
    required this.color,
    required this.label,
    this.onPressed,
    this.focusNode,
    this.iconData,
    this.isRunning = false,
  });

  @override
  State<BigButton> createState() => _BigButtonState();
}

class _BigButtonState extends State<BigButton> {
  Widget _bigButtonIcon() {
    final colorScheme = Theme.of(context).colorScheme;

    return widget.isRunning
        ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(),
          )
        : Icon(
            widget.iconData,
            size: 24,
            color: widget.onPressed != null ? colorScheme.secondary : null,
          );
  }

  @override
  Widget build(BuildContext context) {
    final fontStyle = AppFontsStyle.of(context);
    final dimens = Dimens.of(context);

    return FilledButton.tonal(
      focusNode: widget.focusNode,
      onPressed: widget.onPressed,
      style: ButtonStyle(
        shape: ButtonStyleButton.allOrNull(
          RoundedRectangleBorder(borderRadius: dimens.borderRadius),
        ),
        backgroundColor: WidgetStateProperty.all(
          widget.color.withValues(alpha: .45),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: dimens.spacingHorizontal / 2,
          children: [
            if (widget.iconData != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _bigButtonIcon(),
              ),
            Text(widget.label, style: fontStyle.bodyLargeTextStyle),
          ],
        ),
      ),
    );
  }
}
