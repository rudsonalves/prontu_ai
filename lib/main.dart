import 'package:flutter/material.dart';
import 'package:prontu_ai/config/composition_root.dart';
import 'package:provider/provider.dart';

import '/main_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dependencies = await compositionRoot();

  runApp(
    MultiProvider(
      providers: dependencies,
      child: const MainApp(),
    ),
  );
}
