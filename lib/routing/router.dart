import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prontu_ai/ui/view/splash/splash_view.dart';
import 'package:prontu_ai/ui/view/splash/splash_view_model.dart';
import 'package:provider/provider.dart';

import '/data/repositories/attachment/i_attachment_repository.dart';
import '/data/repositories/episode/i_episode_repository.dart';
import '/data/repositories/session/i_session_repository.dart';
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
  // initialLocation: Routes.home.path,
     initialLocation: Routes.splash.path,
  routes: [
    // splash
  GoRoute(
  path: Routes.splash.path,
  name: Routes.splash.name,
  builder: (context, state) => SplashLogoView(
    viewModel: SplashViewModel(
        themeMode: context.read<AppThemeMode>(),
    ),
  ),
),
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
      path: Routes.formUser.path,
      name: Routes.formUser.name,
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
      builder: (context, state) => Builder(
        builder: (context) {
          final map = state.extra as Map<String, dynamic>;
          final user = map['user'] as UserModel;

          return EpisodeView(
            user: user,
            viewModel: EpisodeViewModel(
              context.read<IEpisodeRepository>(),
            ),
          );
        },
      ),
    ),
    GoRoute(
      path: Routes.formEpisode.path,
      name: Routes.formEpisode.name,
      pageBuilder: (context, state) {
        final map = state.extra as Map<String, dynamic>;
        final user = map['user'] as UserModel;
        final episode = map['episode'] as EpisodeModel?;

        return MaterialPage(
          child: FormEpisodeView(
            episode: episode,
            user: user,
            viewModel: FormEpisodeViewModel(
              context.read<IEpisodeRepository>(),
            ),
          ),
        );
      },
    ),

    // Sessions pages
    GoRoute(
      path: Routes.session.path,
      name: Routes.session.name,
      builder: (context, state) {
        final map = state.extra as Map<String, dynamic>;
        final user = map['user'] as UserModel;
        final episode = map['episode'] as EpisodeModel;

        return SessionView(
          user: user,
          episode: episode,
          viewModel: SessionViewModel(
            context.read<ISessionRepository>(),
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.formSession.path,
      name: Routes.formSession.name,
      builder: (context, state) {
        final map = state.extra as Map<String, dynamic>;
        final episode = map['episode'] as EpisodeModel;
        final session = map['session'] as SessionModel?;

        return FormSessionView(
          episode: episode,
          session: session,
          viewModel: FormSessionViewModel(
            context.read<ISessionRepository>(),
          ),
        );
      },
    ),

    // Attachments pages
    GoRoute(
      path: Routes.attachment.path,
      name: Routes.attachment.name,
      builder: (context, state) {
        final map = state.extra as Map<String, dynamic>;
        final user = map['user'] as UserModel;
        final episode = map['episode'] as EpisodeModel;
        final session = map['session'] as SessionModel;

        return AttachmentView(
          user: user,
          episode: episode,
          session: session,
          viewModel: AttachmentViewModel(
            context.read<IAttachmentRepository>(),
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.formAttachment.path,
      name: Routes.formAttachment.name,
      builder: (context, state) {
        final map = state.extra as Map<String, dynamic>;
        final session = map['session'] as SessionModel;
        final attachment = map['attachment'] as AttachmentModel?;

        return FormAttachmentView(
          session: session,
          attachment: attachment,
          viewModel: FormAttachmentViewModel(
            context.read<IAttachmentRepository>(),
          ),
        );
      },
    ),
  ],
);
