import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '/data/repositories/ai_summary/ai_summary_repository.dart';
import '/data/repositories/ai_summary/i_ai_summary_repository.dart';
import '/data/services/open_ia/open_ia_service.dart';
import '/data/repositories/attachment/attachment_repository.dart';
import '/data/repositories/attachment/i_attachment_repository.dart';
import '/data/repositories/session/i_session_repository.dart';
import '/data/repositories/session/session_repository.dart';
import '/data/repositories/episode/episode_repository.dart';
import '/data/repositories/episode/i_episode_repository.dart';
import '/app_theme_mode.dart';
import '/data/repositories/user/i_user_repository.dart';
import '/data/repositories/user/user_repository.dart';
import '/data/services/database/database_service.dart';

Future<List<SingleChildWidget>> compositionRoot() async {
  final database = DatabaseService();
  await database.initialize('prontu_ai.db');
  final openIaService = OpenIaService();

  return <SingleChildWidget>[
    ChangeNotifierProvider<AppThemeMode>(
      create: (ctx) => AppThemeMode(),
    ),
    Provider<DatabaseService>(create: (ctx) => database),
    Provider<IUserRepository>(
      create: (ctx) => UserRepository(database),
    ),
    Provider<IEpisodeRepository>(
      create: (ctx) => EpisodeRepository(databaseService: database),
    ),
    Provider<ISessionRepository>(
      create: (ctx) => SessionRepository(databaseService: database),
    ),
    Provider<IAttachmentRepository>(
      create: (ctx) => AttachmentRepository(databaseService: database),
    ),
    Provider<IAiSummaryRepository>(
      create: (ctx) => AiSummaryRepository(
        databaseService: database,
        openIaService: openIaService,
      ),
    ),
  ];
}
