import 'package:flutter/material.dart';
import 'package:prontu_ai/app_theme_mode.dart';
import 'package:prontu_ai/domain/models/user_model.dart';
import 'package:prontu_ai/utils/result.dart';

import '/data/repositories/user/i_user_repository.dart';
import '/utils/command.dart';

class HomeViewModel {
  final IUserRepository _userRepository;
  final AppThemeMode _themeMode;

  HomeViewModel({
    required IUserRepository userRepository,
    required AppThemeMode themeMode,
  }) : _userRepository = userRepository,
       _themeMode = themeMode {
    load = Command0<void>(_load)..execute();
    delete = Command1<void, String>(_delete);
  }

  late final Command0<void> load;
  late final Command1<void, String> delete;

  ChangeNotifier get themeMode => _themeMode;

  void Function() get toggleTheme => _themeMode.toggle;

  bool get isDark => _themeMode.isDark;

  List<UserModel> get users => _userRepository.users;

  Future<Result<void>> _load() async {
    await Future.delayed(const Duration(seconds: 2));

    final result = await _userRepository.initialize();

    return result;
  }

  Future<Result<void>> _delete(String userId) async {
    final result = await _userRepository.delete(userId);

    return result;
  }
}
