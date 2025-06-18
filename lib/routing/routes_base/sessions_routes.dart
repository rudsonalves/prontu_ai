import 'package:go_router/go_router.dart';

import '/data/repositories/session/i_session_repository.dart';
import '/domain/models/episode_model.dart';
import '/domain/models/session_model.dart';
import '/routing/routes.dart';
import '/routing/utils/repository_scope.dart';
import '/ui/view/session/form_session/form_session_view.dart';
import '/ui/view/session/form_session/form_session_view_model.dart';
import '/ui/view/session/session_view.dart';
import '/ui/view/session/session_view_model.dart';

final sessionsRoutes = <RouteBase>[
  GoRoute(
    path: Routes.session.path,
    name: Routes.session.name,
    builder: (context, state) {
      final episode = state.extra as EpisodeModel;

      return SessionView(
        episode: episode,
        viewModel: SessionViewModel(
          RepositoryScope.of<ISessionRepository>(context),
        ),
      );
    },
  ),
  GoRoute(
    path: Routes.formSession.path,
    name: Routes.formSession.name,
    builder: (context, state) => FormSessionView(
      session: state.extra as SessionModel,
      viewModel: FormSessionViewModel(
        RepositoryScope.of<ISessionRepository>(context),
      ),
    ),
  ),
];
