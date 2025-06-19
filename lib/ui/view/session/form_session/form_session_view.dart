import 'package:flutter/widgets.dart';
import 'package:prontu_ai/domain/models/episode_model.dart';
import 'package:prontu_ai/domain/models/user_model.dart';

import '/domain/models/session_model.dart';
import '/ui/view/session/form_session/form_session_view_model.dart';

class FormSessionView extends StatefulWidget {
  final UserModel user;
  final EpisodeModel episode;
  final SessionModel? session;
  final FormSessionViewModel viewModel;

  const FormSessionView({
    super.key,
    this.session,
    required this.user,
    required this.episode,
    required this.viewModel,
  });

  @override
  State<FormSessionView> createState() => _FormSessionViewState();
}

class _FormSessionViewState extends State<FormSessionView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
