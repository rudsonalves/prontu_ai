import 'dart:developer';

import '/data/common/tables.dart';
import '/data/services/database/database_service.dart';
import '/domain/models/attachment_model.dart';
import '/data/repositories/attachment/i_attachment_repository.dart';
import '/utils/result.dart';

class AttachmentRepository implements IAttachmentRepository {
  final DatabaseService _databaseService;

  AttachmentRepository(this._databaseService);

  bool _started = false;

  final Map<String, AttachmentModel> _cache = {};

  @override
  List<AttachmentModel> get attachments => List.unmodifiable(_cache.values);

  @override
  Future<Result<void>> initialize() async {
    try {
      if (_started) return const Result.success(null);

      _started = true;

      return const Result.success(null);
    } on Exception catch (err, stack) {
      log('AttachmentRepository.initialize', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<AttachmentModel>> insert(AttachmentModel attachment) async {
    try {
      if (!_started) return throw Exception('Repository not initialized');

      final result = await _databaseService.insert(
        Tables.attachments,
        attachment.toMap(),
      );

      if (result.isFailure) throw Exception('Insert failed');
      _cache[attachment.id!] = attachment.copyWith(id: result.value!);

      return Result.success(_cache[attachment.id!]!);
    } on Exception catch (err, stack) {
      log('AttachmentRepository.insert', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<AttachmentModel>> fetch(
    String uid, [
    bool forceRemote = false,
  ]) async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      if (_cache.containsKey(uid) && !forceRemote) {
        return Result.success(_cache[uid]!);
      }

      final result = await _databaseService.fetch<AttachmentModel>(
        Tables.users,
        id: uid,
        fromMap: AttachmentModel.fromMap,
      );

      if (result.isFailure) return result;
      _cache[uid] = result.value!;

      return result;
    } on Exception catch (err, stack) {
      log('AttachmentRepository.fetch', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<List<AttachmentModel>>> fetchAll() async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      final result = await _databaseService.fetchAll<AttachmentModel>(
        Tables.users,
        fromMap: AttachmentModel.fromMap,
      );

      if (result.isFailure) return result;
      _cache.clear();
      _cache.addAll({for (final user in result.value!) user.id!: user});

      return result;
    } on Exception catch (err, stack) {
      log('AttachmentRepository.fetchAll', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<void>> update(AttachmentModel user) async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      if (user.id == null) {
        throw Exception('User ID must not be null for update');
      }

      final result = await _databaseService.update<AttachmentModel>(
        Tables.users,
        map: user.toMap(),
      );

      if (result.isFailure) return result;
      _cache[user.id!] = user;

      return result;
    } on Exception catch (err, stack) {
      log('AttachmentRepository.update', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<void>> delete(String uid) async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      final result = await _databaseService.delete(Tables.attachments, id: uid);

      return result;
    } on Exception catch (err, stack) {
      log('AttachmentRepository.delete', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }
}
