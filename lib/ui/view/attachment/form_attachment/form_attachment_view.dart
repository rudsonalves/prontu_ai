import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:prontu_ai/domain/enums/enums_declarations.dart';
import 'package:prontu_ai/ui/core/theme/dimens.dart';
import 'package:prontu_ai/ui/core/ui/form_fields/basic_form_field.dart';
import 'package:prontu_ai/utils/validates/generic_validations.dart';

import '/domain/models/attachment_model.dart';
import '/ui/view/attachment/form_attachment/form_attachment_view_model.dart';

class FormAttachmentView extends StatefulWidget {
  final AttachmentModel? attachment;
  final FormAttachmentViewModel viewModel;

  const FormAttachmentView({
    super.key,
    this.attachment,
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
              BasicFormField(
                labelText: 'Arquivo',
                hintText: 'Selecione o arquivo do exame.',
                controller: _pathController,
                validator: GenericValidations.notEmpty,
                prefixIconData: Symbols.document_search_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _isSaved() {}

  void _initializeForm() {}
}
