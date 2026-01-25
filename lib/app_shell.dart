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
  late final Animation<double> _fadeInOpacity;
  late final Animation<double> _fadeOutOpacity;

  bool _isFadingIn = false;

  @override
  void initState() {
    super.initState();

    _vignetteCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Fade in anim
    _fadeInOpacity = CurvedAnimation(
      parent: _vignetteCtrl,
      curve:  const Interval(0.80, 1.0, curve: Curves.easeInOut),
    );

    // Fade out
    _fadeOutOpacity = CurvedAnimation(
      parent: _vignetteCtrl,
      curve: Curves.easeOut, 
    );

    // Listen to global vignette requests
    VignetteController.opacity.addListener(_handleVignetteChange);
  }

  void _handleVignetteChange() {
    if (!mounted) return;

    if (VignetteController.opacity.value > 0) {
      // Fade in
      _isFadingIn = true;
      _vignetteCtrl.forward(from: 0.0);
    } else {
      // Fade out 
      _isFadingIn = false;
      _vignetteCtrl.reverse(from: 1.0);
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
          child: AnimatedBuilder(
            animation: _vignetteCtrl,
            builder: (_, __) {
              final opacity = _isFadingIn
                  ? _fadeInOpacity.value
                  : _fadeOutOpacity.value;

              return Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: const EyepieceVignette(),
              );
            },
          ),
        ),
      ],
    );
  }
}
