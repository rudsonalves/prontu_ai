enum AttachmentType { pdf, text, image, other }

class AttachmentModel {
  final String? id;
  final String sessionId;
  final String name;
  final String path;
  final AttachmentType type;

  AttachmentModel({
    this.id,
    required this.sessionId,
    required this.name,
    required this.path,
    required this.type,
  });

  AttachmentModel copyWith({
    String? id,
    String? sessionId,
    String? name,
    String? path,
    AttachmentType? type,
  }) {
    return AttachmentModel(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      name: name ?? this.name,
      path: path ?? this.path,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (id != null) map['id'] = id;
    map['sessionId'] = sessionId;
    map['name'] = name;
    map['path'] = path;
    map['type'] = type.name;
    return map;
  }

  factory AttachmentModel.fromMap(Map<String, dynamic> map) {
    return AttachmentModel(
      id: map['id'] as String?,
      sessionId: map['sessionId'] as String,
      name: map['name'] as String,
      path: map['path'] as String,
      type: AttachmentType.values.byName(map['type'] as String),
    );
  }
}
