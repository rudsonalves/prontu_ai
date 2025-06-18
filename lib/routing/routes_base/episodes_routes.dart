import 'package:go_router/go_router.dart';

import '/data/repositories/episode/i_episode_repository.dart';
import '/domain/models/episode_model.dart';
import '/domain/models/user_model.dart';
import '/ui/view/episode/episode_view.dart';
import '/ui/view/episode/episode_view_model.dart';
import '/ui/view/episode/form_episode/form_episode_view.dart';
import '/ui/view/episode/form_episode/form_episode_view_model.dart';
import '/routing/routes.dart';
import '/routing/utils/repository_scope.dart';

final episodesRoutes = <RouteBase>[
  GoRoute(
    path: Routes.episode.path,
    name: Routes.episode.name,
    builder: (context, state) => EpisodeView(
      user: state.extra as UserModel,
      viewModel: EpisodeViewModel(
        RepositoryScope.of<IEpisodeRepository>(context),
      ),
    ),
  ),
  GoRoute(
    path: Routes.formEpisode.path,
    name: Routes.formEpisode.name,
    builder: (context, state) => FormEpisodeView(
      episode: state.extra as EpisodeModel,
      viewModel: FormEpisodeViewModel(
        RepositoryScope.of<IEpisodeRepository>(context),
      ),
    ),
  ),
];
