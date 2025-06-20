class AiSummaryModel {
  final String id;
  final String summary;
  final String specialist;
  final DateTime createdAt;

  AiSummaryModel({
    required this.id,
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
      summary: summary ?? this.summary,
      specialist: specialist ?? this.specialist,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    map['id'] = id;
    map['summary'] = summary;
    map['specialist'] = specialist;
    map['created_at'] = createdAt.toIso8601String();

    return map;
  }

  factory AiSummaryModel.fromMap(Map<String, dynamic> map) {
    return AiSummaryModel(
      id: map['id'] as String,
      summary: map['summary'] as String,
      specialist: map['specialist'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
