import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '/domain/models/session_model.dart';
import '/ui/view/attachment/attachment_view_model.dart';

class AttachmentView extends StatefulWidget {
  final SessionModel session;
  final AttachmentViewModel viewModel;

  const AttachmentView({
    super.key,
    required this.session,
    required this.viewModel,
  });

  @override
  State<AttachmentView> createState() => _AttachmentViewState();
}

class _AttachmentViewState extends State<AttachmentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta Dr. ${widget.session.doctor}'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Symbols.arrow_back_ios_new_rounded),
        ),
      ),
    );
  }
}
