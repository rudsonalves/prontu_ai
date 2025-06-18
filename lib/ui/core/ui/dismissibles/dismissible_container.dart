import 'package:flutter/material.dart';

import '/ui/core/theme/fonts.dart';

Container dismissibleContainer(
  BuildContext context, {
  required AlignmentGeometry alignment,
  Color? color,
  IconData? icon,
  String? label,
  bool enable = true,
}) {
  List<Alignment> alignLeft = [
    Alignment.bottomLeft,
    Alignment.topLeft,
    Alignment.centerLeft,
  ];

  final colorScheme = Theme.of(context).colorScheme;
  final appFont = AppFontsStyle.of(context);
  late Widget rowIcon;

  if (label != null) {
    if (alignLeft.contains(alignment)) {
      rowIcon = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: enable
                ? colorScheme.onPrimaryContainer
                : colorScheme.outline,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: appFont.bodyTextStyle.copyWith(
              color: enable
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.outline,
            ),
          ),
        ],
      );
    } else {
      rowIcon = Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            label,
            style: appFont.bodyTextStyle
              ..copyWith(
                color: enable
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.outline,
              ),
          ),
          const SizedBox(width: 8),
          Icon(
            icon,
            color: enable
                ? colorScheme.onPrimaryContainer
                : colorScheme.outline,
          ),
        ],
      );
    }
  } else {
    rowIcon = Icon(icon);
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 18),
    alignment: alignment,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(16),
    ),
    child: rowIcon,
  );
}
