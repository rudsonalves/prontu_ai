import '/data/repositories/user/i_user_repository.dart';
import '/domain/models/user_model.dart';
import '/utils/command.dart';
import '/utils/result.dart';

class FormUserViewModel {
  final IUserRepository _userRepository;

  FormUserViewModel({required IUserRepository userRepository})
    : _userRepository = userRepository {
    insert = Command1<UserModel, UserModel>(_insert);
    update = Command1<void, UserModel>(_update);
  }

  late final Command1<UserModel, UserModel> insert;
  late final Command1<void, UserModel> update;

  Future<Result<UserModel>> _insert(UserModel user) async {
    await Future.delayed(const Duration(seconds: 2));

    final result = await _userRepository.insert(user);

    return result;
  }

  Future<Result<void>> _update(UserModel user) async {
    await Future.delayed(const Duration(seconds: 2));

    final result = await _userRepository.update(user);

    return result;
  }
}
