class EpisodeModel {
  final String? id; // pode ser nulo pois nao teremos essa info logo de cara
  final String userId;
  final String title;
  final int weight; //gramas
  final int height; //cm
  final String mainComplaint; //motivo da consulta
  final String currentHistory; //histórico atual
  final String anamnesis; //histórico clínico geral
  final DateTime? createdAt; //nulable?????
  final DateTime updatedAt;

  EpisodeModel({
    this.id,
    required this.userId,
    required this.title,
    required this.weight,
    required this.height,
    required this.mainComplaint,
    required this.currentHistory,
    required this.anamnesis,
    this.createdAt,
    required this.updatedAt,
  });

//não add o created pq ele nao poderá ser modificado
  EpisodeModel copyWith({
    String? id,
    String? userId,
    String? title,
    int? weight,
    int? height,
    String? mainComplaint,
    String? currentHistory,
    String? anamnesis,
    DateTime? updatedAt,
  }) { return EpisodeModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    weight: weight ?? this.weight,
    height: height ?? this.height,
    mainComplaint: mainComplaint ?? this.mainComplaint,
    currentHistory: currentHistory ?? this.currentHistory,
    anamnesis: anamnesis ?? this.anamnesis,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

Map<String, dynamic>toMap(){
  final map = <String, dynamic>{}; //cria um mapa vazio pra add os dados do objeto
  if(id != null){
    map['id'] = id;
  }
  map['userId'] = userId;
  map['title'] = title;
  map['weight'] = weight;
  map['height'] = height;
  map['mainComplaint'] = mainComplaint;
  map['currentHistory'] = currentHistory;
  map['anamnesis'] = anamnesis;
  map['updatedAt'] = updatedAt.toIso8601String();

  return map; //retorna o map com todos os dados convertidos
}

factory EpisodeModel.fromMap(Map<String, dynamic> map) { //recebe os dados como map e retorna um novo
  return EpisodeModel(
    id: map['id'] as String?, //conversão pra string
    userId: map['userId'] as String,
    title: map['title'] as String,
    weight: map['weight'] as int,
    height: map['height'] as int,
    mainComplaint: map['mainComplaint'] as String,
    currentHistory: map['currentHistory'] as String,
    anamnesis: map['anamnesis'] as String,
    updatedAt: DateTime.parse(map['updateAt'] as String,
  ));
}
}