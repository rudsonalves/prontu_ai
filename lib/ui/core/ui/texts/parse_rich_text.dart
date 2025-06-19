import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '/ui/core/theme/fonts.dart';

/// Parses a string and applies bold (**) and italic (*) formatting to it.
Widget parseRichText(BuildContext context, String text) {
  final fontColor = Theme.of(context).colorScheme.onSurface;
  final appFonts = AppFontsStyle.of(context);
  final spans = <TextSpan>[];
  final regex = RegExp(r'\*\*(.*?)\*\*|\*(.*?)\*|(.+?)');

  if (text.isEmpty) return const Text('');
  final processText = text.startsWith(RegExp(r'^[\-><]'))
      ? text.substring(1).trim()
      : text.trim();

  for (final match in regex.allMatches(processText)) {
    if (match.group(1) != null) {
      // Bold (**text**)
      spans.add(
        TextSpan(
          text: match.group(1),
          style: appFonts.bodyTextStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: fontColor,
          ),
        ),
      );
    } else if (match.group(2) != null) {
      // Italic (*text*)
      spans.add(
        TextSpan(
          text: match.group(2),
          style: appFonts.bodyTextStyle.copyWith(
            fontStyle: FontStyle.italic,
            color: fontColor,
          ),
        ),
      );
    } else if (match.group(3) != null) {
      // Normal text
      spans.add(
        TextSpan(
          text: match.group(3),
          style: appFonts.bodyTextStyle.copyWith(color: fontColor),
        ),
      );
    }
  }

  final ritchText = RichText(
    text: TextSpan(
      children: spans,
      style: appFonts.bodyTextStyle.copyWith(color: fontColor),
    ),
  );

  Widget? icon;
  switch (text.trim()[0]) {
    case '-':
      icon = const Icon(Symbols.check_rounded, color: Colors.green, size: 18);
      break;
    case '>':
      icon = const Icon(Symbols.east_rounded, color: Colors.green, size: 18);
      break;
    case '<':
      icon = const Icon(Symbols.west_rounded, color: Colors.red, size: 18);
      break;
  }

  return (icon != null)
      ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.only(right: 6), child: icon),
            Expanded(child: ritchText),
          ],
        )
      : ritchText;
}
