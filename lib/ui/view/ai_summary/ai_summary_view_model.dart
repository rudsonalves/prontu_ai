import '/data/repositories/ai_summary/i_ai_summary_repository.dart';
import '/utils/command.dart';

class AiSummaryViewModel {
  final IAiSummaryRepository _aiSummaryRepository;

  AiSummaryViewModel(this._aiSummaryRepository) {
    load = Command0<void>(_aiSummaryRepository.initialize)..execute();
  }

  late final Command0<void> load;
}
