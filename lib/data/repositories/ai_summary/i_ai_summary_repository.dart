import 'package:prontu_ai/utils/result.dart';

abstract interface class IAiSummaryRepository {
  Future<Result<void>> initialize();

  // Future<Result<String>> insert(AiSummaryModel user);

  // Future<Result<AiSummaryModel>> fetch(String uid);

  // Future<Result<List<AiSummaryModel>>> fetchAll();

  // Future<Result<void>> update(AiSummaryModel user);

  Future<Result<void>> delete(String uid);
}
