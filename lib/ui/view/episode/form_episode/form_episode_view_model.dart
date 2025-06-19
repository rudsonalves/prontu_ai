import 'package:prontu_ai/utils/result.dart';

import '/data/repositories/episode/i_episode_repository.dart';
import '/domain/models/episode_model.dart';
import '/utils/command.dart';

class FormEpisodeViewModel {
  final IEpisodeRepository _episodeRepository;

  FormEpisodeViewModel(this._episodeRepository) {
    save = Command1<EpisodeModel, EpisodeModel>(_episodeRepository.insert);
    update = Command1<void, EpisodeModel>(_episodeRepository.update);
  }

  late final Command1<EpisodeModel, EpisodeModel> save;
  late final Command1<void, EpisodeModel> update;

  List<EpisodeModel> get episodes => _episodeRepository.episodes;

  Future<Result<void>> _load() async {
    await Future.delayed(const Duration(seconds: 2));

    final result = await _episodeRepository.initialize();

    return result;
  }

  Future<Result<void>> _delete(String userId) async {
    final result = await _episodeRepository.delete(userId);

    return result;
  }
}
