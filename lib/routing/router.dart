import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/domain/models/attachment_model.dart';
import '/domain/models/episode_model.dart';
import '/domain/models/session_model.dart';
import '/ui/view/attachment/attachment_view.dart';
import '/ui/view/attachment/attachment_view_model.dart';
import '/ui/view/attachment/form_attachment/form_attachment_view.dart';
import '/ui/view/attachment/form_attachment/form_attachment_view_model.dart';
import '/ui/view/episode/form_episode/form_episode_view.dart';
import '/ui/view/episode/form_episode/form_episode_view_model.dart';
import '/ui/view/session/form_session/form_session_view.dart';
import '/ui/view/session/form_session/form_session_view_model.dart';
import '/ui/view/session/session_view.dart';
import '/ui/view/session/session_view_model.dart';
import '/domain/models/user_model.dart';
import '/ui/view/episode/episode_view.dart';
import '/ui/view/episode/episode_view_model.dart';
import '/ui/view/home/form_user/form_user_view.dart';
import '/ui/view/home/form_user/form_user_view_model.dart';
import '/app_theme_mode.dart';
import '/data/repositories/user/i_user_repository.dart';
import '/ui/view/home/home_view_model.dart';
import '/routing/routes.dart';
import '/ui/view/home/home_view.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.home.path,
  routes: [
    GoRoute(
      path: Routes.home.path,
      name: Routes.home.name,
      builder: (context, state) => HomeView(
        viewModel: HomeViewModel(
          userRepository: context.read<IUserRepository>(),
          themeMode: context.read<AppThemeMode>(),
        ),
      ),
    ),
    GoRoute(
      path: Routes.user.path,
      name: Routes.user.name,
      builder: (context, state) => FormUserView(
        user: state.extra as UserModel?,
        viewModel: FormUserViewModel(
          userRepository: context.read<IUserRepository>(),
        ),
      ),
    ),
    // Episodes pages
    GoRoute(
      path: Routes.episode.path,
      name: Routes.episode.name,
      builder: (context, state) => EpisodeView(
        userId: state.extra as String,
        viewModel: EpisodeViewModel(),
      ),
    ),
    GoRoute(
      path: Routes.formEpisode.path,
      name: Routes.formEpisode.name,
      builder: (context, state) => FormEpisodeView(
        episode: state.extra as EpisodeModel,
        viewModel: FormEpisodeViewModel(),
      ),
    ),
    // Sessions pages
    GoRoute(
      path: Routes.session.path,
      name: Routes.session.name,
      builder: (context, state) => SessionView(
        episodeId: state.extra as String,
        viewModel: SessionViewModel(),
      ),
    ),
    GoRoute(
      path: Routes.formSession.path,
      name: Routes.formSession.name,
      builder: (context, state) => FormSessionView(
        session: state.extra as SessionModel,
        viewModel: FormSessionViewModel(),
      ),
    ),
    // Attachments pages
    GoRoute(
      path: Routes.attachment.path,
      name: Routes.attachment.name,
      builder: (context, state) => AttachmentView(
        sessionId: state.extra as String,
        viewModel: AttachmentViewModel(),
      ),
    ),
    GoRoute(
      path: Routes.formAttachment.path,
      name: Routes.formAttachment.name,
      builder: (context, state) => FormAttachmentView(
        attachment: state.extra as AttachmentModel,
        viewModel: FormAttachmentViewModel(),
      ),
    ),
  ],
);
