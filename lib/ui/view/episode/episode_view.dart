import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '/domain/models/user_model.dart';
import '/ui/view/episode/episode_view_model.dart';

class EpisodeView extends StatefulWidget {
  final UserModel user;
  final EpisodeViewModel viewModel;

  const EpisodeView({
    super.key,
    required this.user,
    required this.viewModel,
  });

  @override
  State<EpisodeView> createState() => _EpisodeViewState();
}

class _EpisodeViewState extends State<EpisodeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Episodios de ${widget.user.name}'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded),
        ),
      ),
    );
  }
}
