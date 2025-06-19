import '/data/repositories/episode/i_episode_repository.dart';
import '/domain/models/episode_model.dart';
import '/utils/command.dart';

class FormEpisodeViewModel {
  final IEpisodeRepository _episodeRepository;

  FormEpisodeViewModel(this._episodeRepository) {
    insert = Command1<EpisodeModel, EpisodeModel>(
      _episodeRepository.insert,
    );
    update = Command1<void, EpisodeModel>(_episodeRepository.update);
  }

  late final Command1<EpisodeModel, EpisodeModel> insert;
  late final Command1<void, EpisodeModel> update;
}
