import '/domain/models/attachment_model.dart';
import '/domain/models/episode_model.dart';
import '/domain/models/session_model.dart';

class MedicalRecord {
  final EpisodeModel episode;
  final List<SessionModel> sessions;
  final List<AttachmentModel> attachments;

  MedicalRecord({
    required this.episode,
    required this.sessions,
    required this.attachments,
  });
}
