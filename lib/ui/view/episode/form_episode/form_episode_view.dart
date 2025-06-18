import 'package:flutter/widgets.dart';

import '/domain/models/episode_model.dart';
import '/ui/view/episode/form_episode/form_episode_view_model.dart';

class FormEpisodeView extends StatefulWidget {
  final EpisodeModel episode;
  final FormEpisodeViewModel viewModel;

  const FormEpisodeView({
    super.key,
    required this.episode,
    required this.viewModel,
  });

  @override
  State<FormEpisodeView> createState() => _FormEpisodeViewState();
}

class _FormEpisodeViewState extends State<FormEpisodeView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
