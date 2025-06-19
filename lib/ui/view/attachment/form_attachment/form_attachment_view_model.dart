import '/data/repositories/attachment/i_attachment_repository.dart';
import '/domain/models/attachment_model.dart';
import '/utils/command.dart';

class FormAttachmentViewModel {
  final IAttachmentRepository _attachmentRepository;

  FormAttachmentViewModel(this._attachmentRepository) {
    insert = Command1<AttachmentModel, AttachmentModel>(
      _attachmentRepository.insert,
    );
    update = Command1<void, AttachmentModel>(_attachmentRepository.update);
  }

  late final Command1<AttachmentModel, AttachmentModel> insert;
  late final Command1<void, AttachmentModel> update;
}
