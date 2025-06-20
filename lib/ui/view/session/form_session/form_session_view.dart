import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '/ui/core/ui/buttons/icon_back_button.dart';
import '/ui/core/ui/editing_controllers/masked_editing_controller.dart';
import '/ui/core/ui/form_fields/basic_form_field.dart';
import '/utils/validates/generic_validations.dart';
import '/ui/core/theme/dimens.dart';
import '/ui/core/ui/buttons/big_button.dart';
import '/domain/models/episode_model.dart';
import '/domain/models/session_model.dart';
import '/ui/view/session/form_session/form_session_view_model.dart';

class FormSessionView extends StatefulWidget {
  final EpisodeModel episode;
  final SessionModel? session;
  final FormSessionViewModel viewModel;

  const FormSessionView({
    super.key,
    this.session,
    required this.episode,
    required this.viewModel,
  });

  @override
  State<FormSessionView> createState() => _FormSessionViewState();
}

class _FormSessionViewState extends State<FormSessionView> {
  late final FormSessionViewModel viewModel;
  final _formKey = GlobalKey<FormState>();

  final _doctorController = TextEditingController();
  final _phoneController = MaskedEditingController(mask: '(##) #####-####');
  final _notesController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    viewModel = widget.viewModel;

    viewModel.insert.addListener(_isSaved);
    viewModel.update.addListener(_isSaved);

    if (widget.session != null) {
      _initializeForm();
    }

    super.initState();
  }

  @override
  void dispose() {
    viewModel.insert.removeListener(_isSaved);
    viewModel.update.removeListener(_isSaved);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Seção' : 'Criar Seção'),
        leading: const IconBackButton(),
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
                labelText: 'Dr(a).',
                hintText: 'Nome do seu médico.',
                controller: _doctorController,
                textCapitalization: TextCapitalization.words,
                validator: GenericValidations.name,
                prefixIconData: Symbols.docs_rounded,
              ),
              BasicFormField(
                labelText: 'Telefone de Contato',
                hintText: 'Telefone de contato ou consultório.',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: GenericValidations.name,
                prefixIconData: Symbols.docs_rounded,
              ),
              BasicFormField(
                labelText: 'Notas',
                hintText: 'Adicione as notas de se médico.',
                controller: _notesController,
                minLines: 1,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                validator: GenericValidations.name,
                prefixIconData: Symbols.docs_rounded,
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
            'Ocorreu um erro ao salvar a seção.\n'
            'Favor, tente mais tarde.',
          ),
        ),
      );
      return;
    }

    Navigator.pop(context);
  }

  void _initializeForm() {
    final session = widget.session!;

    _doctorController.text = session.doctor;
    _phoneController.text = session.phone;
    _notesController.text = session.notes;

    _isEditing = true;

    setState(() {});
  }

  void _saveForm() {
    if (viewModel.insert.isRunning || viewModel.update.isRunning) return;

    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    final attachment = SessionModel(
      id: widget.session?.id,
      episodeId: widget.episode.id!,
      doctor: _doctorController.text.trim(),
      phone: _phoneController.text.trim(),
      notes: _notesController.text.trim(),
    );

    _isEditing
        ? viewModel.update.execute(attachment)
        : viewModel.insert.execute(attachment);
  }
}
