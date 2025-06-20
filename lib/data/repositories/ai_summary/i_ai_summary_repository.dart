import '/domain/models/ai_summary_model.dart';
import '/utils/result.dart';

abstract interface class IAiSummaryRepository {
  List<AiSummaryModel> get aiSummaries;

  Future<Result<void>> initialize();

  Future<Result<AiSummaryModel>> insert(AiSummaryModel aiSummary);

  Future<Result<AiSummaryModel>> fetch(String uid, [bool forceRemote = false]);

  Future<Result<List<AiSummaryModel>>> fetchAll();

  Future<Result<void>> update(AiSummaryModel aiSummary);

  Future<Result<void>> delete(String uid);
}
