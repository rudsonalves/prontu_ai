import 'package:flutter/widgets.dart';

import '/ui/view/session/session_view_model.dart';

class SessionView extends StatefulWidget {
  final String episodeId;
  final SessionViewModel viewModel;

  const SessionView({
    super.key,
    required this.episodeId,
    required this.viewModel,
  });

  @override
  State<SessionView> createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
