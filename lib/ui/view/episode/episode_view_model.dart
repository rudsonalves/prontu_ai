import '/data/repositories/episode/i_episode_repository.dart';
import '/utils/command.dart';

class EpisodeViewModel {
  final IEpisodeRepository _episodeRepository;

  EpisodeViewModel(this._episodeRepository) {
    load = Command0<void>(_episodeRepository.initialize)..execute();
  }

  late final Command0<void> load;
}
