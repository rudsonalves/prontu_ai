import 'dart:developer';

import '/domain/models/ai_summary_model.dart';
import '/data/common/tables.dart';
import '/data/services/database/database_service.dart';
import '/data/repositories/ai_summary/i_ai_summary_repository.dart';
import '/utils/result.dart';

class AiSummaryRepository implements IAiSummaryRepository {
  final DatabaseService _databaseService;

  AiSummaryRepository(this._databaseService);

  bool _started = false;

  final Map<String, AiSummaryModel> _cache = {};

  @override
  List<AiSummaryModel> get aiSummaries => List.unmodifiable(_cache.values);

  @override
  Future<Result<void>> initialize() async {
    try {
      if (_started) return const Result.success(null);

      _started = true;

      return const Result.success(null);
    } on Exception catch (err, stack) {
      log('AiSummaryRepository.initialize', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<AiSummaryModel>> insert(AiSummaryModel aiSummary) async {
    try {
      if (!_started) return throw Exception('Repository not initialized');

      final result = await _databaseService.insert(
        Tables.users,
        aiSummary.toMap(),
      );

      if (result.isFailure) throw Exception('Insert failed');
      _cache[aiSummary.id!] = aiSummary.copyWith(id: result.value!);

      return Result.success(_cache[aiSummary.id!]!);
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
        Tables.users,
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
        Tables.users,
        fromMap: AiSummaryModel.fromMap,
      );

      if (result.isFailure) return result;
      _cache.clear();
      _cache.addAll({for (final user in result.value!) user.id!: user});

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

      if (aiSummary.id == null) {
        throw Exception('User ID must not be null for update');
      }

      final result = await _databaseService.update<AiSummaryModel>(
        Tables.users,
        map: aiSummary.toMap(),
      );

      if (result.isFailure) return result;
      _cache[aiSummary.id!] = aiSummary;

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

      final result = await _databaseService.delete(Tables.aiSummaries, id: uid);

      return result;
    } on Exception catch (err, stack) {
      log('AiSummaryRepository.delete', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }
}
