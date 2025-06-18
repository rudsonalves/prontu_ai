import 'package:flutter/widgets.dart';

import '/ui/view/episode/episode_view_model.dart';

class EpisodeView extends StatefulWidget {
  final String userId;
  final EpisodeViewModel viewModel;

  const EpisodeView({
    super.key,
    required this.userId,
    required this.viewModel,
  });

  @override
  State<EpisodeView> createState() => _EpisodeViewState();
}

class _EpisodeViewState extends State<EpisodeView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
