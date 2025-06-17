class AISummaryModel {
  final String? id;
  final String episodeId;
  final String summary;
  final DateTime date;

  AISummaryModel({
    this.id,
    required this.episodeId,
    required this.summary,
    required this.date,
  });

  AISummaryModel copyWith({
    String? id,
    String? episodeId,
    String? summary,
    DateTime? date,
  }) {
    return AISummaryModel(
      id: id ?? this.id,
      episodeId: episodeId ?? this.episodeId,
      summary: summary ?? this.summary,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (id != null) map['id'] = id;
    map['episodeId'] = episodeId;
    map['summary'] = summary;
    map['date'] = date.toIso8601String();
    return map;
  }

  factory AISummaryModel.fromMap(Map<String, dynamic> map) {
    return AISummaryModel(
      id: map['id'] as String?,
      episodeId: map['episodeId'] as String,
      summary: map['summary'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }
}
