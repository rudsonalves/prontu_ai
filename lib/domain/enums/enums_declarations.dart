// abstract interface class EnumLabel {
//   String get label;
// }

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

enum Sex {
  male('Masculino'),
  female('Feminino');
  // other('Outro');

  final String label;
  const Sex(this.label);

  static Sex byName(String name) => values.byName(name);
}

enum AttachmentType {
  pdf('pdf', Symbols.picture_as_pdf_rounded),
  text('texto', Symbols.text_fields_rounded),
  image('imagem', Symbols.image_rounded),
  other('outro', Symbols.picture_as_pdf_rounded);

  final String label;
  final IconData iconData;
  const AttachmentType(this.label, this.iconData);

  static AttachmentType byName(String name) => values.byName(name);
}
