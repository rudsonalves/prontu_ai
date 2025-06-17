import 'package:prontu_ai/domain/models/attachment_model.dart';
import 'package:prontu_ai/utils/result.dart';

abstract interface class IAttachmentRepository {
  List<AttachmentModel> get attachments;

  Future<Result<void>> initialize();

  Future<Result<AttachmentModel>> insert(AttachmentModel user);

  Future<Result<AttachmentModel>> fetch(String uid, [bool forceRemote = false]);

  Future<Result<List<AttachmentModel>>> fetchAll();

  Future<Result<void>> update(AttachmentModel user);

  Future<Result<void>> delete(String uid);
}
