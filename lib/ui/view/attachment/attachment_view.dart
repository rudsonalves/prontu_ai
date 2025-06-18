import 'package:flutter/widgets.dart';

import '/ui/view/attachment/attachment_view_model.dart';

class AttachmentView extends StatefulWidget {
  final String sessionId;
  final AttachmentViewModel viewModel;

  const AttachmentView({
    super.key,
    required this.sessionId,
    required this.viewModel,
  });

  @override
  State<AttachmentView> createState() => _AttachmentViewState();
}

class _AttachmentViewState extends State<AttachmentView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
