import 'package:flutter/material.dart';

class MaskedEditingController extends TextEditingController {
  final String mask;
  bool _isApplyingMask = false;

  MaskedEditingController({required this.mask}) {
    addListener(_onValueChanged);
  }

  @override
  set text(String newText) {
    final maskedText = _applyMask(newText);
    final newSelection = TextSelection.fromPosition(
      TextPosition(offset: maskedText.length),
    );
    super.value = super.value.copyWith(
      text: maskedText,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }

  String _applyMask(String text) {
    final buffer = StringBuffer();
    final cText = _cleanString(text);
    int index = 0;
    for (int i = 0; i < mask.length; i++) {
      if (index >= cText.length) break;
      if (mask[i] == '#') {
        buffer.write(cText[index]);
        index++;
      } else {
        buffer.write(mask[i]);
      }
    }
    return buffer.toString();
  }

  String _cleanString(String text) {
    final regex = RegExp(r'[\d]');
    final newText = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      if (regex.hasMatch(char)) {
        newText.write(char);
      }
    }
    return newText.toString();
  }

  void _onValueChanged() {
    if (_isApplyingMask) return;

    _isApplyingMask = true;
    final text = super.text;
    final maskedText = _applyMask(text);
    if (maskedText != text) {
      final newSelection = TextSelection.fromPosition(
        TextPosition(offset: maskedText.length),
      );
      super.value = super.value.copyWith(
        text: maskedText,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    _isApplyingMask = false;
  }
}
