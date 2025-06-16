import 'dart:developer';

import 'package:path/path.dart';
import 'package:prontu_ai/utils/result.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  DatabaseService();

  final uuid = const Uuid();

  String generateUid() => uuid.v4();

  Database? _db;

  Future<void> initialize(String dbFileName) async {
    String dbPath = await getDatabasesPath();
    String dbFilePath = join(dbPath, dbFileName);

    _db = await openDatabase(
      dbFilePath,
      version: 1,
      onCreate: _createTables,
      onConfigure: _configureDatabase,
      onUpgrade: _onUpgrade,
      onDowngrade: _onDowngrade,
      singleInstance: true,
    );
  }

  void _createTables(Database db, int version) {
    log('Creating tables');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    log('Database upgraded from version $oldVersion to $newVersion');
  }

  void _onDowngrade(Database db, int oldVersion, int newVersion) {
    log('Database downgraded from version $oldVersion to $newVersion');
  }

  Future<void> _configureDatabase(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> close() async {
    if (_db != null) await _db!.close();
  }

  Future<Result<T>> fetch<T>(
    String table, {
    required String id,
    required T Function(Map<String, dynamic>) fromMap,
  }) async {
    if (_db == null) {
      return Result.failure(Exception('Database is not initialized'));
    }
    try {
      final List<Map<String, dynamic>> results = await _db!.query(
        table,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (results.isEmpty) {
        return Result.failure(Exception('No record found with id: $id'));
      }

      return Result.success(fromMap(results.first));
    } on Exception catch (err, stack) {
      log(
        'Error fetching record from $table with id $id: $err',
        error: err,
        stackTrace: stack,
      );
      return Result.failure(err);
    }
  }

  Future<Result<List<T>>> fetchAll<T>(
    String table, {
    required T Function(Map<String, dynamic>) fromMap,
  }) async {
    if (_db == null) {
      return Result.failure(Exception('Database is not initialized'));
    }

    try {
      final List<Map<String, dynamic>> results = await _db!.query(table);
      final List<T> items = results.map(fromMap).toList();
      return Result.success(items);
    } on Exception catch (err, stack) {
      log(
        'Error fetching all records from $table: $err',
        error: err,
        stackTrace: stack,
      );
      return Result.failure(err);
    }
  }

  Future<Result<String>> insert<T>(
    String table,
    Map<String, dynamic> map,
  ) async {
    if (_db == null) {
      return Result.failure(Exception('Database is not initialized'));
    }

    if (map['id'] != null) {
      return Result.failure(Exception('ID should not be provided for insert'));
    }

    try {
      final id = generateUid();
      final newData = Map<String, dynamic>.from(map);
      newData['id'] = id;

      await _db!.insert(table, newData);
      return Result.success(id);
    } on Exception catch (err, stack) {
      log(
        'Error inserting record into $table: $err',
        error: err,
        stackTrace: stack,
      );
      return Result.failure(err);
    }
  }

  Future<Result<void>> update<T>(
    String table,
    String id,
    Map<String, dynamic> map,
  ) async {
    if (_db == null) {
      return Result.failure(Exception('Database is not initialized'));
    }

    try {
      final int count = await _db!.update(
        table,
        map,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (count == 0) {
        return Result.failure(Exception('No record found with id: $id'));
      }

      return Result.success(null);
    } on Exception catch (err, stack) {
      log(
        'Error updating record in $table with id $id: $err',
        error: err,
        stackTrace: stack,
      );
      return Result.failure(err);
    }
  }

  Future<Result<void>> delete<T>(
    String table,
    String id,
  ) async {
    if (_db == null) {
      return Result.failure(Exception('Database is not initialized'));
    }

    try {
      final int count = await _db!.delete(
        table,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (count == 0) {
        return Result.failure(Exception('No record found with id: $id'));
      }

      return Result.success(null);
    } on Exception catch (err, stack) {
      log(
        'Error deleting record from $table with id $id: $err',
        error: err,
        stackTrace: stack,
      );
      return Result.failure(err);
    }
  }
}
