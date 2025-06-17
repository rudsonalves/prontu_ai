class SessionModel {
  final String? id;
  final String episodeId;
  final String doctor;
  final String phone;
  final String notes;
  final DateTime createdAt;

  SessionModel({
    DateTime? createdAt,
    this.id,
    required this.episodeId,
    required this.doctor,
    required this.phone,
    required this.notes,
  }) : createdAt = createdAt ?? DateTime.now();

  SessionModel copyWith({
    String? id,
    String? episodeId,
    String? doctor,
    String? phone,
    String? notes,
    DateTime? createdAt,
  }) {
    return SessionModel(
      id: id ?? this.id,
      episodeId: episodeId ?? this.episodeId,
      doctor: doctor ?? this.doctor,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (id != null) map['id'] = id;

    map['episode_id'] = episodeId;
    map['doctor'] = doctor;
    map['phone'] = phone;
    map['notes'] = notes;
    map['created_at'] = createdAt.toIso8601String();

    return map;
  }

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      id: map['id'] as String?,
      episodeId: map['episode_id'] as String,
      doctor: map['doctor'] as String,
      phone: map['phone'] as String,
      notes: map['notes'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
