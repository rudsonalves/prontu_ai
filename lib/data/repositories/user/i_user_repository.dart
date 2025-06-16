import '/domain/user_model.dart';
import '/utils/result.dart';

abstract interface class IUserRepository {
  Future<Result<void>> initialize();

  Future<Result<String>> insert(UserModel user);

  Future<Result<UserModel>> fetch(String uid);

  Future<Result<List<UserModel>>> fetchAll();

  Future<Result<void>> update(UserModel user);

  Future<Result<void>> delete(String uid);
}
