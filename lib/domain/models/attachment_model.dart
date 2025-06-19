import '/domain/enums/enums_declarations.dart';

class AttachmentModel {
  final String? id;
  final String sessionId;
  final String name;
  final String path;
  final AttachmentType type;
  final DateTime createdAt;

  AttachmentModel({
    this.id,
    required this.sessionId,
    required this.name,
    required this.path,
    required this.type,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  AttachmentModel copyWith({
    String? id,
    String? sessionId,
    String? name,
    String? path,
    AttachmentType? type,
    DateTime? createdAt,
  }) {
    return AttachmentModel(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      name: name ?? this.name,
      path: path ?? this.path,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (id != null) map['id'] = id;

    map['session_id'] = sessionId;
    map['name'] = name;
    map['path'] = path;
    map['type'] = type.name;
    map['created_at'] = createdAt.toIso8601String();

    return map;
  }

  factory AttachmentModel.fromMap(Map<String, dynamic> map) {
    return AttachmentModel(
      id: map['id'] as String?,
      sessionId: map['session_id'] as String,
      name: map['name'] as String,
      path: map['path'] as String,
      type: AttachmentType.byName(map['type'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
