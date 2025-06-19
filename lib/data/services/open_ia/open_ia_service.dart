import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '/domain/dtos/episode_analysis.dart';
import '/domain/models/episode_model.dart';

class OpenIaService {
  OpenIaService();

  late final OpenAIModelModel _model;

  bool _isStarted = false;

  Future<void> initalize() async {
    if (_isStarted) return;

    _isStarted = true;
    await dotenv.load(fileName: '.env');

    final apiKey = dotenv.env['OPEN_AI_API_KEY'] as String;

    if (apiKey.isEmpty) {
      throw Exception('OPEN_AI_API_KEY is not set');
    }

    OpenAI.apiKey = apiKey;
    OpenAI.organization = 'ProntuAI';
    OpenAI.requestsTimeOut = const Duration(seconds: 60);

    List<OpenAIModelModel> models = await OpenAI.instance.model.list();

    _model = models.first;
  }

  Future<EpisodeAnalysis> analyze(EpisodeModel episode) async {
    final prompt = _createPrompt(episode);

    final completion = await OpenAI.instance.completion.create(
      model: _model.toString(),
      prompt: prompt,
      temperature: 0.5,
      maxTokens: 20,
      n: 1,
      stop: ['\n'],
      echo: true,
      seed: 42,
      bestOf: 2,
    );

    final content = completion.choices.first.text.trim();
    final lines = content.split('\n');
    final specialist = lines.first.split(':').sublist(1).join(':').trim();
    final summary = lines.length > 1
        ? lines.sublist(1).join(' ').replaceFirst(RegExp(r'^[^:]*:\s*'), '')
        : '';

    return EpisodeAnalysis(
      recommendedSpecialist: specialist,
      clinicalSummary: summary,
    );
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
