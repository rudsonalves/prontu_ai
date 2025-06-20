class AiSummaryModel {
  final String? id;
  final String episodeId;
  final String summary;
  final String specialist;
  final DateTime createdAt;

  AiSummaryModel({
    this.id,
    required this.episodeId,
    required this.summary,
    required this.specialist,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  AiSummaryModel copyWith({
    String? id,
    String? episodeId,
    String? summary,
    String? specialist,
    DateTime? createdAt,
  }) {
    return AiSummaryModel(
      id: id ?? this.id,
      episodeId: episodeId ?? this.episodeId,
      summary: summary ?? this.summary,
      specialist: specialist ?? this.specialist,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (id != null) map['id'] = id;

    map['episode_id'] = episodeId;
    map['summary'] = summary;
    map['specialist'] = specialist;
    map['created_at'] = createdAt.toIso8601String();

    return map;
  }

  factory AiSummaryModel.fromMap(Map<String, dynamic> map) {
    return AiSummaryModel(
      id: map['id'] as String?,
      episodeId: map['episode_id'] as String,
      summary: map['summary'] as String,
      specialist: map['specialist'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
