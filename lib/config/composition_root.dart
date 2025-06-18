import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '/app_theme_mode.dart';
import '/data/repositories/user/i_user_repository.dart';
import '/data/repositories/user/user_repository.dart';
import '/data/services/database/database_service.dart';

Future<List<SingleChildWidget>> compositionRoot() async {
  final database = DatabaseService();
  await database.initialize('prontu_ai.db');

  return <SingleChildWidget>[
    ChangeNotifierProvider<AppThemeMode>(
      create: (context) => AppThemeMode(),
    ),
    Provider<DatabaseService>(create: (context) => database),
    Provider<IUserRepository>(
      create: (context) => UserRepository(database),
    ),
  ];
}
