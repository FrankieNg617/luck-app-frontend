import 'package:flutter/material.dart';
import 'controllers/vignette_controller.dart';
import 'overlays/eyepiece_vignette.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _vignetteCtrl;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _vignetteCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _opacity = CurvedAnimation(
      parent: _vignetteCtrl,
      curve: Curves.easeInOut,
    );

    // Listen to global vignette requests
    VignetteController.opacity.addListener(_handleVignetteChange);
  }

  void _handleVignetteChange() {
    if (!mounted) return;

    if (VignetteController.opacity.value > 0) {
      _vignetteCtrl.forward();
    } else {
      _vignetteCtrl.reverse();
    }
  }

  @override
  void dispose() {
    VignetteController.opacity.removeListener(_handleVignetteChange);
    _vignetteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,

        IgnorePointer(
          child: FadeTransition(
            opacity: _opacity,
            child: const EyepieceVignette(),
          ),
        ),
      ],
    );
  }
}
