import '/data/repositories/session/i_session_repository.dart';
import '/utils/command.dart';

class SessionViewModel {
  final ISessionRepository _sessionRepository;

  SessionViewModel(
    ISessionRepository sessionRepository,
  ) : _sessionRepository = sessionRepository {
    load = Command0<void>(_sessionRepository.initialize)..execute();
    delete = Command1<void, String>(_sessionRepository.delete);
  }

  late final Command0<void> load;
  late final Command1<void, String> delete;
}
