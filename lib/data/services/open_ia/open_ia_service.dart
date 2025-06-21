import 'dart:convert';
import 'dart:developer';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '/domain/dtos/medical_record.dart';
import '/utils/result.dart';
import '/domain/dtos/episode_analysis.dart';

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

  Future<Result<EpisodeAnalysis>> analyze(MedicalRecord record) async {
    try {
      final prompt = _createPrompt(record);

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
      final specialist = parsed['especialista_medico'] as String?;
      final summary = parsed['situacao_clinica'] != null
          ? _parseSummary(parsed['situacao_clinica'])
          : _parseSummary(parsed['resumo_tecnico']);

      // final specialist = 'Gastro';
      // final summary = 'Paciente com dor de barriga';

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

  String _parseSummary(dynamic summary) {
    if (summary == null) return '';

    if (summary is String) {
      return summary;
    }

    if (summary is Map<String, dynamic>) {
      // Tenta acessar o campo mais comum para resumos
      if (summary.containsKey('summary') && summary['summary'] is String) {
        return summary['summary'] as String;
      }

      // Se não houver campo específico, tenta converter todo o Map para uma string formatada
      return summary.entries.map((e) => '${e.key}: ${e.value}').join('\n');
    }

    return summary.toString();
  }

  String _createPrompt(MedicalRecord record) {
    final episode = record.episode;

    final sessions = record.sessions;
    final attachments = record.attachments;

    if (record.sessions.isEmpty) {
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

    final buffer = StringBuffer();

    buffer.writeln('Você é um assistente médico virtual.');
    buffer.writeln(
      'Receberá informações clínicas de um paciente e deve gerar um resumo '
      'técnico da sessão.',
    );
    buffer.writeln('');
    buffer.writeln('📌 Episódio clínico:');
    buffer.writeln('- Título: ${episode.title}');
    buffer.writeln('- Peso (kg): ${episode.weight / 1000}');
    buffer.writeln('- Altura (m): ${episode.height / 100}');
    buffer.writeln('- Queixa principal: ${episode.mainComplaint}');
    buffer.writeln('- Histórico atual: ${episode.history ?? "Não informado"}');
    buffer.writeln('- Anamnese geral: ${episode.anamnesis ?? "Não informado"}');
    buffer.writeln('');

    buffer.writeln('📅 Sessões clínicas realizadas:');
    for (final session in sessions) {
      buffer.writeln('- Médico: ${session.doctor}');
      buffer.writeln('  Telefone: ${session.phone}');
      buffer.writeln('  Notas da sessão: ${session.notes}');
      buffer.writeln('  Data: ${session.createdAt.toIso8601String()}');
      buffer.writeln('');
    }

    if (attachments.isNotEmpty) {
      buffer.writeln('📎 Anexos recebidos:');
      for (final attachment in attachments) {
        buffer.writeln('- Nome: ${attachment.name}');
        buffer.writeln('  Caminho: ${attachment.path}');
        buffer.writeln('  Tipo: ${attachment.type.name}');
        buffer.writeln('  Data: ${attachment.createdAt.toIso8601String()}');
        buffer.writeln('');
      }
    } else {
      buffer.writeln('📎 Anexos: Nenhum anexo disponível.');
      buffer.writeln('');
    }

    buffer.writeln('---');
    buffer.writeln(
      'Com base nas informações acima, gere um **resumo técnico da situação '
      'do paciente**.',
    );
    buffer.writeln(
      'Não repita os dados. Apresente sua análise clínica em linguagem'
      ' natural.',
    );

    return buffer.toString();
  }
}
