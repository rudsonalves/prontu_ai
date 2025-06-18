import 'package:flutter/widgets.dart';

import '/ui/view/ai_summary/ai_summary_view_model.dart';

class AiSummaryView extends StatefulWidget {
  final AiSummaryViewModel viewModel;

  const AiSummaryView({super.key, required this.viewModel});

  @override
  State<AiSummaryView> createState() => _AiSummaryViewState();
}

class _AiSummaryViewState extends State<AiSummaryView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
