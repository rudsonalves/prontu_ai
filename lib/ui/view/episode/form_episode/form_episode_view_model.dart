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
}
