import 'package:flutter/material.dart';
import '/ui/view/splash/splash_view_model.dart';

class SplashLogoView extends StatefulWidget {
  final SplashViewModel viewModel;

  const SplashLogoView({super.key, required this.viewModel});

  @override
  State<SplashLogoView> createState() => _SplashLogoViewState();
}

class _SplashLogoViewState extends State<SplashLogoView> {
  late final SplashViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = widget.viewModel;
    viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // final dimens = Dimens.of(context);
    const double logoSize = 200;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Image.asset(
            viewModel.isDark
              ? 'assets/images/splash1.png'
              : 'assets/images/splash2.png',
            width: logoSize,
            height: logoSize,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
