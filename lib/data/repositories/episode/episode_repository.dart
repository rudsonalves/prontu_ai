import 'dart:developer';

import 'package:prontu_ai/data/common/tables.dart';
import 'package:prontu_ai/data/services/database/database_service.dart';

import '/data/repositories/episode/i_episode_repository.dart';
import '/utils/result.dart';

class EpisodeRepository implements IEpisodeRepository {
  final DatabaseService _databaseService;

  EpisodeRepository(this._databaseService);

  bool _started = false;

  @override
  Future<Result<void>> initialize() async {
    try {
      if (_started) return const Result.success(null);

      _started = true;

      return const Result.success(null);
    } on Exception catch (err, stack) {
      log('SessionRepository.initialize', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<void>> delete(String uid) async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      final result = await _databaseService.delete(Tables.sessions, id: uid);

      return result;
    } on Exception catch (err, stack) {
      log('SessionRepository.delete', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }
}
