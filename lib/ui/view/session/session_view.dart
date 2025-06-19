import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:prontu_ai/domain/models/user_model.dart';

import '/domain/models/episode_model.dart';
import '/ui/view/session/session_view_model.dart';

class SessionView extends StatefulWidget {
  final UserModel user;
  final EpisodeModel episode;
  final SessionViewModel viewModel;

  const SessionView({
    super.key,
    required this.user,
    required this.episode,
    required this.viewModel,
  });

  @override
  State<SessionView> createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Episodios de ${widget.episode.title}'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded),
        ),
      ),
    );
  }
}
