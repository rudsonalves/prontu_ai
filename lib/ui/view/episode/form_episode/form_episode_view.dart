import 'package:flutter/material.dart';
import 'package:prontu_ai/domain/models/user_model.dart';
import 'package:prontu_ai/ui/core/ui/form_fields/basic_form_field.dart';

import '/domain/models/episode_model.dart';
import '/ui/view/episode/form_episode/form_episode_view_model.dart';

class FormEpisodeView extends StatefulWidget {
  final EpisodeModel? episode;
  final UserModel user;
  final FormEpisodeViewModel viewModel;

  const FormEpisodeView({
    super.key,
    this.episode,
    required this.user,
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
  final _historyController = TextEditingController();
  final _anamnesisController = TextEditingController();

  @override
  void initState() {
    viewModel = widget.viewModel;

    if (widget.episode != null) {
      _initializeForm();
    }

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _mainComplaintController.dispose();
    _historyController.dispose();
    _anamnesisController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (viewModel.insert.isRunning || viewModel.update.isRunning) return;

    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    final newEpisode = EpisodeModel(
      id: widget.episode?.id,
      userId: widget.user.id!,
      title: _titleController.text.trim(),
      weight: 1000 * (int.tryParse(_weightController.text.trim()) ?? 0),
      height: 100 * (int.tryParse(_heightController.text.trim()) ?? 0),
      mainComplaint: _mainComplaintController.text.trim(),
      history: _historyController.text.trim(),
      anamnesis: _anamnesisController.text.trim(),
      createdAt: widget.episode?.createdAt,
    );

    viewModel.insert.execute(newEpisode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.episode == null ? 'Novo Episódio' : 'Editar Episódio',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe o título' : null,
              ),

              BasicFormField(
                labelText: 'Peso (Kg)',
                controller: _weightController,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe o peso';
                  if (int.tryParse(v) == null)
                    return 'Informe um número válido';
                  return null;
                },
              ),

              BasicFormField(
                controller: _heightController,
                labelText: 'Altura (cm)',
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.words,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe a altura';
                  if (int.tryParse(v) == null)
                    return 'Informe um número válido';
                  return null;
                },
              ),

              BasicFormField(
                controller: _mainComplaintController,
                textCapitalization: TextCapitalization.words,
                labelText: 'Queixa Principal',
                validator: (v) => (v == null || v.isEmpty)
                    ? 'Informe a queixa principal'
                    : null,
              ),

              BasicFormField(
                controller: _historyController,
                labelText: 'Histórico',
                textCapitalization: TextCapitalization.words,
                maxLines: 3,
              ),

              BasicFormField(
                controller: _anamnesisController,
                textCapitalization: TextCapitalization.words,
                labelText: 'Anamnese',
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _initializeForm() {
    final episode = widget.episode!;

    _titleController.text = episode.title;
    _weightController.text = (episode.weight / 1000).toStringAsFixed(2);
    _heightController.text = (episode.height / 100).toStringAsFixed(2);
    _mainComplaintController.text = episode.mainComplaint;
    _historyController.text = episode.history;
    _anamnesisController.text = episode.anamnesis;

    setState(() {});
  }
}
