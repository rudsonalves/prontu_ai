import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '/ui/core/ui/form_fields/basic_form_field.dart';
import '/utils/extensions/date_time_extensions.dart';
import '/ui/core/theme/dimens.dart';

class DateFormatField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final void Function(DateTime)? onDatePicked;
  final String? Function(String? value)? validator;
  final void Function(String value)? onChanged;

  DateFormatField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.onDatePicked,
    this.onChanged,
    this.validator,
    this.prefixIcon = Symbols.calendar_month_rounded,
    this.prefixIconColor,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) : initialDate = initialDate ?? DateTime.now(),
       firstDate = firstDate ?? DateTime(1900),
       lastDate = lastDate ?? DateTime(DateTime.now().year + 24);

  @override
  State<DateFormatField> createState() => _DateFormatFieldState();
}

class _DateFormatFieldState extends State<DateFormatField> {
  DateTime? _selectedDate;

  @override
  void initState() {
    _selectedDate = widget.initialDate;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(dimens.radius),
      onTap: _pickDate,
      child: AbsorbPointer(
        child: BasicFormField(
          labelText: widget.labelText,
          hintText: widget.hintText,
          controller: widget.controller,
          validator: widget.validator,
          onChanged: widget.onChanged,
          prefixIconData: widget.prefixIcon,
          iconColor: widget.prefixIconColor ?? colorScheme.primary,
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final pickDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? widget.initialDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (pickDate != null && pickDate != _selectedDate) {
      setState(() {
        _selectedDate = pickDate;
        final strDate = pickDate.toDDMMYYYY();
        widget.controller.text = strDate;
        widget.onDatePicked?.call(pickDate);
        widget.onChanged?.call(strDate);
      });
    }
  }
}
