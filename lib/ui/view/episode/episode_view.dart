import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:prontu_ai/domain/models/episode_model.dart';
import 'package:prontu_ai/routing/routes.dart';
import 'package:prontu_ai/ui/core/theme/dimens.dart';
import 'package:prontu_ai/ui/core/ui/dialogs/app_snack_bar.dart';
import 'package:prontu_ai/ui/core/ui/dialogs/botton_sheet_message.dart.dart';
import 'package:prontu_ai/ui/core/ui/dismissibles/dismissible_card.dart';
import 'package:prontu_ai/utils/extensions/date_time_extensions.dart';

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

    viewModel.delete.addListener(_isDeleted);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Episódios de ${widget.user.name}'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navFormEpisodeView,
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

            final episodes = viewModel.episodes;
            if (episodes.isEmpty) {
              return Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(dimens.paddingScreenAll),
                    child: const Text('Nenhum episódio cadastrado.'),
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
                  subtitle: episode.createdAt.toDDMMYYYY(),
                  value: episode,
                  editFunction: _editAttachment,
                  removeFunction: _removeAttachment,
                  // onTap: () =>,
                );
              },
            );
          },
        ),
      ),
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
        'Remover episódio',
      );

      return;
    }
    showSnackSuccess(context, 'Removido com sucesso');

    setState(() {});
  }

  void _editAttachment(EpisodeModel episode) {
    context.push(Routes.formEpisode.path, extra: episode);
  }

  Future<bool> _removeAttachment(EpisodeModel episode) async {
    final response =
        await BottonSheetMessage.show<bool?>(
          context,
          title: 'Remover',
          body: [
            'Deseja realmente remover o **${episode.title}**?',
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
