import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '/ui/core/theme/dimens.dart';
import '/ui/core/ui/buttons/big_button.dart';
import '/ui/core/ui/editing_controllers/currency_editing_controller.dart';
import '/utils/validates/generic_validations.dart';
import '/domain/models/user_model.dart';
import '/ui/core/ui/form_fields/basic_form_field.dart';
import '/domain/models/episode_model.dart';
import '/ui/view/episode/form_episode/form_episode_view_model.dart';

class FormEpisodeView extends StatefulWidget {
  final UserModel user;
  final EpisodeModel? episode;
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
  final _weightController = CurrencyEditingController();
  final _heightController = CurrencyEditingController();
  final _mainComplaintController = TextEditingController();
  final _historyController = TextEditingController();
  final _anamnesisController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    viewModel = widget.viewModel;

    viewModel.insert.addListener(_isSaved);
    viewModel.update.addListener(_isSaved);

    if (widget.episode != null) {
      _initializeForm();
    }

    super.initState();
  }

  @override
  void dispose() {
    viewModel.insert.removeListener(_isSaved);
    viewModel.update.removeListener(_isSaved);

    _titleController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _mainComplaintController.dispose();
    _historyController.dispose();
    _anamnesisController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Editar Evento' : 'Criar Evento',
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(dimens.paddingScreenAll),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: dimens.spacingVertical * 3,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BasicFormField(
                labelText: 'Título',
                hintText: 'Entre um título para o evento.',
                controller: _titleController,
                validator: GenericValidations.notEmpty,
                textCapitalization: TextCapitalization.words,
                prefixIconData: Symbols.docs_rounded,
              ),

              BasicFormField(
                labelText: 'Peso (Kg)',
                hintText: 'Informe o peso em quilogramas.',
                controller: _weightController,
                keyboardType: TextInputType.number,
                validator: GenericValidations.isDouble,
                prefixIconData: Symbols.weight_rounded,
              ),

              BasicFormField(
                labelText: 'Altura (m)',
                hintText: 'Informe a altura em metros.',
                controller: _heightController,
                keyboardType: TextInputType.number,
                validator: GenericValidations.isDouble,
                prefixIconData: Symbols.height_rounded,
              ),

              BasicFormField(
                labelText: 'Queixa Principal',
                hintText: 'Informe a queixa principal.',
                controller: _mainComplaintController,
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                maxLines: null,
                validator: GenericValidations.notEmpty,
                prefixIconData: Symbols.medical_services_rounded,
              ),

              BasicFormField(
                labelText: 'Histórico',
                hintText: 'Informe o histórico.',
                controller: _historyController,
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                maxLines: null,
                validator: GenericValidations.notEmpty,
                prefixIconData: Symbols.history_rounded,
              ),

              BasicFormField(
                labelText: 'Anamnese',
                hintText: 'Informe a anamnese.',
                controller: _anamnesisController,
                textCapitalization: TextCapitalization.words,
                minLines: 1,
                maxLines: null,
                validator: GenericValidations.notEmpty,
                prefixIconData: Symbols.mixture_med_rounded,
              ),

              ListenableBuilder(
                listenable: Listenable.merge([
                  viewModel.insert,
                  viewModel.update,
                ]),
                builder: (context, _) => BigButton(
                  iconData: _isEditing ? Symbols.edit : Symbols.save,
                  isRunning:
                      viewModel.insert.isRunning || viewModel.update.isRunning,
                  onPressed: _saveForm,
                  label: _isEditing ? 'Editar' : 'Salvar',
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _isSaved() {
    if (viewModel.insert.isRunning || viewModel.update.isRunning) return;

    final result = _isEditing
        ? viewModel.update.result
        : viewModel.insert.result;

    if (result == null || result.isFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ocorreu um erro ao salvar o evento.\n'
            'Favor, tente mais tarde.',
          ),
        ),
      );
      return;
    }

    Navigator.pop(context);
  }

  void _initializeForm() {
    final episode = widget.episode!;

    final weight = (episode.weight / 1000).toStringAsFixed(2);
    final height = (episode.height / 100).toStringAsFixed(2);

    _titleController.text = episode.title;
    _weightController.text = weight;
    _heightController.text = height;
    _mainComplaintController.text = episode.mainComplaint;
    _historyController.text = episode.history ?? '';
    _anamnesisController.text = episode.anamnesis ?? '';

    _isEditing = true;

    setState(() {});
  }

  Future<void> _saveForm() async {
    if (viewModel.insert.isRunning || viewModel.update.isRunning) return;

    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    final int weight = (1000 * _weightController.currencyValue).round();
    final int height = (100 * _heightController.currencyValue).round();

    final newEpisode = EpisodeModel(
      id: widget.episode?.id,
      userId: widget.user.id!,
      title: _titleController.text.trim(),
      weight: weight,
      height: height,
      mainComplaint: _mainComplaintController.text.trim(),
      history: _historyController.text.trim(),
      anamnesis: _anamnesisController.text.trim(),
      createdAt: widget.episode?.createdAt,
    );

    _isEditing
        ? viewModel.update.execute(newEpisode)
        : viewModel.insert.execute(newEpisode);
  }
}
