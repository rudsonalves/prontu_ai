// abstract interface class EnumLabel {
//   String get label;
// }

enum Sex {
  male('Masculino'),
  female('Feminino');
  // other('Outro');

  final String label;
  const Sex(this.label);

  static Sex byName(String name) => values.byName(name);
}

enum AttachmentType {
  pdf('pdf'),
  text('texto'),
  image('imagem'),
  other('outro');

  final String label;
  const AttachmentType(this.label);

  static AttachmentType byName(String name) => values.byName(name);
}
