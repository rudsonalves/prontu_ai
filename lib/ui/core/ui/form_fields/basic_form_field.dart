import 'package:flutter/material.dart';

import '/ui/core/theme/dimens.dart';

class BasicFormField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final FloatingLabelBehavior floatingLabelBehavior;
  final InputBorder? border;
  final TextEditingController? controller;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final IconData? suffixIconData;
  final IconData? prefixIconData;
  final Color? iconColor;
  final bool obscureText;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final String? Function(String?)? validator;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;

  const BasicFormField({
    super.key,
    this.labelText,
    this.hintText,
    this.floatingLabelBehavior = FloatingLabelBehavior.always,
    this.border,
    this.controller,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.keyboardType,
    this.suffixIconData,
    this.prefixIconData,
    this.iconColor,
    this.obscureText = false,
    this.onChanged,
    this.focusNode,
    this.nextFocusNode,
    this.onEditingComplete,
    this.validator,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
  });

  @override
  State<BasicFormField> createState() => _BasicFormFieldState();
}

class _BasicFormFieldState extends State<BasicFormField> {
  AutovalidateMode? autoValidate;

  @override
  void initState() {
    widget.controller?.addListener(_checkValidation);
    super.initState();
  }

  void _checkValidation() {
    if (autoValidate != null || widget.controller!.text.isEmpty) return;

    setState(() {
      autoValidate = AutovalidateMode.always;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Dimens dimens = Dimens.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      autovalidateMode: autoValidate,
      controller: widget.controller,
      focusNode: widget.focusNode,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      validator: widget.validator,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      onFieldSubmitted: (value) {
        if (widget.nextFocusNode != null) {
          FocusScope.of(context).requestFocus(widget.nextFocusNode);
        }
      },
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        floatingLabelBehavior: widget.floatingLabelBehavior,
        border:
            widget.border ??
            OutlineInputBorder(
              borderRadius: dimens.borderRadius,
              borderSide: BorderSide(color: colorScheme.onPrimary),
            ),
        suffixIcon: Icon(
          widget.suffixIconData,
          color: widget.iconColor ?? colorScheme.primary,
        ),
        prefixIcon: Icon(
          widget.prefixIconData,
          color: widget.iconColor ?? colorScheme.primary,
        ),
      ),
    );
  }
}
