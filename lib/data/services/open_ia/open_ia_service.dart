import 'dart:convert';
import 'dart:developer';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:prontu_ai/utils/result.dart';

import '/domain/dtos/episode_analysis.dart';
import '/domain/models/episode_model.dart';

class OpenIaService {
  OpenIaService();

  late final OpenAIModelModel _model;

  bool _isStarted = false;

  Future<Result<void>> initialize() async {
    if (_isStarted) return const Result.success(null);
    _isStarted = true;

    try {
      await dotenv.load(fileName: '.env');

      final apiKey = dotenv.env['OPEN_AI_API_KEY'] as String;

      if (apiKey.isEmpty) {
        throw Exception('OPEN_AI_API_KEY is not set');
      }

      OpenAI.apiKey = apiKey;
      // OpenAI.organization = 'ProntuAI';
      OpenAI.requestsTimeOut = const Duration(seconds: 60);

      List<OpenAIModelModel> models = await OpenAI.instance.model.list();

      _model = models.firstWhere((m) => m.id == 'gpt-3.5-turbo');
      return const Result.success(null);
    } on Exception catch (err, stack) {
      log('OpenIaService.initialize', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  Future<Result<EpisodeAnalysis>> analyze(EpisodeModel episode) async {
    try {
      final prompt = _createPrompt(episode);

      final systemMessage = OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            'return any message you are given as JSON.',
          ),
        ],
        role: OpenAIChatMessageRole.assistant,
      );

      final userMessage = OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt),
        ],
        role: OpenAIChatMessageRole.user,
      );

      final requestMessages = [
        systemMessage,
        userMessage,
      ];

      final chatCompletion = await OpenAI.instance.chat.create(
        model: _model.id,
        responseFormat: {'type': 'json_object'},
        seed: 6,
        messages: requestMessages,
        temperature: 0.2,
        maxTokens: 500,
      );

      final fragments = chatCompletion.choices.first.message.content!;
      final fullJsonString = fragments.map((item) => item.text ?? '').join('');

      final Map<String, dynamic> parsed = jsonDecode(fullJsonString);
      final specialist = parsed['especialista_medico'] as String;
      final summary = parsed['situacao_clinica'] as String;

      return Result.success(
        EpisodeAnalysis(
          recommendedSpecialist: specialist,
          clinicalSummary: summary,
        ),
      );
    } on Exception catch (err, stack) {
      log('OpenIaService.analyze', error: err, stackTrace: stack);
      return Result.failure(err);
    }
  }

  String _createPrompt(EpisodeModel episode) {
    return '''
Você é um assistente médico virtual. Receberá as seguintes informações de um paciente:
- Peso (kg): ${episode.weight / 1000}
- Altura (m): ${episode.height / 100}
- Queixa principal: ${episode.mainComplaint}
- Histórico atual: ${episode.history}
- Anamnese geral: ${episode.anamnesis}

1. Indique o especialista médico mais adequado.
2. Apresente uma visão geral sucinta da situação clínica (2–3 frases).

Responda em linguagem técnica e concisa.
''';
  }
}
