import 'dart:developer';

import '/data/common/tables.dart';
import '/data/services/database/database_service.dart';
import '/data/repositories/ai_summary/i_ai_summary_repository.dart';
import '/utils/result.dart';

class AiSummaryRepository implements IAiSummaryRepository {
  final DatabaseService _databaseService;

  AiSummaryRepository(this._databaseService);

  bool _started = false;

  @override
  Future<Result<void>> initialize() async {
    try {
      if (_started) return const Result.success(null);

      _started = true;

      return const Result.success(null);
    } on Exception catch (err, stack) {
      log('AiSummaryRepository.initialize', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  @override
  Future<Result<void>> delete(String uid) async {
    try {
      if (!_started) throw Exception('Repository not initialized');

      final result = await _databaseService.delete(Tables.aiSummaries, id: uid);

      return result;
    } on Exception catch (err, stack) {
      log('AiSummaryRepository.delete', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }
}
