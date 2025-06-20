import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/ui/core/ui/texts/parse_rich_text.dart';
import '/ui/core/theme/dimens.dart';
import '/ui/core/theme/fonts.dart';

class ButtonSignature<T> {
  final String label;
  final IconData? iconData;
  final T Function()? onPressed;

  ButtonSignature({
    required this.label,
    this.iconData,
    required this.onPressed,
  });
}

class BottonSheetMessage<T> extends StatefulWidget {
  final String title;
  final List<String> body;
  final void Function()? onClosing;
  final List<ButtonSignature<T>>? buttons;

  const BottonSheetMessage({
    super.key,
    required this.title,
    required this.body,
    this.onClosing,
    this.buttons,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required List<String> body,
    void Function()? onClosing,
    List<ButtonSignature<T>>? buttons,
  }) async {
    final dimens = Dimens.of(context);
    final height = MediaQuery.of(context).size.height;

    return await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(dimens.radius),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: height * .95,
      ),
      builder: (context) => BottonSheetMessage<T>(
        title: title,
        body: body,
        onClosing: onClosing,
        buttons: buttons,
      ),
    );
  }

  @override
  State<BottonSheetMessage<T>> createState() => _BottonSheetMessageState<T>();
}

class _BottonSheetMessageState<T> extends State<BottonSheetMessage<T>> {
  List<Widget> bodytoText() {
    return widget.body
        .map(
          (item) => parseRichText(
            context,
            item,
          ),
        )
        .toList();
  }

  List<Widget> androidButtonList() {
    final fonts = AppFontsStyle.of(context);

    return widget.buttons!
        .map(
          (button) => TextButton.icon(
            onPressed: () {
              final result = button.onPressed?.call();

              if (result != null) {
                Navigator.pop<T>(context, result);
              }
            },
            label: Text(
              button.label,
              style: Platform.isAndroid ? fonts.bodyTextStyle : null,
            ),
            icon: button.iconData != null ? Icon(button.iconData) : null,
          ),
        )
        .toList();
  }

  List<Widget> cupertinoButtonList() {
    return widget.buttons!
        .map(
          (button) => CupertinoActionSheetAction(
            onPressed: () {
              final result = button.onPressed?.call();

              if (result != null) {
                Navigator.pop<T>(context, result);
              }
            },
            child: Text(button.label),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fonts = AppFontsStyle.of(context);

    return BottomSheet(
      onClosing: widget.onClosing ?? () {},
      builder: (context) {
        if (Platform.isAndroid) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    widget.title,
                    style: fonts.bodyLargeTextStyle.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(child: Column(children: bodytoText())),
                ),
                const Divider(),
                if (widget.buttons != null)
                  Center(child: Wrap(children: androidButtonList())),
              ],
            ),
          );
        }
        return CupertinoActionSheet(
          title: Text(widget.title),
          actions: [
            ...bodytoText(),
            if (widget.buttons != null) ...cupertinoButtonList(),
          ],
        );
      },
    );
  }
}
