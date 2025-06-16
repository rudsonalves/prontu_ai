import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '/data/services/database/tables/sql_tables.dart';
import '/utils/result.dart';

class DatabaseService {
  DatabaseService();

  final uuid = const Uuid();

  String generateUid() => uuid.v4();

  Database? _db;

  bool _started = false;

  Future<void> initialize(String dbFileName) async {
    if (_started) return;
    _started = true;

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

  Future<void> _createTables(Database db, int version) async {
    log('Creating tables');

    final batch = db.batch();

    batch.execute(SqlTables.user);

    await batch.commit();
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
    try {
      if (_db == null) throw Exception('Database is not initialized');

      final List<Map<String, dynamic>> results = await _db!.query(
        table,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (results.isEmpty) throw Exception('No record found with id: $id');

      return Result.success(fromMap(results.first));
    } on Exception catch (err, stack) {
      log(
        'DatabeseService.fetch: $err',
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
    try {
      if (_db == null) throw Exception('Database is not initialized');

      final List<Map<String, dynamic>> results = await _db!.query(table);
      final List<T> items = results.map(fromMap).toList();
      return Result.success(items);
    } on Exception catch (err, stack) {
      log(
        'DatabeseService.fetchAll: $err',
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
    try {
      if (_db == null) throw Exception('Database is not initialized');

      if (map['id'] != null) {
        throw Exception('ID should not be provided for insert');
      }

      final id = generateUid();
      final newData = Map<String, dynamic>.from(map);
      newData['id'] = id;

      await _db!.insert(table, newData);
      return Result.success(id);
    } on Exception catch (err, stack) {
      log(
        'DatabeseService.insert: $err',
        error: err,
        stackTrace: stack,
      );
      return Result.failure(err);
    }
  }

  Future<Result<void>> update<T>(
    String table, {
    required Map<String, dynamic> map,
  }) async {
    try {
      if (_db == null) throw Exception('Database is not initialized');

      final id = map['id'] as String?;
      if (id == null) throw Exception('ID must not be null for update');

      final int count = await _db!.update(
        table,
        map,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (count == 0) throw Exception('No record found with id: $id');

      return const Result.success(null);
    } on Exception catch (err, stack) {
      log(
        'DatabeseService.update: $err',
        error: err,
        stackTrace: stack,
      );
      return Result.failure(err);
    }
  }

  Future<Result<void>> delete<T>(
    String table, {
    required String id,
  }) async {
    try {
      if (_db == null) throw Exception('Database is not initialized');

      final int count = await _db!.delete(
        table,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (count == 0) throw Exception('No record found with id: $id');

      return const Result.success(null);
    } on Exception catch (err, stack) {
      log(
        'DatabaseService.delete: $err',
        error: err,
        stackTrace: stack,
      );
      return Result.failure(err);
    }
  }
}
