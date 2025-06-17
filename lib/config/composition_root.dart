import 'package:prontu_ai/app_theme_mode.dart';
import 'package:prontu_ai/data/repositories/user/i_user_repository.dart';
import 'package:prontu_ai/data/repositories/user/user_repository.dart';
import 'package:prontu_ai/data/services/database/database_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<List<SingleChildWidget>> compositionRoot() async {
  final database = DatabaseService();
  await database.initialize('prontu_ai.db');

  return <SingleChildWidget>[
    ChangeNotifierProvider<AppThemeMode>(
      create: (context) => AppThemeMode(),
    ),
    Provider<DatabaseService>(create: (context) => DatabaseService()),
    Provider<IUserRepository>(
      create: (context) => UserRepository(database),
    ),
  ];
}
