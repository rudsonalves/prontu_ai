import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:prontu_ai/ui/core/theme/dimens.dart';

import '/domain/models/user_model.dart';
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
  late final SessionViewModel viewModel;

  @override
  void initState() {
    viewModel = widget.viewModel;

    // viewModel.delete.addListener(_isDeleted);

    super.initState();
  }

  @override
  void dispose() {
    // viewModel.delete.removeListener(_isDeleted);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Epsódio: ${widget.episode.title}'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _navFormSessionView,
      //   child: const Icon(Symbols.add_rounded),
      // ),
      body: Padding(
        padding: EdgeInsets.all(dimens.paddingScreenAll),
      ),
    );
  }
}
