import '/data/repositories/session/i_session_repository.dart';
import '/domain/models/session_model.dart';
import '/utils/command.dart';

class FormSessionViewModel {
  final ISessionRepository _sessionRepository;

  FormSessionViewModel(this._sessionRepository) {
    insert = Command1<SessionModel, SessionModel>(_sessionRepository.insert);
    update = Command1<void, SessionModel>(_sessionRepository.update);
  }

  late final Command1<SessionModel, SessionModel> insert;
  late final Command1<void, SessionModel> update;
}
