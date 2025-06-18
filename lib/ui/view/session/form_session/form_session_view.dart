import 'package:flutter/widgets.dart';

import '/domain/models/session_model.dart';
import '/ui/view/session/form_session/form_session_view_model.dart';

class FormSessionView extends StatefulWidget {
  final SessionModel session;
  final FormSessionViewModel viewModel;

  const FormSessionView({
    super.key,
    required this.session,
    required this.viewModel,
  });

  @override
  State<FormSessionView> createState() => _FormSessionViewState();
}

class _FormSessionViewState extends State<FormSessionView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
