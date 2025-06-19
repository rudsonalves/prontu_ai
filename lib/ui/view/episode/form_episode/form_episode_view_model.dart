import 'package:prontu_ai/utils/result.dart';

import '/data/repositories/episode/i_episode_repository.dart';
import '/domain/models/episode_model.dart';
import '/utils/command.dart';

class FormEpisodeViewModel {
  final IEpisodeRepository _episodeRepository;

  FormEpisodeViewModel(this._episodeRepository) {
    insert = Command1<EpisodeModel, EpisodeModel>(_episodeRepository.insert);
    update = Command1<void, EpisodeModel>(_episodeRepository.update);
  }

  late final Command1<EpisodeModel, EpisodeModel> insert;
  late final Command1<void, EpisodeModel> update;

  Future<Result<EpisodeModel>> _insert(EpisodeModel episode) async {
    await Future.delayed(const Duration(seconds: 2));
    final result = await _episodeRepository.insert(episode);
    return result;
  }

  Future<Result<void>> _update(EpisodeModel episode) async {
    await Future.delayed(const Duration(seconds: 2));
    final result = await _episodeRepository.update(episode);

    return result;
  }
}
