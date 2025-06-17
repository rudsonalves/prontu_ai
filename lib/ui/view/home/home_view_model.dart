import '/data/repositories/user/i_user_repository.dart';
import '/utils/command.dart';

class HomeViewModel {
  final IUserRepository _userRepository;

  HomeViewModel({required IUserRepository userRepository})
    : _userRepository = userRepository {
    load = Command0<void>(_userRepository.initialize)..execute();
  }

  late final Command0<void> load;
}
