import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/config/composition_root.dart';
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
