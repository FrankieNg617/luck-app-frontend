import 'package:flutter/material.dart';
import '../controllers/iris_controller.dart';

class IrisOverlay extends StatefulWidget {
  const IrisOverlay({super.key});

  @override
  State<IrisOverlay> createState() => _IrisOverlayState();
}

class _IrisOverlayState extends State<IrisOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late Animation<double> _radius;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _radius = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeInOutCubic,
    );

    _ctrl.value = 1.0;

    IrisController.radiusFactor.addListener(_onRadiusChange);
  }

  void _onRadiusChange() {
    if (!mounted) return;

    final v = IrisController.radiusFactor.value;
    if (v == 0.0) {
      _ctrl.reverse(from: 1.0); // close
    } else {
      _ctrl.forward(from: 0.0); // open
    }
  }

  @override
  void dispose() {
    IrisController.radiusFactor.removeListener(_onRadiusChange);
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _radius,
        builder: (_, __) {
          return CustomPaint(
            painter: _IrisPainter(progress: _radius.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _IrisPainter extends CustomPainter {
  final double progress; // 0 = closed, 1 = open
  _IrisPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = size.center(Offset.zero);

    final maxRadius = size.longestSide * 0.6;
    final radius = maxRadius * progress;

    // ✅ draw into a layer so BlendMode.clear always works
    canvas.saveLayer(rect, Paint());

    // Full black layer
    canvas.drawRect(rect, Paint()..color = Colors.black);

    // Punch a circular hole
    canvas.drawCircle(
      center,
      radius,
      Paint()..blendMode = BlendMode.clear,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _IrisPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

