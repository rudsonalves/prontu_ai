import 'package:prontu_ai/domain/models/ai_summary_model.dart';
import 'package:prontu_ai/domain/models/episode_model.dart';

import '/data/repositories/ai_summary/i_ai_summary_repository.dart';
import '/data/repositories/episode/i_episode_repository.dart';
import '/utils/result.dart';

class EpisodeAiSummaryUserCase {
  final IEpisodeRepository _episodeRepository;
  final IAiSummaryRepository _aiSummaryRepository;

  EpisodeAiSummaryUserCase({
    required IEpisodeRepository episodeRepository,
    required IAiSummaryRepository aiSummaryRepository,
  }) : _episodeRepository = episodeRepository,
       _aiSummaryRepository = aiSummaryRepository;

  List<EpisodeModel> get episodes => _episodeRepository.episodes;

  Future<Result<void>> initialize(String userId) async {
    final result = await _episodeRepository.initialize(userId);
    if (result.isFailure) return result;

    return _aiSummaryRepository.initialize();
  }

  Future<Result<void>> deleteEpisode(String uid) {
    return _episodeRepository.delete(uid);
  }

  Future<Result<(AiSummaryModel, EpisodeModel)>> analiseEpisode(
    EpisodeModel episode,
  ) async {
    final result = await _aiSummaryRepository.analiseEpisode(episode);
    if (result.isFailure) return Result.failure(result.error!);

    final aiSummary = result.value!;
    return Result.success((aiSummary, episode));
  }
}
