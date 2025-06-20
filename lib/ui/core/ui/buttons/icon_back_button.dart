import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class IconBackButton extends StatelessWidget {
  const IconBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Symbols.arrow_back_ios_new_rounded),
    );
  }
}
