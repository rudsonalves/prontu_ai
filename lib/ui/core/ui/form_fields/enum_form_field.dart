import 'package:flutter/material.dart';

import '/ui/core/ui/form_fields/widgets/toggle_buttons_text.dart';
import '/ui/core/theme/dimens.dart';

class EnumFormField<T extends Enum> extends FormField<T> {
  EnumFormField({
    super.key,
    super.onSaved,
    super.validator,
    AutovalidateMode super.autovalidateMode =
        AutovalidateMode.onUserInteraction,
    this.title,
    required this.values,
    required this.labelBuilder,
    this.onChanged,
    super.initialValue,
  }) : super(
         builder: (state) {
           final dimens = Dimens.of(state.context);
           final colorScheme = Theme.of(state.context).colorScheme;

           return Center(
             child: Column(
               children: [
                 if (title != null) Text(title),
                 ToggleButtons(
                   borderRadius: dimens.borderRadius,
                   borderWidth: 2,
                   isSelected: values.map((e) => e == state.value).toList(),
                   onPressed: (index) {
                     final newValue = values[index];
                     state.didChange(newValue);
                     onChanged?.call(newValue);
                   },
                   children: values
                       .map(
                         (e) => ToggleButtonsText(
                           selected: state.value,
                           text: labelBuilder(e),
                           buttonState: e,
                         ),
                       )
                       .toList(),
                 ),
                 if (state.hasError)
                   Padding(
                     padding: const EdgeInsets.only(top: 8),
                     child: Text(
                       state.errorText!,
                       style: TextStyle(color: colorScheme.error, fontSize: 12),
                     ),
                   ),
               ],
             ),
           );
         },
       );

  final List<T> values;
  final String? title;
  final ValueChanged<T?>? onChanged;
  final String Function(T value) labelBuilder;

  @override
  FormFieldState<T> createState() => _EnumFormFieldState<T>();
}

class _EnumFormFieldState<T> extends FormFieldState<T> {
  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      setValue(widget.initialValue);
    }
  }

  @override
  void didUpdateWidget(covariant FormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
  }
}
