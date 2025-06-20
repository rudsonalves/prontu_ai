import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrencyEditingController extends TextEditingController {
  final NumberFormat _formatter;
  final int decimalDigits;
  bool _isApplyingMask = false;

  CurrencyEditingController({String locale = 'pt_BR', this.decimalDigits = 2})
    : _formatter = NumberFormat.currency(
        locale: locale,
        symbol: '',
        decimalDigits: decimalDigits,
      ) {
    addListener(_onTextChanged);
  }

  @override
  set text(String newText) {
    final formattedText = _applyMask(newText);
    final newSelection = TextSelection.fromPosition(
      TextPosition(offset: formattedText.length),
    );
    super.value = super.value.copyWith(
      text: formattedText,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }

  String _applyMask(String text) {
    final cleanedText = _cleanString(text);
    final value = double.tryParse(cleanedText) ?? 0.0;
    return _formatter.format(value / _getDivisionFactor());
  }

  String _cleanString(String text) {
    return text.replaceAll(RegExp(r'[^0-9]'), '');
  }

  double get currencyValue {
    final cleanedText = _cleanString(text);
    final value = double.tryParse(cleanedText) ?? 0.0;
    return value / _getDivisionFactor();
  }

  set currencyValue(double value) {
    text = value.toStringAsFixed(decimalDigits);
  }

  void _onTextChanged() {
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

  double _getDivisionFactor() {
    return pow(10, decimalDigits).toDouble();
  }
}
