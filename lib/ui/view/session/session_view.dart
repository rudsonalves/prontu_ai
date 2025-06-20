import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:prontu_ai/ui/core/ui/dialogs/simple_dialog.dart';

import '/domain/models/session_model.dart';
import '/routing/routes.dart';
import '/ui/core/theme/dimens.dart';
import '/ui/core/ui/dialogs/app_snack_bar.dart';
import '/ui/core/ui/dialogs/botton_sheet_message.dart.dart';
import '/ui/core/ui/dismissibles/dismissible_card.dart';
import '/utils/extensions/date_time_extensions.dart';
import '/domain/models/user_model.dart';
import '/domain/models/episode_model.dart';
import '/ui/view/session/session_view_model.dart';

class SessionView extends StatefulWidget {
  final UserModel user;
  final EpisodeModel episode;
  final SessionViewModel viewModel;

  const SessionView({
    super.key,
    required this.user,
    required this.episode,
    required this.viewModel,
  });

  @override
  State<SessionView> createState() => _SessionViewState();
}

class _SessionViewState extends State<SessionView> {
  late final SessionViewModel viewModel;

  @override
  void initState() {
    viewModel = widget.viewModel;

    viewModel.load.execute(widget.episode.id!);

    viewModel.delete.addListener(_isDeleted);

    super.initState();
  }

  @override
  void dispose() {
    viewModel.delete.removeListener(_isDeleted);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dimens = Dimens.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Consultas: ${widget.episode.title}'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded),
        ),
        actions: [
          IconButton(
            onPressed: _showHelpMessage,
            icon: const Icon(Symbols.question_mark_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navFormSessionView,
        child: const Icon(Symbols.add_rounded),
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

            final sessions = viewModel.sessions;
            if (sessions.isEmpty) {
              return Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(dimens.paddingScreenAll),
                    child: const Text('Nenhum Sessão cadastrada.'),
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (_, index) {
                final session = sessions[index];

                return DismissibleCard<SessionModel>(
                  title: '${session.doctor} - ${session.phone}',
                  leading: Icon(
                    Symbols.stethoscope_rounded,
                    color: colorScheme.primary,
                  ),
                  subtitle: session.createdAt.toBrDateTime(),
                  value: session,
                  editFunction: _editSession,
                  removeFunction: _removeSession,
                  onTap: () => _navToAttachmentView(session),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showHelpMessage() {
    final texts = [
      'Aqui você pode registrar as consultas realizadas no tratamento. '
          'As ações disponíveis nesta página são:',
      '- Toque no botão flutuante "**+**" para adicionar um novo usuário.',
      '- Toque numa colsulta para adicionar **novos Exames**.',
      '> Arraste para **à Direita** para **Editar** a consulta.',
      '< Arraste para **à Esquerda** para **Remover** a consulta.',
    ];

    showSimpleMessage(
      context,
      iconTitle: Symbols.help_rounded,
      title: 'Consultas',
      body: texts,
    );
  }

  void _navToAttachmentView(SessionModel session) {
    context.push(
      Routes.attachment.path,
      extra: {
        'user': widget.user,
        'episode': widget.episode,
        'session': session,
      },
    );
  }

  void _editSession(SessionModel session) {
    context.push(
      Routes.formSession.path,
      extra: {
        'episode': widget.episode,
        'session': session,
      },
    );
  }

  void _navFormSessionView() {
    context.push(Routes.formSession.path, extra: {'episode': widget.episode});
  }

  void _isDeleted() {
    if (viewModel.delete.isRunning) return;

    final result = viewModel.delete.result;
    if (result != null && result.isFailure) {
      showSnackError(
        context,
        'Ocorreu um erro ao remover a sessão.\n'
        'Favor tentar mais tarde.',
      );

      return;
    }

    showSnackSuccess(context, message: 'Sessão removida com sucesso.');

    setState(() {});
  }

  Future<bool> _removeSession(SessionModel session) async {
    final response =
        await BottonSheetMessage.show<bool?>(
          context,
          title: 'Remover Anexo',
          body: [
            'Deseja realmente remover a sessão **${session.doctor}**?',
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

    await viewModel.delete.execute(session.id!);
    return false;
  }
}
