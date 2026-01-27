import 'package:flutter/material.dart';
import '../background/ready_background.dart';
import 'home_screen.dart';
import '../background/home_background.dart';
import '../controllers/vignette_controller.dart';

class ReadyScreen extends StatefulWidget {
  const ReadyScreen({super.key});

  @override
  State<ReadyScreen> createState() => _ReadyScreenState();
}

class _ReadyScreenState extends State<ReadyScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  late final Animation<double> _zoom;
  late final Animation<double> _homeFadeIn;

  bool _locked = false;

  final Widget _home = const HomeScreen();
  final ValueNotifier<bool> hideHintText = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _zoom = Tween<double>(begin: 1.0, end: 22.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInCubic),
    );

    // ✅ Start fading Home in near the end of the zoom
    _homeFadeIn = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.80, 1.0, curve: Curves.easeOut),
    );

    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _swapToHomeInstant();
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_locked) return;
    _locked = true;

    // hide hint text
    hideHintText.value = true;

    VignetteController.opacity.value = 1.0;
    _ctrl.forward(from: 0.0);
  }

  void _swapToHomeInstant() {
    // ✅ Instant swap so there's NO "big zoomed ready screen pause"
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => _home,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // prevents white flash
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // ✅ Ready background zooms in
                Transform.scale(
                  scale: _zoom.value,
                  alignment: Alignment(0.15, 0.12), // <-- zoom destination (focal point)
                  child: ReadyBackground(hideHintText: hideHintText),
                ),

                // ✅ Home fades in during the end of zoom (smooth handoff)
                IgnorePointer(
                  child: Opacity(
                    opacity: _homeFadeIn.value.clamp(0.0, 1.0),
                    child: const HomeBackground(child: SizedBox.shrink()),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

