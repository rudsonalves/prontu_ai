import 'dart:developer';

import '/data/services/database/tables/sql_tables.dart';
import '/domain/models/session_model.dart';
import '../../common/table_names.dart';
import '/data/services/database/database_service.dart';
import '/data/repositories/session/i_session_repository.dart';
import '/utils/result.dart';

class SessionRepository implements ISessionRepository {
  final String _episodeId;
  final DatabaseService _databaseService;

  SessionRepository({
    required String episodeId,
    required DatabaseService databaseService,
  }) : _episodeId = episodeId,
       _databaseService = databaseService;

  bool _started = false;

  final Map<String, SessionModel> _cache = {};

  @override
  List<SessionModel> get sessions => _cache.values.toList();

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
  Future<Result<SessionModel>> insert(SessionModel session) async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      final result = await _databaseService.insert(
        TableNames.sessions,
        session.toMap(),
      );

      if (result.isFailure) throw Exception('Insert failed');
      final newSession = session.copyWith(id: result.value!);
      _cache[newSession.id!] = newSession;

      return Result.success(newSession);
    } on Exception catch (err, stack) {
      log('SessionRepository.insert', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<SessionModel>> fetch(
    String uid, [
    bool forceRemote = false,
  ]) async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      if (_cache.containsKey(uid) && !forceRemote) {
        return Result.success(_cache[uid]!);
      }

      final result = await _databaseService.fetch<SessionModel>(
        TableNames.sessions,
        id: uid,
        fromMap: SessionModel.fromMap,
      );

      if (result.isFailure) return result;
      _cache[uid] = result.value!;

      return result;
    } on Exception catch (err, stack) {
      log('SessionRepository.fetch', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<List<SessionModel>>> fetchAll() async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      final result = await _databaseService.fetchAll<SessionModel>(
        TableNames.sessions,
        filter: {TableSessions.episodeId: _episodeId},
        fromMap: SessionModel.fromMap,
      );

      if (result.isFailure) return result;
      _cache.clear();
      _cache.addAll({
        for (final session in result.value!) session.id!: session,
      });

      return result;
    } on Exception catch (err, stack) {
      log('SessionRepository.fetchAll', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<void>> update(SessionModel session) async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      if (session.id == null) {
        throw Exception('session ID must not be null for update');
      }

      final result = await _databaseService.update<SessionModel>(
        TableNames.sessions,
        map: session.toMap(),
      );

      if (result.isFailure) return result;
      _cache[session.id!] = session;

      return result;
    } on Exception catch (err, stack) {
      log('SessionRepository.update', error: err, stackTrace: stack);
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
      log('SessionRepository.delete', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }
}
