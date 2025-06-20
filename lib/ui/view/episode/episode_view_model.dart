import 'package:flutter/material.dart';
import 'package:prontu_ai/domain/models/ai_summary_model.dart';

import '/domain/user_cases/episode_ai_summary_user_case.dart';
import '/domain/models/episode_model.dart';
import '/utils/command.dart';

class EpisodeViewModel extends ChangeNotifier {
  final EpisodeAiSummaryUserCase _episodeRepository;

  EpisodeViewModel(this._episodeRepository) {
    load = Command1<void, String>(_episodeRepository.initialize);
    delete = Command1<void, String>(_episodeRepository.deleteEpisode);
    analise = Command1<AiSummaryModel, EpisodeModel>(
      _episodeRepository.analiseEpisode,
    );
  }

  late final Command1<void, String> load;
  late final Command1<void, String> delete;
  late final Command1<AiSummaryModel, EpisodeModel> analise;

  List<EpisodeModel> get episodes => _episodeRepository.episodes;
}
