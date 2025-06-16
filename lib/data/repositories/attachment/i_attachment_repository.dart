import 'package:prontu_ai/utils/result.dart';

abstract interface class IAttachmentRepository {
  Future<Result<void>> initialize();

  // Future<Result<String>> insert(attachmentModel user);

  // Future<Result<attachmentModel>> fetch(String uid);

  // Future<Result<List<attachmentModel>>> fetchAll();

  // Future<Result<void>> update(attachmentModel user);

  Future<Result<void>> delete(String uid);
}
