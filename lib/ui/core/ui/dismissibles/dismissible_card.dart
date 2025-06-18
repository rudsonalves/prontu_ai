import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '/ui/core/theme/dimens.dart';
import '/ui/core/ui/dismissibles/dismissible_container.dart';

class DismissibleCard<T> extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? leading;
  final Widget? trailing;
  final T value;
  final void Function(T value) editFunction;
  final Future<bool> Function(T value) removeFunction;
  final void Function()? onTap;

  const DismissibleCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.leading,
    this.trailing,
    required this.value,
    required this.editFunction,
    required this.removeFunction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: dimens.spacingVertical * 2),
      child: Dismissible(
        key: UniqueKey(),
        background: dismissibleContainer(
          context,
          alignment: Alignment.centerLeft,
          color: Colors.green.withValues(alpha: 0.45),
          icon: Symbols.edit_square_rounded,
          label: 'Editar',
        ),
        secondaryBackground: dismissibleContainer(
          context,
          alignment: Alignment.centerRight,
          color: Colors.red.withValues(alpha: 0.45),
          icon: Symbols.delete_rounded,
          label: 'Remover',
        ),
        child: Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            leading: leading,
            trailing: trailing,
            onTap: onTap,
          ),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            editFunction(value);
            return false;
          } else if (direction == DismissDirection.endToStart) {
            return await removeFunction(value);
          }

          return false;
        },
      ),
    );
  }
}
