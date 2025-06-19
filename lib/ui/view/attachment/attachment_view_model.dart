import '/domain/models/attachment_model.dart';
import '/data/repositories/attachment/i_attachment_repository.dart';
import '/utils/command.dart';

class AttachmentViewModel {
  final IAttachmentRepository _attachmentRepository;

  AttachmentViewModel(this._attachmentRepository) {
    load = Command0<void>(_attachmentRepository.initialize)..execute();
    delete = Command1<void, String>(_attachmentRepository.delete);
  }

  late final Command0<void> load;
  late final Command1<void, String> delete;

  List<AttachmentModel> get attachments => _attachmentRepository.attachments;
}
