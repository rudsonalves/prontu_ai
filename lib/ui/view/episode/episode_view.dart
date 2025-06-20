import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:prontu_ai/ui/core/ui/dialogs/simple_dialog.dart';

import '/domain/models/episode_model.dart';
import '/ui/core/ui/buttons/icon_back_button.dart';
import '/ui/core/ui/dialogs/app_snack_bar.dart';
import '/ui/core/ui/dialogs/botton_sheet_message.dart.dart';
import '/ui/core/ui/dismissibles/dismissible_card.dart';
import '/routing/routes.dart';
import '/ui/core/theme/dimens.dart';
import '/domain/models/user_model.dart';
import '/ui/view/episode/episode_view_model.dart';

class EpisodeView extends StatefulWidget {
  final UserModel user;
  final EpisodeViewModel viewModel;

  const EpisodeView({
    super.key,
    required this.user,
    required this.viewModel,
  });

  @override
  State<EpisodeView> createState() => _EpisodeViewState();
}

class _EpisodeViewState extends State<EpisodeView> {
  late final EpisodeViewModel viewModel;

  @override
  void initState() {
    viewModel = widget.viewModel;

    viewModel.load.execute(widget.user.id!);

    viewModel.delete.addListener(_isDeleted);
    viewModel.analise.addListener(_showIAAssistant);

    super.initState();
  }

  @override
  void dispose() {
    viewModel.delete.removeListener(_isDeleted);
    viewModel.analise.removeListener(_showIAAssistant);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos de ${widget.user.name}'),
        leading: const IconBackButton(),
        actions: [
          IconButton(
            onPressed: _showHelpMessage,
            icon: const Icon(Symbols.question_mark_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navFormEpisodeView,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.all(dimens.paddingScreenAll),
        child: ListenableBuilder(
          listenable: viewModel.load,
          builder: (context, _) {
            if (viewModel.load.isRunning) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final episodes = viewModel.episodes;
            if (episodes.isEmpty) {
              return Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(dimens.paddingScreenAll),
                    child: const Text('Nenhum Evento cadastrado.'),
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: episodes.length,
              itemBuilder: (_, index) {
                final episode = episodes[index];

                return DismissibleCard<EpisodeModel>(
                  title: episode.title,
                  subtitle:
                      'Peso: ${episode.weight / 1000} kg |'
                      ' Altura: ${episode.height / 100} m',
                  value: episode,
                  trailing: ListenableBuilder(
                    listenable: viewModel.analise,
                    builder: (context, _) => IconButton(
                      onPressed: () => _checkIAAssistant(episode),
                      icon: viewModel.analise.isRunning
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(),
                            )
                          : Icon(
                              Symbols.medical_services_rounded,
                              color: colorScheme.primary,
                            ),
                    ),
                  ),
                  editFunction: _editEpisode,
                  removeFunction: _removeEpisode,
                  onTap: () => _navToSessionView(episode),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _checkIAAssistant(EpisodeModel episode) {
    if (viewModel.analise.isRunning) return;

    viewModel.analise.execute(episode);
  }

  void _showIAAssistant() {
    if (viewModel.analise.isRunning) return;

    final result = viewModel.analise.result;
    if (result != null && result.isFailure) {
      showSnackError(
        context,
        'Ocorreu um erro ao analisar o evento.\n'
        'Favor tentar mais tarde.',
      );
    }

    showSnackSuccess(
      context,
      message: 'Evento analisado com sucesso.',
    );
  }

  void _showHelpMessage() {
    final texts = [
      'Aqui abre as ocorrências de **Eventos Médicos**, situações que'
          ' necessitem de uma intervenção médica. '
          'As ações disponíveis nesta página são:',
      '- Toque no botão flutuante "**+**" para adicionar um novo usuário.',
      '- Toque num usuário para criar um **novo Evento Médico**.',
      '> Arraste para **à Direita** para **Editar** o usuário.',
      '< Arraste para **à Esquerda** para **Remover** o usuário.',
      '- Toque no botão **maletinha** do evento para orientações do '
          'assitente virtual.',
    ];

    showSimpleMessage(
      context,
      iconTitle: Symbols.help_rounded,
      title: 'Eventos Médicos',
      body: texts,
    );
  }

  void _navToSessionView(EpisodeModel episode) {
    context.push(
      Routes.session.path,
      extra: {'user': widget.user, 'episode': episode},
    );
  }

  void _navFormEpisodeView() {
    context.push(Routes.formEpisode.path, extra: {'user': widget.user});
  }

  void _isDeleted() {
    if (viewModel.delete.isRunning) return;

    final result = viewModel.delete.result;
    if (result != null && result.isFailure) {
      showSnackError(
        context,
        'Ocorreu um erro ao remover o evento.\n'
        'Favor tentar mais tarde.',
      );

      return;
    }

    showSnackSuccess(context, message: 'Evento removido com sucesso.');

    setState(() {});
  }

  void _editEpisode(EpisodeModel episode) {
    context.push(
      Routes.formEpisode.path,
      extra: {
        'user': widget.user,
        'episode': episode,
      },
    );
  }

  Future<bool> _removeEpisode(EpisodeModel episode) async {
    final response =
        await BottonSheetMessage.show<bool?>(
          context,
          title: 'Remover Evento',
          body: [
            'Deseja realmente remover o evento **${episode.title}**?',
          ],
          buttons: [
            ButtonSignature(
              label: 'Sim',
              onPressed: () => true,
            ),
            ButtonSignature(
              label: 'Não',
              onPressed: () => false,
            ),
          ],
        ) ??
        false;

    if (!response) return false;

    await viewModel.delete.execute(episode.id!);
    return false;
  }
}
