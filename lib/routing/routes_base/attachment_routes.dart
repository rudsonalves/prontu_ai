import 'package:go_router/go_router.dart';

import '/data/repositories/attachment/i_attachment_repository.dart';
import '/domain/models/attachment_model.dart';
import '/domain/models/session_model.dart';
import '/routing/routes.dart';
import '/routing/utils/repository_scope.dart';
import '/ui/view/attachment/attachment_view.dart';
import '/ui/view/attachment/attachment_view_model.dart';
import '/ui/view/attachment/form_attachment/form_attachment_view.dart';
import '/ui/view/attachment/form_attachment/form_attachment_view_model.dart';

final attachmentRoutes = <RouteBase>[
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
];
