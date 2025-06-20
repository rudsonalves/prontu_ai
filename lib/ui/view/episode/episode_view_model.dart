import 'package:flutter/material.dart';

import '/domain/models/episode_model.dart';
import '/data/repositories/episode/i_episode_repository.dart';
import '/utils/command.dart';

class EpisodeViewModel extends ChangeNotifier {
  final IEpisodeRepository _episodeRepository;

  EpisodeViewModel(this._episodeRepository) {
    load = Command0<void>(_episodeRepository.initialize)..execute();
    delete = Command1<void, String>(_episodeRepository.delete);
  }

  late final Command0<void> load;
  late final Command1<void, String> delete;

  List<EpisodeModel> get episodes => _episodeRepository.episodes;
}
