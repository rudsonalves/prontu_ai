import 'dart:developer';

import '../../common/table_names.dart';
import '/data/repositories/user/i_user_repository.dart';
import '/data/services/database/database_service.dart';
import '/domain/models/user_model.dart';
import '/utils/result.dart';

class UserRepository implements IUserRepository {
  final DatabaseService _databaseService;

  UserRepository(this._databaseService);

  bool _started = false;

  final Map<String, UserModel> _cache = {};

  @override
  List<UserModel> get users => List.unmodifiable(_cache.values);

  @override
  Future<Result<void>> initialize() async {
    try {
      if (_started) return const Result.success(null);

      _started = true;

      final result = await fetchAll();
      if (result.isFailure) return result;

      return const Result.success(null);
    } on Exception catch (err, stack) {
      log('UserRepository.initialize', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<UserModel>> insert(UserModel user) async {
    try {
      if (!_started) return throw Exception('Repository not initialized');

      final result = await _databaseService.insert(
        TableNames.users,
        user.toMap(),
      );

      if (result.isFailure) throw Exception('Insert failed');
      final newUser = user.copyWith(id: result.value!);
      _cache[newUser.id!] = newUser;

      return Result.success(newUser);
    } on Exception catch (err, stack) {
      log('UserRepository.insert', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<UserModel>> fetch(
    String uid, [
    bool forceRemote = false,
  ]) async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      if (_cache.containsKey(uid) && !forceRemote) {
        return Result.success(_cache[uid]!);
      }

      final result = await _databaseService.fetch<UserModel>(
        TableNames.users,
        id: uid,
        fromMap: UserModel.fromMap,
      );

      if (result.isFailure) return result;
      _cache[uid] = result.value!;

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
        TableNames.users,
        fromMap: UserModel.fromMap,
      );

      if (result.isFailure) return result;
      _cache.clear();
      _cache.addAll({for (final user in result.value!) user.id!: user});

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
        TableNames.users,
        map: user.toMap(),
      );

      if (result.isFailure) return result;
      _cache[user.id!] = user;

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

      final result = await _databaseService.delete(TableNames.users, id: uid);

      if (result.isFailure) return result;
      _cache.remove(uid);

      return result;
    } on Exception catch (err, stack) {
      log('UserRepository.delete', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }
}
