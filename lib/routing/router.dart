import 'package:go_router/go_router.dart';
import 'package:prontu_ai/app_theme_mode.dart';
import 'package:prontu_ai/data/repositories/user/i_user_repository.dart';
import 'package:prontu_ai/ui/view/home/home_view_model.dart';
import 'package:provider/provider.dart';

import '/routing/routes.dart';
import '/ui/view/home/home_view.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.home.path,
  routes: [
    GoRoute(
      path: Routes.home.path,
      name: Routes.home.name,
      builder: (context, state) => HomeView(
        themeMode: context.read<AppThemeMode>(),
        viewModel: HomeViewModel(
          userRepository: context.read<IUserRepository>(),
        ),
      ),
    ),
  ],
);
