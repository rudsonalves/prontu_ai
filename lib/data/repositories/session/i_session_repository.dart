import '/domain/models/session_model.dart';
import '/utils/result.dart';

abstract interface class ISessionRepository {
  List<SessionModel> get sessions;

  Future<Result<void>> initialize();

  Future<Result<SessionModel>> insert(SessionModel session);

  Future<Result<SessionModel>> fetch(String uid, [bool forceRemote = false]);

  Future<Result<List<SessionModel>>> fetchAll();

  Future<Result<void>> update(SessionModel session);

  Future<Result<void>> delete(String uid);
}
