import 'package:go_router/go_router.dart';
import 'package:prontu_ai/domain/models/user_model.dart';
import 'package:provider/provider.dart';

import '/ui/view/home/form_user/form_user_view.dart';
import '/ui/view/home/form_user/form_user_view_model.dart';
import '/app_theme_mode.dart';
import '/data/repositories/user/i_user_repository.dart';
import '/ui/view/home/home_view_model.dart';
import '/routing/routes.dart';
import '/ui/view/home/home_view.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.home.path,
  routes: [
    GoRoute(
      path: Routes.home.path,
      name: Routes.home.name,
      builder: (context, state) => HomeView(
        viewModel: HomeViewModel(
          userRepository: context.read<IUserRepository>(),
          themeMode: context.read<AppThemeMode>(),
        ),
      ),
    ),
    GoRoute(
      path: Routes.user.path,
      name: Routes.user.name,
      builder: (context, state) => FormUserView(
        user: state.extra as UserModel?,
        viewModel: FormUserViewModel(
          userRepository: context.read<IUserRepository>(),
        ),
      ),
    ),
  ],
);
