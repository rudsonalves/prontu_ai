import 'package:flutter/material.dart';

class ToggleButtonsText<T extends Enum> extends StatelessWidget {
  final T? selected;
  final T buttonState;
  final String text;

  const ToggleButtonsText({
    super.key,
    this.selected,
    required this.text,
    required this.buttonState,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selected == buttonState;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        spacing: 6,
        children: [
          if (isSelected) const Icon(Icons.check_rounded),
          Text(
            text,
            style: TextStyle(fontWeight: isSelected ? FontWeight.bold : null),
          ),
        ],
      ),
    );
  }
}
