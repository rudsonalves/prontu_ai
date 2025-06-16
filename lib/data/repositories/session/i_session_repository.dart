import 'package:prontu_ai/utils/result.dart';

abstract interface class ISessionRepository {
  Future<Result<void>> initialize();

  // Future<Result<String>> insert(SessionModel user);

  // Future<Result<SessionModel>> fetch(String uid);

  // Future<Result<List<SessionModel>>> fetchAll();

  // Future<Result<void>> update(SessionModel user);

  Future<Result<void>> delete(String uid);
}
