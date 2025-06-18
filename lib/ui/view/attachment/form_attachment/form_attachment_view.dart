import 'package:flutter/widgets.dart';

import '/domain/models/attachment_model.dart';
import '/ui/view/attachment/form_attachment/form_attachment_view_model.dart';

class FormAttachmentView extends StatefulWidget {
  final AttachmentModel attachment;
  final FormAttachmentViewModel viewModel;

  const FormAttachmentView({
    super.key,
    required this.attachment,
    required this.viewModel,
  });

  @override
  State<FormAttachmentView> createState() => _FormAttachmentViewState();
}

class _FormAttachmentViewState extends State<FormAttachmentView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
