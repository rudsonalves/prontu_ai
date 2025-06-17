import 'package:flutter/material.dart';
import 'package:prontu_ai/app_theme_mode.dart';
import 'package:prontu_ai/ui/view/home/home_view_model.dart';

class HomeView extends StatefulWidget {
  final AppThemeMode themeMode;
  final HomeViewModel viewModel;

  const HomeView({
    super.key,
    required this.themeMode,
    required this.viewModel,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ProntuAI'),
        actions: [
          IconButton(
            icon: ListenableBuilder(
              listenable: widget.themeMode,
              builder: (_, __) => Icon(
                widget.themeMode.isDark ? Icons.dark_mode : Icons.light_mode,
              ),
            ),
            onPressed: widget.themeMode.toggle,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text('ProntuAI Home View'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
