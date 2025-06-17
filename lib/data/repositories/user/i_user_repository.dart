import '../../../domain/models/user_model.dart';
import '/utils/result.dart';

abstract interface class IUserRepository {
  List<UserModel> get users;

  Future<Result<void>> initialize();

  Future<Result<UserModel>> insert(UserModel user);

  Future<Result<UserModel>> fetch(String uid);

  Future<Result<List<UserModel>>> fetchAll();

  Future<Result<void>> update(UserModel user);

  Future<Result<void>> delete(String uid);
}
