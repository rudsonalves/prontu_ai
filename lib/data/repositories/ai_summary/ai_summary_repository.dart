import 'dart:developer';

import '/domain/models/episode_model.dart';
import '/data/services/open_ia/open_ia_service.dart';
import '/domain/models/ai_summary_model.dart';
import '../../common/table_names.dart';
import '/data/services/database/database_service.dart';
import '/data/repositories/ai_summary/i_ai_summary_repository.dart';
import '/utils/result.dart';

class AiSummaryRepository implements IAiSummaryRepository {
  final DatabaseService _databaseService;
  final OpenIaService _openIaService;

  AiSummaryRepository({
    required DatabaseService databaseService,
    required OpenIaService openIaService,
  }) : _databaseService = databaseService,
       _openIaService = openIaService;

  bool _started = false;

  final Map<String, AiSummaryModel> _cache = {};

  @override
  List<AiSummaryModel> get aiSummaries => List.unmodifiable(_cache.values);

  @override
  Future<Result<void>> initialize() async {
    try {
      if (_started) return const Result.success(null);

      _started = true;

      final result = await fetchAll();
      if (result.isFailure) return result;

      final aiResult = await _openIaService.initialize();

      return aiResult;
    } on Exception catch (err, stack) {
      log('AiSummaryRepository.initialize', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<AiSummaryModel>> analiseEpisode(EpisodeModel episode) async {
    if (!_started) return throw Exception('Repository not initialized');

    try {
      if (_cache.containsKey(episode.id!)) {
        return Result.success(_cache[episode.id!]!);
      }

      final result = await _openIaService.analyze(episode);
      if (result.isFailure) return Result.failure(result.error!);

      final analyse = result.value!;

      final aiSummary = AiSummaryModel(
        id: episode.id!,
        summary: analyse.clinicalSummary,
        specialist: analyse.recommendedSpecialist,
      );

      _cache[aiSummary.id] = aiSummary;

      return await insert(aiSummary);
    } on Exception catch (err, stack) {
      log('AiSummaryRepository.analiseEpisode', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<AiSummaryModel>> insert(AiSummaryModel aiSummary) async {
    try {
      if (!_started) return throw Exception('Repository not initialized');

      final result = await _databaseService.set(
        TableNames.aiSummaries,
        aiSummary.toMap(),
      );

      if (result.isFailure) throw Exception('Insert failed');

      _cache[aiSummary.id] = aiSummary;

      return Result.success(aiSummary);
    } on Exception catch (err, stack) {
      log('AiSummaryRepository.insert', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<AiSummaryModel>> fetch(
    String uid, [
    bool forceRemote = false,
  ]) async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      if (_cache.containsKey(uid) && !forceRemote) {
        return Result.success(_cache[uid]!);
      }

      final result = await _databaseService.fetch<AiSummaryModel>(
        TableNames.aiSummaries,
        id: uid,
        fromMap: AiSummaryModel.fromMap,
      );

      if (result.isFailure) return result;
      _cache[uid] = result.value!;

      return result;
    } on Exception catch (err, stack) {
      log('AiSummaryRepository.fetch', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<List<AiSummaryModel>>> fetchAll() async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      final result = await _databaseService.fetchAll<AiSummaryModel>(
        TableNames.aiSummaries,
        fromMap: AiSummaryModel.fromMap,
      );

      if (result.isFailure) return result;
      _cache.clear();
      _cache.addAll({for (final user in result.value!) user.id: user});

      return result;
    } on Exception catch (err, stack) {
      log('AiSummaryRepository.fetchAll', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<void>> update(AiSummaryModel aiSummary) async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      final result = await _databaseService.update<AiSummaryModel>(
        TableNames.aiSummaries,
        map: aiSummary.toMap(),
      );

      if (result.isFailure) return result;
      _cache[aiSummary.id] = aiSummary;

      return result;
    } on Exception catch (err, stack) {
      log('AiSummaryRepository.update', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<void>> delete(String uid) async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      final result = await _databaseService.delete(
        TableNames.aiSummaries,
        id: uid,
      );

      return result;
    } on Exception catch (err, stack) {
      log('AiSummaryRepository.delete', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }
}
