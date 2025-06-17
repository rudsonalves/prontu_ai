enum AttachmentType {
  pdf('pdf'),
  text('texto'),
  image('imagem'),
  other('outro');

  final String label;
  const AttachmentType(this.label);

  static AttachmentType byName(String name) => byName(name);
}

class AttachmentModel {
  final String? id;
  final String sessionId;
  final String path;
  final AttachmentType type;
  final DateTime createdAt;

  AttachmentModel({
    this.id,
    required this.sessionId,
    required this.path,
    required this.type,
    required this.createdAt,
  });

  AttachmentModel copyWith({
    String? id,
    String? sessionId,
    String? path,
    AttachmentType? type,
    DateTime? createdAt,
  }) {
    return AttachmentModel(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      path: path ?? this.path,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (id != null) map['id'] = id;

    map['session_id'] = sessionId;
    map['path'] = path;
    map['type'] = type.name;
    map['created_at'] = createdAt.toIso8601String();

    return map;
  }

  factory AttachmentModel.fromMap(Map<String, dynamic> map) {
    return AttachmentModel(
      id: map['id'] as String?,
      sessionId: map['session_id'] as String,
      path: map['path'] as String,
      type: AttachmentType.byName(map['type'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
