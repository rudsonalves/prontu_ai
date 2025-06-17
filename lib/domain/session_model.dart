class SessionModel {
  final String? id;
  final String episodeId;
  final String doctor;
  final String phone;
  final DateTime startDate;
  final String notes;

  SessionModel({
    this.id,
    required this.episodeId,
    required this.doctor,
    required this.phone,
    required this.startDate,
    required this.notes,
  });

  SessionModel copyWith({
    String? id,
    String? episodeId,
    String? doctor,
    String? phone,
    DateTime? startDate,
    String? notes,
  }) {
    return SessionModel(
      id: id ?? this.id,
      episodeId: episodeId ?? this.episodeId,
      doctor: doctor ?? this.doctor,
      phone: phone ?? this.phone,
      startDate: startDate ?? this.startDate,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (id != null) map['id'] = id;
    map['episodeId'] = episodeId;
    map['doctor'] = doctor;
    map['phone'] = phone;
    map['startDate'] = startDate.toIso8601String();
    map['notes'] = notes;
    return map;
  }

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      id: map['id'] as String?,
      episodeId: map['episodeId'] as String,
      doctor: map['doctor'] as String,
      phone: map['phone'] as String,
      startDate: DateTime.parse(map['startDate'] as String),
      notes: map['notes'] as String,
    );
  }
}
