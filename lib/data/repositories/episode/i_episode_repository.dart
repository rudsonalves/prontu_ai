import 'package:prontu_ai/domain/models/episode_model.dart';
import 'package:prontu_ai/utils/result.dart';

abstract interface class IEpisodeRepository {
  List<EpisodeModel> get episodes;

  Future<Result<void>> initialize(String userId);

  Future<Result<EpisodeModel>> insert(EpisodeModel episode);

  Future<Result<EpisodeModel>> fetch(String uid, [bool forceRemote = false]);

  Future<Result<List<EpisodeModel>>> fetchAll();

  Future<Result<void>> update(EpisodeModel episode);

  Future<Result<void>> delete(String uid);
}
