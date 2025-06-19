import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:prontu_ai/domain/models/episode_model.dart';
import 'package:prontu_ai/domain/models/session_model.dart';
import 'package:prontu_ai/domain/models/user_model.dart';

import '/ui/core/ui/buttons/big_button.dart';
import '/ui/core/ui/form_fields/enum_form_field.dart';
import '/domain/enums/enums_declarations.dart';
import '/ui/core/theme/dimens.dart';
import '/ui/core/ui/form_fields/basic_form_field.dart';
import '/utils/validates/generic_validations.dart';
import '/domain/models/attachment_model.dart';
import '/ui/view/attachment/form_attachment/form_attachment_view_model.dart';

class FormAttachmentView extends StatefulWidget {
  final UserModel user;
  final EpisodeModel episode;
  final SessionModel session;
  final AttachmentModel? attachment;
  final FormAttachmentViewModel viewModel;

  const FormAttachmentView({
    super.key,
    this.attachment,
    required this.user,
    required this.episode,
    required this.session,
    required this.viewModel,
  });

  @override
  State<FormAttachmentView> createState() => _FormAttachmentViewState();
}

class _FormAttachmentViewState extends State<FormAttachmentView> {
  late final FormAttachmentViewModel viewModel;
  final _formKey = GlobalKey<FormState>();
  final _namecontroller = TextEditingController();
  final _pathController = TextEditingController();

  AttachmentType? _type;
  bool _isEditing = false;

  @override
  void initState() {
    viewModel = widget.viewModel;

    viewModel.insert.addListener(_isSaved);
    viewModel.update.addListener(_isSaved);

    _initializeForm();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.insert.removeListener(_isSaved);
    viewModel.update.removeListener(_isSaved);

    _namecontroller.dispose();
    _pathController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Anexo' : 'Criar Anexo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(dimens.paddingScreenAll),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: dimens.spacingVertical,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BasicFormField(
                labelText: 'Nome',
                hintText: 'Digite o nome',
                controller: _namecontroller,
                textCapitalization: TextCapitalization.words,
                validator: GenericValidations.name,
                prefixIconData: Symbols.docs_rounded,
              ),
              InkWell(
                onTap: _selectFile,
                child: AbsorbPointer(
                  child: BasicFormField(
                    labelText: 'Arquivo',
                    hintText: 'Selecione o arquivo do exame.',
                    controller: _pathController,
                    validator: GenericValidations.notEmpty,
                    prefixIconData: Symbols.document_search_rounded,
                  ),
                ),
              ),
              EnumFormField<AttachmentType>(
                labelBuilder: (value) => value.label,
                initialValue: _type,
                values: AttachmentType.values,
                onChanged: _selectType,
                validator: GenericValidations.attachmentType,
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
            'Ocorreu um erro ao salvar o anexo.\n'
            'Favor, tente mais tarde.',
          ),
        ),
      );
      return;
    }

    Navigator.pop(context);
  }

  void _initializeForm() {
    final attachment = widget.attachment;

    if (attachment != null) {
      _namecontroller.text = attachment.name;
      _pathController.text = attachment.path;
      _type = attachment.type;

      _isEditing = true;

      setState(() {});
    }
  }

  void _selectType(AttachmentType? type) => _type = type;

  void _saveForm() {
    if (viewModel.insert.isRunning || viewModel.update.isRunning) return;

    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    final attachment = AttachmentModel(
      id: widget.attachment?.id,
      sessionId: widget.session.id!,
      name: _namecontroller.text.trim(),
      path: _pathController.text.trim(),
      type: _type!,
    );

    _isEditing
        ? viewModel.update.execute(attachment)
        : viewModel.insert.execute(attachment);
  }

  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Selecione o exame',
      initialDirectory: '/storage/emulated/0/Download',
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'png', 'jpg'],
    );

    if (result != null) {
      _pathController.text = result.files.first.path!;
    }
  }
}
