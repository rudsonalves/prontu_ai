import 'package:flutter/material.dart';

import '/domain/models/episode_model.dart';
import '/data/repositories/episode/i_episode_repository.dart';
import '/utils/command.dart';

class EpisodeViewModel extends ChangeNotifier {
  final IEpisodeRepository _episodeRepository;

  EpisodeViewModel(this._episodeRepository) {
    load = Command1<void, String>(_episodeRepository.initialize);
    delete = Command1<void, String>(_episodeRepository.delete);
  }

  late final Command1<void, String> load;
  late final Command1<void, String> delete;

  List<EpisodeModel> get episodes => _episodeRepository.episodes;
}
