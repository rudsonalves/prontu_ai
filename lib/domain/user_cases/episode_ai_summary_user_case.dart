import 'package:prontu_ai/domain/models/session_model.dart';

import '/domain/dtos/medical_record.dart';
import '/data/repositories/attachment/i_attachment_repository.dart';
import '/data/repositories/session/i_session_repository.dart';
import '/domain/models/attachment_model.dart';
import '/domain/models/ai_summary_model.dart';
import '/domain/models/episode_model.dart';
import '/data/repositories/ai_summary/i_ai_summary_repository.dart';
import '/data/repositories/episode/i_episode_repository.dart';
import '/utils/result.dart';

class EpisodeAiSummaryUserCase {
  final IEpisodeRepository _episodeRepository;
  final ISessionRepository _sessionRepository;
  final IAttachmentRepository _attachmentRepository;
  final IAiSummaryRepository _aiSummaryRepository;

  EpisodeAiSummaryUserCase({
    required IEpisodeRepository episodeRepository,
    required ISessionRepository sessionRepository,
    required IAttachmentRepository attachmentRepository,
    required IAiSummaryRepository aiSummaryRepository,
  }) : _episodeRepository = episodeRepository,
       _aiSummaryRepository = aiSummaryRepository,
       _sessionRepository = sessionRepository,
       _attachmentRepository = attachmentRepository;

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
    final List<SessionModel> sessions = [];
    final List<AttachmentModel> attachments = [];

    // Load sessions from episode
    await _sessionRepository.initialize(episode.id!);
    sessions.addAll(_sessionRepository.sessions);

    // Load attachments from sessions
    for (final session in sessions) {
      await _attachmentRepository.initialize(session.id!);
      attachments.addAll(_attachmentRepository.attachments);
    }

    final MedicalRecord record = MedicalRecord(
      episode: episode,
      sessions: sessions,
      attachments: attachments,
    );
    final result = await _aiSummaryRepository.analiseEpisode(record);
    if (result.isFailure) return Result.failure(result.error!);

    final aiSummary = result.value!;
    return Result.success((aiSummary, episode));
  }
}
