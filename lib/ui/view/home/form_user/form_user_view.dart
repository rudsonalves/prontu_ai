import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '/domain/models/user_model.dart';
import '/utils/extensions/date_time_extensions.dart';
import '/utils/validates/generic_validations.dart';
import '/domain/enums/enums_declarations.dart';
import '/ui/core/ui/form_fields/enum_form_field.dart';
import '/ui/core/ui/buttons/big_button.dart';
import '/ui/core/ui/form_fields/basic_form_field.dart';
import '/ui/core/ui/form_fields/date_form_field.dart';

import 'form_user_view_model.dart';

class FormUserView extends StatefulWidget {
  final UserModel? user;
  final FormUserViewModel viewModel;

  const FormUserView({
    super.key,
    this.user,
    required this.viewModel,
  });

  @override
  State<FormUserView> createState() => _FormUserViewState();
}

class _FormUserViewState extends State<FormUserView> {
  late final FormUserViewModel viewModel;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();

  Sex? _selectedSex;
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
    viewModel.insert.removeListener(_isSaved);
    viewModel.update.removeListener(_isSaved);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Usuário' : 'Criar Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BasicFormField(
                labelText: 'Nome',
                hintText: 'Digite o nome',
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                validator: GenericValidations.name,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIconData: Symbols.person,
              ),
              DateFormatField(
                labelText: 'Data de Nascimento',
                hintText: 'Digite a data de nascimento',
                controller: _dateController,
                validator: GenericValidations.brDate,
              ),
              EnumFormField<Sex>(
                labelBuilder: (sex) => sex.label,
                initialValue: _selectedSex,
                values: Sex.values,
                onChanged: _selectSex,
                validator: GenericValidations.sex,
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
        SnackBar(
          content: Text(
            'Ocorreu um erro ao salvar o usuário: ${result!.error}.\n'
            'Favor, tente mais tarde.',
          ),
        ),
      );
      return;
    }

    Navigator.pop(context);
  }

  void _selectSex(Sex? sex) => _selectedSex = sex;

  void _saveForm() {
    if (viewModel.insert.isRunning || viewModel.update.isRunning) return;

    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    final user = UserModel(
      id: widget.user?.id,
      name: _nameController.text.trim(),
      birthDate: DateTimeMapper.fromDDMMYYYY(_dateController.text)!,
      sex: _selectedSex!,
    );

    _isEditing
        ? viewModel.update.execute(user)
        : viewModel.insert.execute(user);
  }

  void _initializeForm() {
    if (widget.user != null) {
      _nameController.text = widget.user!.name;
      _dateController.text = widget.user!.birthDate.toDDMMYYYY();
      _selectedSex = widget.user!.sex;

      _isEditing = true;

      setState(() {});
    }
  }
}
