import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/ui/core/ui/dialogs/botton_sheet_message.dart.dart';
import '/domain/enums/enums_declarations.dart';
import '/ui/core/ui/dialogs/app_snack_bar.dart';
import '/domain/models/user_model.dart';
import '/routing/routes.dart';
import '/ui/core/theme/dimens.dart';
import '/ui/core/ui/dismissibles/dismissible_card.dart';
import '/utils/extensions/date_time_extensions.dart';
import '/ui/view/home/home_view_model.dart';

class HomeView extends StatefulWidget {
  final HomeViewModel viewModel;

  const HomeView({
    super.key,
    required this.viewModel,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeViewModel viewModel;

  @override
  void initState() {
    viewModel = widget.viewModel;

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
        title: const Text('ProntuAI'),
        actions: [
          IconButton(
            icon: ListenableBuilder(
              listenable: viewModel.themeMode,
              builder: (_, __) => Icon(
                viewModel.isDark ? Icons.dark_mode : Icons.light_mode,
              ),
            ),
            onPressed: viewModel.toggleTheme,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navFormUserView,
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

            final users = viewModel.users;
            if (users.isEmpty) {
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
              itemCount: users.length,
              itemBuilder: (_, index) {
                final user = users[index];

                return DismissibleCard<UserModel>(
                  title: user.name,
                  subtitle: user.birthDate.toDDMMYYYY(),
                  value: user,
                  editFunction: _editUser,
                  removeFunction: _removeUser,
                  onTap: () => _navToEpisode(user),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _navToEpisode(UserModel user) {
    context.push(Routes.episode.path, extra: user);
  }

  void _editUser(UserModel user) {
    context.push(Routes.formUser.path, extra: user);
  }

  Future<bool> _removeUser(UserModel user) async {
    final genere = user.sex == Sex.male ? 'o' : 'a';
    final response =
        await BottonSheetMessage.show<bool?>(
          context,
          title: 'Remover usuário',
          body: [
            'Deseja realmente remover $genere usuári$genere **${user.name}**?',
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

    await viewModel.delete.execute(user.id!);
    return false;
  }

  void _navFormUserView() {
    context.push(Routes.formEpisode.path);
  }

  void _isDeleted() {
    if (viewModel.delete.isRunning) return;

    final result = viewModel.delete.result;
    if (result != null && result.isFailure) {
      showSnackError(
        context,
        'Ocorreu um erro ao remover o usuário.\n'
        'Favor tentar mais tarde.',
      );

      return;
    }

    showSnackSuccess(context, 'Usuário removido com sucesso.');

    setState(() {});
  }
}
