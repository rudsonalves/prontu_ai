import 'package:prontu_ai/utils/result.dart';

abstract interface class IEpisodeRepository {
  Future<Result<void>> initialize();

  // Future<Result<String>> insert(EpisodeModel user);

  // Future<Result<EpisodeModel>> fetch(String uid);

  // Future<Result<List<EpisodeModel>>> fetchAll();

  // Future<Result<void>> update(EpisodeModel user);

  Future<Result<void>> delete(String uid);
}
