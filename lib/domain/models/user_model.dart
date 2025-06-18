import '/domain/enums/enums_declarations.dart';

class UserModel {
  final String? id;
  final String name;
  final DateTime birthDate;
  final Sex sex;

  UserModel({
    this.id,
    required this.name,
    required this.birthDate,
    required this.sex,
  });

  UserModel copyWith({
    String? id,
    String? name,
    DateTime? birthDate,
    Sex? sex,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      sex: sex ?? this.sex,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (id != null) map['id'] = id;

    map['name'] = name;
    map['birth_date'] = birthDate.toIso8601String();
    map['sex'] = sex.name;

    return map;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String?,
      name: map['name'] as String,
      birthDate: DateTime.parse(map['birth_date'] as String),
      sex: Sex.byName(map['sex'] as String),
    );
  }
}
