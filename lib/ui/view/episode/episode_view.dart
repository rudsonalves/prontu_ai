import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:prontu_ai/routing/routes.dart';
import 'package:prontu_ai/ui/core/theme/dimens.dart';

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
    super.initState();
    viewModel = widget.viewModel;
    viewModel.load.execute();
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
        onPressed: _navEpisodeView,
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
                    child: const Text('Nenhum episódio cadastrado.'),
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: episodes.length,
              itemBuilder: (_, index) {
                final episode = episodes[index];
                return ListTile(
                  title: Text(episode.title),
                  subtitle: Text(
                    'Peso: ${episode.weight}g | Altura: ${episode.height}cm',
                  ),
                  onTap: () {
                    // Ex: navegar para a view de sessões do episódio
                    // context.push(Routes.session.path, extra: episode);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _navEpisodeView() {
    context.push(
      Routes.formEpisode.path,
      extra: {'user_id': widget.user.id},
    );
  }
}
