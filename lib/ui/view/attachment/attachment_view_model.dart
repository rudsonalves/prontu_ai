import '/data/repositories/attachment/i_attachment_repository.dart';
import '/utils/command.dart';

class AttachmentViewModel {
  final IAttachmentRepository _attachmentRepository;

  AttachmentViewModel(this._attachmentRepository) {
    load = Command0<void>(_attachmentRepository.initialize)..execute();
  }

  late final Command0<void> load;
}
