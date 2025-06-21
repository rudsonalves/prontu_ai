import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/ui/view/splash/splash_view_model.dart';
import '/routing/routes.dart';
import '/ui/core/theme/dimens.dart';

class SplashLogoView extends StatefulWidget {
  final SplashViewModel viewModel;

  const SplashLogoView({super.key, required this.viewModel});

  @override
  State<SplashLogoView> createState() => _SplashLogoViewState();
}

class _SplashLogoViewState extends State<SplashLogoView>
    with SingleTickerProviderStateMixin {
  late final SplashViewModel viewModel;
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    viewModel = widget.viewModel;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _scaleAnimation = Tween<double>(begin: 0.30, end: 1.6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutBack,
      ),
    );

    _startAnimationSequence();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dimens = Dimens.of(context);

    const double logoSize = 200;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(dimens.paddingScreenAll * 3),
          child: ScaleTransition(
            scale: _scaleAnimation,
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
      ),
    );
  }

  Future<void> _startAnimationSequence() async {
    await _controller.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) context.go(Routes.home.path);
  }
}
