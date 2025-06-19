import 'package:flutter/material.dart';

import '/ui/core/theme/dimens.dart';
import '/ui/core/ui/texts/parse_rich_text.dart';

Future<bool?> showSimpleMessage(
  BuildContext context, {
  IconData? iconTitle,
  required String title,
  required List<String> body,
  List<Widget>? actionButtons,
}) async {
  final colorScheme = Theme.of(context).colorScheme;
  final dimens = Dimens.of(context);

  final contentWidgets = body
      .map((text) => parseRichText(context, text))
      .toList();

  return await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        spacing: dimens.spacingHorizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconTitle != null)
            Icon(iconTitle, color: colorScheme.primary, size: 32),
          Text(title),
        ],
      ),
      // icon:
      //     iconData == null
      //         ? null
      //         : Icon(iconData, color: colorScheme.primary, size: 64),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [const Divider(), ...contentWidgets],
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        if (actionButtons == null || actionButtons.isEmpty)
          FilledButton.icon(
            onPressed: Navigator.of(context).pop,
            label: const Text('Fechar'),
          ),
        if (actionButtons != null && actionButtons.isNotEmpty) ...actionButtons,
      ],
    ),
  );
}
