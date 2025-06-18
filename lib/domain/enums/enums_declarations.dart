abstract interface class EnumLabel {
  String get label;
}

enum Sex implements EnumLabel {
  male('Masculino'),
  female('Feminino');
  // other('Outro');

  @override
  final String label;
  const Sex(this.label);

  static Sex byName(String name) => values.byName(name);
}
