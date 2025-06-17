import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/app_theme_mode.dart';
import '/ui/core/theme/fonts.dart';
import '/ui/core/theme/theme.dart';
import '/ui/core/theme/util.dart';
import '/routing/router.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late TextTheme textTheme;
  late MaterialTheme theme;
  late AppThemeMode themeMode;
  late final GoRouter _router;

  @override
  void initState() {
    _router = router();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    textTheme = createTextTheme(context, FontsTheme.body, FontsTheme.display);
    theme = MaterialTheme(textTheme);
    themeMode = context.read<AppThemeMode>();
    themeMode.addListener(_updateTheme);
  }

  void _updateTheme() {
    setState(() {});
  }

  @override
  void dispose() {
    themeMode.removeListener(_updateTheme);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MaterialApp.router(
      theme: theme.light().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primaryContainer,
          elevation: 5,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: colorScheme.primaryFixed,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: colorScheme.outline),
          // labelStyle: TextStyle(color: colorScheme.onPrimary),
        ),
      ),
      darkTheme: theme.dark().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.onPrimaryContainer,
          elevation: 5,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: colorScheme.onSecondaryContainer,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: colorScheme.outline),
          // labelStyle: TextStyle(color: colorScheme.onPrimary),
        ),
      ),
      themeMode: themeMode.themeMode,
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
