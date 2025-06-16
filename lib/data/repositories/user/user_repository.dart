import 'dart:developer';

import '/data/common/tables.dart';
import '/data/repositories/user/i_user_repository.dart';
import '/data/services/database/database_service.dart';
import '/domain/user_model.dart';
import '/utils/result.dart';

class UserRepository implements IUserRepository {
  final DatabaseService _databaseService;

  UserRepository(this._databaseService);

  bool _started = false;

  final Map<String, UserModel> _cache = {};

  List<UserModel> get cachedUsers => List.unmodifiable(_cache.values);

  @override
  Future<Result<void>> initialize() async {
    try {
      if (_started) return const Result.success(null);

      _started = true;

      return const Result.success(null);
    } on Exception catch (err, stack) {
      log('UserRepository.initialize', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<String>> insert(UserModel user) async {
    try {
      if (!_started) return throw Exception('Repository not initialized');

      final result = await _databaseService.insert(Tables.users, user.toMap());

      return result;
    } on Exception catch (err, stack) {
      log('UserRepository.insert', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<UserModel>> fetch(String uid) async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      final result = await _databaseService.fetch<UserModel>(
        Tables.users,
        id: uid,
        fromMap: UserModel.fromMap,
      );

      return result;
    } on Exception catch (err, stack) {
      log('UserRepository.fetch', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<List<UserModel>>> fetchAll() async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      final result = await _databaseService.fetchAll<UserModel>(
        Tables.users,
        fromMap: UserModel.fromMap,
      );

      return result;
    } on Exception catch (err, stack) {
      log('UserRepository.fetchAll', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<void>> update(UserModel user) async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      if (user.id == null) {
        throw Exception('User ID must not be null for update');
      }

      final result = await _databaseService.update<UserModel>(
        Tables.users,
        map: user.toMap(),
        id: user.id!,
      );

      return result;
    } on Exception catch (err, stack) {
      log('UserRepository.update', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<void>> delete(String uid) async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      final result = await _databaseService.delete(Tables.users, id: uid);

      return result;
    } on Exception catch (err, stack) {
      log('UserRepository.delete', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }
}
