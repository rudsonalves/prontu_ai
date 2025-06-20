import '/domain/models/session_model.dart';
import '/data/repositories/session/i_session_repository.dart';
import '/utils/command.dart';

class SessionViewModel {
  final ISessionRepository _sessionRepository;

  SessionViewModel(
    ISessionRepository sessionRepository,
  ) : _sessionRepository = sessionRepository {
    load = Command1<void, String>(_sessionRepository.initialize);
    delete = Command1<void, String>(_sessionRepository.delete);
  }

  late final Command1<void, String> load;
  late final Command1<void, String> delete;

  List<SessionModel> get sessions => _sessionRepository.sessions;
}
