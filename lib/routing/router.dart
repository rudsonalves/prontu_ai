import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'utils/repository_scope.dart';
import '/data/repositories/attachment/attachment_repository.dart';
import '/data/repositories/attachment/i_attachment_repository.dart';
import '/data/repositories/episode/i_episode_repository.dart';
import '/data/repositories/session/i_session_repository.dart';
import '/data/repositories/session/session_repository.dart';
import '/data/repositories/episode/episode_repository.dart';
import '/data/services/database/database_service.dart';
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
    ShellRoute(
      builder: (context, state, child) {
        final user = state.extra as UserModel;

        final episodeRepository = EpisodeRepository(
          userId: user.id!,
          databaseService: context.read<DatabaseService>(),
        );

        return RepositoryScope<IEpisodeRepository>(
          repository: episodeRepository,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: Routes.episode.path,
          name: Routes.episode.name,
          builder: (context, state) => Builder(
            builder: (context) => EpisodeView(
              user: state.extra as UserModel,
              viewModel: EpisodeViewModel(
                RepositoryScope.of<IEpisodeRepository>(context),
              ),
            ),
          ),
        ),
        GoRoute(
          path: Routes.formEpisode.path,
          name: Routes.formEpisode.name,
          pageBuilder: (context, state) => MaterialPage(
            child: FormEpisodeView(
              episode: state.extra as EpisodeModel?,
              viewModel: FormEpisodeViewModel(
                RepositoryScope.of<IEpisodeRepository>(context),
              ),
            ),
          ),
        ),
        // Sessions pages
        ShellRoute(
          builder: (context, state, child) {
            final episode = state.extra as EpisodeModel;

            final sessionRepository = SessionRepository(
              episodeId: episode.id!,
              databaseService: context.read<DatabaseService>(),
            );

            return RepositoryScope<ISessionRepository>(
              repository: sessionRepository,
              child: child,
            );
          },
          routes: [
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
            // Attachments pages
            ShellRoute(
              builder: (context, state, child) {
                final session = state.extra as SessionModel;

                final attachmentRepository = AttachmentRepository(
                  sessionId: session.id!,
                  databaseService: context.read<DatabaseService>(),
                );

                return RepositoryScope<IAttachmentRepository>(
                  repository: attachmentRepository,
                  child: child,
                );
              },
              routes: [
                GoRoute(
                  path: Routes.attachment.path,
                  name: Routes.attachment.name,
                  builder: (context, state) => AttachmentView(
                    session: state.extra as SessionModel,
                    viewModel: AttachmentViewModel(
                      RepositoryScope.of<IAttachmentRepository>(context),
                    ),
                  ),
                ),
                GoRoute(
                  path: Routes.formAttachment.path,
                  name: Routes.formAttachment.name,
                  builder: (context, state) => FormAttachmentView(
                    attachment: state.extra as AttachmentModel,
                    viewModel: FormAttachmentViewModel(
                      RepositoryScope.of<IAttachmentRepository>(context),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
