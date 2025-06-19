import 'package:prontu_ai/domain/models/episode_model.dart';
import 'package:prontu_ai/utils/result.dart';

import '/data/repositories/episode/i_episode_repository.dart';
import '/utils/command.dart';

class EpisodeViewModel {
  final IEpisodeRepository _episodeRepository;

  EpisodeViewModel(this._episodeRepository) {
    load = Command0<void>(_episodeRepository.initialize);
    delete = Command1<void, String>(_episodeRepository.delete);
  }

  late final Command0<void> load;
  late final Command1<void, String> delete;

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
