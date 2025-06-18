class EpisodeModel {
  final String? id; // pode ser nulo pois nao teremos essa info logo de cara
  final String userId;
  final String title;
  final int weight; // gramas
  final int height; // cm
  final String mainComplaint; // motivo da consulta
  final String history; // histórico atual
  final String anamnesis; // histórico clínico geral
  final DateTime createdAt;
  final DateTime updatedAt;

  EpisodeModel({
    this.id,
    required this.userId,
    required this.title,
    required this.weight,
    required this.height,
    required this.mainComplaint,
    required this.history,
    required this.anamnesis,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  EpisodeModel copyWith({
    String? id,
    String? title,
    int? weight,
    int? height,
    String? mainComplaint,
    String? history,
    String? anamnesis,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EpisodeModel(
      id: id ?? this.id,
      userId: userId,
      title: title ?? this.title,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      mainComplaint: mainComplaint ?? this.mainComplaint,
      history: history ?? this.history,
      anamnesis: anamnesis ?? this.anamnesis,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (id != null) map['id'] = id;

    map['user_id'] = userId;
    map['title'] = title;
    map['weight'] = weight;
    map['height'] = height;
    map['main_complaint'] = mainComplaint;
    map['history'] = history;
    map['anamnesis'] = anamnesis;
    map['created_at'] = createdAt.toIso8601String();
    map['updated_at'] = updatedAt.toIso8601String();

    return map; //retorna o map com todos os dados convertidos
  }

  factory EpisodeModel.fromMap(Map<String, dynamic> map) {
    //recebe os dados como map e retorna um novo
    return EpisodeModel(
      id: map['id'] as String?,
      userId: map['user_id'] as String,
      title: map['title'] as String,
      weight: map['weight']?.toInt() as int,
      height: map['height']?.toInt() as int,
      mainComplaint: map['main_complaint'] as String,
      history: map['history'] as String,
      anamnesis: map['anamnesis'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}
