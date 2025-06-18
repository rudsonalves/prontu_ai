import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// ShellRoute repositoryShellRoute<T>({
//   required T Function(BuildContext context, GoRouterState state) create,
//   required List<RouteBase> routes,
// }) {
//   return ShellRoute(
//     builder: (context, state, child) {
//       final repository = create(context, state);
//       return RepositoryScope<T>(repository: repository, child: child);
//     },
//     routes: routes,
//   );
// }

// T requireExtraAs<T>(GoRouterState state) {
//   final extra = state.extra;
//   assert(extra is T, 'Expected ${T.toString()} in state.extra');
//   return extra as T;
// }

class RepositoryScope<T> extends InheritedWidget {
  final T repository;

  const RepositoryScope({
    required this.repository,
    required super.child,
    super.key,
  });

  static T of<T>(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<RepositoryScope<T>>();
    assert(scope != null, 'RepositoryScope<$T> not found in context');
    return scope!.repository;
  }

  @override
  bool updateShouldNotify(covariant RepositoryScope<T> oldWidget) {
    return repository != oldWidget.repository;
  }
}
