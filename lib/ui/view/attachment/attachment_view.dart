import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:prontu_ai/ui/core/ui/buttons/icon_back_button.dart';

import '/domain/models/episode_model.dart';
import '/domain/models/user_model.dart';
import '/routing/routes.dart';
import '/ui/core/ui/dialogs/app_snack_bar.dart';
import '/ui/core/ui/dialogs/botton_sheet_message.dart.dart';
import '/domain/models/attachment_model.dart';
import '/ui/core/theme/dimens.dart';
import '/ui/core/ui/dismissibles/dismissible_card.dart';
import '/utils/extensions/date_time_extensions.dart';
import '/domain/models/session_model.dart';
import '/ui/view/attachment/attachment_view_model.dart';

class AttachmentView extends StatefulWidget {
  final UserModel user;
  final EpisodeModel episode;
  final SessionModel session;
  final AttachmentViewModel viewModel;

  const AttachmentView({
    super.key,
    required this.user,
    required this.episode,
    required this.session,
    required this.viewModel,
  });

  @override
  State<AttachmentView> createState() => _AttachmentViewState();
}

class _AttachmentViewState extends State<AttachmentView> {
  late final AttachmentViewModel viewModel;

  @override
  void initState() {
    viewModel = widget.viewModel;

    viewModel.load.execute(widget.session.id!);

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
    final dimens = Dimens.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Exames: Dr ${widget.session.doctor}'),
        leading: const IconBackButton(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navFormAttachmentView,
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

            final attachments = viewModel.attachments;
            if (attachments.isEmpty) {
              return Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(dimens.paddingScreenAll),
                    child: const Text('Nenhum usuário cadastrado.'),
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: attachments.length,
              itemBuilder: (_, index) {
                final attachment = attachments[index];

                return DismissibleCard<AttachmentModel>(
                  title: attachment.path,
                  subtitle: attachment.createdAt.toDDMMYYYY(),
                  value: attachment,
                  editFunction: _editAttachment,
                  removeFunction: _removeAttachment,
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _navFormAttachmentView() {
    context.push(
      Routes.formAttachment.path,
      extra: {'session': widget.session},
    );
  }

  void _isDeleted() {
    if (viewModel.delete.isRunning) return;

    final result = viewModel.delete.result;
    if (result != null && result.isFailure) {
      showSnackError(
        context,
        'Ocorreu um erro ao remover o anexo.\n'
        'Favor tentar mais tarde.',
      );

      return;
    }

    showSnackSuccess(context, 'Anexo removido com sucesso.');

    setState(() {});
  }

  void _editAttachment(AttachmentModel attachment) {
    context.push(
      Routes.formAttachment.path,
      extra: {
        'session': widget.session,
        'attachment': attachment,
      },
    );
  }

  Future<bool> _removeAttachment(AttachmentModel attachment) async {
    final response =
        await BottonSheetMessage.show<bool?>(
          context,
          title: 'Remover Anexo',
          body: [
            'Deseja realmente remover o anexo **${attachment.path}**?',
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

    await viewModel.delete.execute(attachment.id!);
    return false;
  }
}
