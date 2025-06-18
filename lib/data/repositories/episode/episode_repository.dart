import 'dart:developer';

import '../../common/table_names.dart';
import '/data/services/database/database_service.dart';
import '/domain/models/episode_model.dart';
import '/data/repositories/episode/i_episode_repository.dart';
import '/utils/result.dart';

class EpisodeRepository implements IEpisodeRepository {
  final DatabaseService _databaseService;

  EpisodeRepository(this._databaseService);

  bool _started = false;

  final Map<String, EpisodeModel> _cache = {};

  @override
  List<EpisodeModel> get episodes => List.unmodifiable(_cache.values);

  @override
  Future<Result<void>> initialize() async {
    try {
      if (_started) return const Result.success(null);

      _started = true;

      return const Result.success(null);
    } on Exception catch (err, stack) {
      log('EpisodeRepository.initialize', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<EpisodeModel>> insert(EpisodeModel episode) async {
    try {
      if (!_started) return throw Exception('Repository not initialized');

      final result = await _databaseService.insert(
        TableNames.episodes,
        episode.toMap(),
      );

      if (result.isFailure) throw Exception('Insert failed');
      final newEpisode = episode.copyWith(id: result.value!);
      _cache[newEpisode.id!] = newEpisode;

      return Result.success(newEpisode);
    } on Exception catch (err, stack) {
      log('EpisodeRepository.insert', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<EpisodeModel>> fetch(
    String uid, [
    bool forceRemote = false,
  ]) async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      if (_cache.containsKey(uid) && !forceRemote) {
        return Result.success(_cache[uid]!);
      }

      final result = await _databaseService.fetch<EpisodeModel>(
        TableNames.episodes,
        id: uid,
        fromMap: EpisodeModel.fromMap,
      );

      if (result.isFailure) return result;
      _cache[uid] = result.value!;

      return result;
    } on Exception catch (err, stack) {
      log('EpisodeRepository.fetch', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<List<EpisodeModel>>> fetchAll() async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      final result = await _databaseService.fetchAll<EpisodeModel>(
        TableNames.episodes,
        fromMap: EpisodeModel.fromMap,
      );

      if (result.isFailure) return result;
      _cache.clear();
      _cache.addAll({
        for (final episode in result.value!) episode.id!: episode,
      });

      return result;
    } on Exception catch (err, stack) {
      log('EpisodeRepository.fetchAll', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<void>> update(EpisodeModel episode) async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      if (episode.id == null) {
        throw Exception('episode ID must not be null for update');
      }

      final result = await _databaseService.update<EpisodeModel>(
        TableNames.episodes,
        map: episode.toMap(),
      );

      if (result.isFailure) return result;
      _cache[episode.id!] = episode;

      return result;
    } on Exception catch (err, stack) {
      log('EpisodeRepository.update', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<void>> delete(String uid) async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      final result = await _databaseService.delete(
        TableNames.sessions,
        id: uid,
      );

      return result;
    } on Exception catch (err, stack) {
      log('EpisodeRepository.delete', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }
}
