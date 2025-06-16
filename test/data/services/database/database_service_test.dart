import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:flutter_test/flutter_test.dart';
import 'package:prontu_ai/data/common/tables.dart';
import 'package:prontu_ai/data/services/database/database_service.dart';
import 'package:prontu_ai/domain/user_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Inicializa o databaseFactory para testes
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late DatabaseService service;
  const dbName = 'test_db.sqlite';

  setUp(() async {
    service = DatabaseService();
    await service.initialize(dbName);
  });

  tearDown(() async {
    await service.close();
    final dbPath = await getDatabasesPath();
    final dbFile = File(p.join(dbPath, dbName));
    if (await dbFile.exists()) {
      await dbFile.delete();
    }
  });
  test('CRUD UserModel', () async {
    final user = UserModel(
      name: 'Alice',
      birthDate: DateTime(1990, 5, 12),
      sex: Sex.female,
    );

    // Inserindo o usuário
    final insertResult = await service.insert(Tables.users, user.toMap());

    expect(insertResult.isSuccess, true);
    final insertedId = insertResult.value!;

    // Buscando o usuário
    final fetchedResult = await service.fetch<UserModel>(
      Tables.users,
      id: insertedId,
      fromMap: UserModel.fromMap,
    );
    expect(fetchedResult.isSuccess, true);
    final fetchedUser = fetchedResult.value!;
    expect(fetchedUser.name, user.name);
    expect(fetchedUser.birthDate, user.birthDate);
    expect(fetchedUser.sex, user.sex);

    // Atualizando o usuário
    final updateUser = user.copyWith(id: insertedId, name: 'Bob');
    final updateResult = await service.update(
      Tables.users,
      map: updateUser.toMap(),
    );
    expect(updateResult.isSuccess, true);

    // Load updeted user
    final updatedFetchedResult = await service.fetch<UserModel>(
      Tables.users,
      id: insertedId,
      fromMap: UserModel.fromMap,
    );
    expect(updatedFetchedResult.isSuccess, true);
    final updatedUser = updatedFetchedResult.value!;
    expect(updatedUser.name, updateUser.name);
    expect(updatedUser.birthDate, updateUser.birthDate);
    expect(updatedUser.sex, updateUser.sex);

    // Deletando o usuário
    final deleteResult = await service.delete(Tables.users, id: insertedId);
    expect(deleteResult.isSuccess, true);

    // Buscando o usuário
    final deletedFetchedResult = await service.fetch<UserModel>(
      Tables.users,
      id: insertedId,
      fromMap: UserModel.fromMap,
    );
    expect(deletedFetchedResult.isSuccess, false);
  });
}
