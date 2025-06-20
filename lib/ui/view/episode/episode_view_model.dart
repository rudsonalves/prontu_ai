import 'package:flutter/material.dart';
import 'package:prontu_ai/domain/models/ai_summary_model.dart';

import '/domain/user_cases/episode_ai_summary_user_case.dart';
import '/domain/models/episode_model.dart';
import '/utils/command.dart';

class EpisodeViewModel extends ChangeNotifier {
  final EpisodeAiSummaryUserCase _episodeAiUserCase;

  EpisodeViewModel(this._episodeAiUserCase) {
    load = Command1<void, String>(_episodeAiUserCase.initialize);
    delete = Command1<void, String>(_episodeAiUserCase.deleteEpisode);
    analise = Command1<(AiSummaryModel, EpisodeModel), EpisodeModel>(
      _episodeAiUserCase.analiseEpisode,
    );
  }

  late final Command1<void, String> load;
  late final Command1<void, String> delete;
  late final Command1<(AiSummaryModel, EpisodeModel), EpisodeModel> analise;

  List<EpisodeModel> get episodes => _episodeAiUserCase.episodes;
}
