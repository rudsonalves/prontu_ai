import 'package:flutter/material.dart';
import 'package:prontu_ai/ui/core/ui/form_fields/basic_form_field.dart';

import '/domain/models/episode_model.dart';
import '/ui/view/episode/form_episode/form_episode_view_model.dart';

class FormEpisodeView extends StatefulWidget {
  final EpisodeModel? episode;
  final String userId;
  final FormEpisodeViewModel viewModel;

  const FormEpisodeView({
    super.key,
    this.episode,
    required this.userId,
    required this.viewModel,
  });

  @override
  State<FormEpisodeView> createState() => _FormEpisodeViewState();
}

class _FormEpisodeViewState extends State<FormEpisodeView> {
  late final FormEpisodeViewModel viewModel;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _mainComplaintController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Episódio"),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BasicFormField(),
            ],
          ),
        ),
      ),
    );
  }
}
