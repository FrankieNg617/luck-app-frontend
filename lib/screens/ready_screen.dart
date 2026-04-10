import 'package:flutter/material.dart';
import 'package:luck_app/controllers/iris_controller.dart';
import 'package:luck_app/main_shell.dart';
import '../background/ready_background.dart';
import '../background/home_background.dart';
import '../services/home_daily_service.dart';
import '../store/home_data_store.dart';
import '../services/profile_data_service.dart';
import '../store/profile_data_store.dart';
import '../config/app_config.dart';

class ReadyScreen extends StatefulWidget {
  const ReadyScreen({super.key, required this.username});

  final String username;

  @override
  State<ReadyScreen> createState() => _ReadyScreenState();
}

class _ReadyScreenState extends State<ReadyScreen>
    with SingleTickerProviderStateMixin {

  late final AnimationController _ctrl;
  late final Animation<double> _zoom;
  late final Animation<double> _homeFadeIn;

  final HomeDailyService _homeDailyService = HomeDailyService(
    baseUrl: AppConfig.baseUrl,
  );

  final ProfileDataService _profileDataService = ProfileDataService(
    baseUrl: AppConfig.baseUrl,
  );

  bool _locked = false;
  bool _irisClosed = false;
  bool _isPreloading = false;

  static const double _irisCloseAt = 0.35;

  final ValueNotifier<bool> hideHintText = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _zoom = Tween<double>(
      begin: 1.0,
      end: 6.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInCubic));

    _homeFadeIn = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.90, 1.0, curve: Curves.easeOut),
    );

    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _handleAnimationFinished();
      }
    });

    _ctrl.addListener(() {
      if (!_irisClosed && _ctrl.value >= _irisCloseAt) {
        _irisClosed = true;
        IrisController.close();
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    hideHintText.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_locked) return;
    _locked = true;

    hideHintText.value = true;
    _ctrl.forward(from: 0.0);
  }

  Future<void> _handleAnimationFinished() async {
    if (_isPreloading) return;
    _isPreloading = true;

    final homeStore = HomeDataStore();
    final profileStore = ProfileDataStore();

    homeStore.setLoading(true);
    profileStore.setLoading(true);

    try {
      final data = await Future.wait([
        _homeDailyService.loadHomeData(),
        _profileDataService.loadProfileData(),
      ]);

      final homeData = data[0];
      final profileData = data[1];

      homeStore.setData(homeData as dynamic);
      profileStore.setData(profileData as dynamic);

      if (!mounted) return;

      await Future.delayed(const Duration(milliseconds: 120));
      if (!mounted) return;

      _swapToHomeInstant(homeStore, profileStore);

      await Future.delayed(const Duration(milliseconds: 80));
      IrisController.open();
    } catch (e) {
      homeStore.setError(e.toString());
      profileStore.setError(e.toString());

      if (!mounted) return;

      _swapToHomeInstant(homeStore, profileStore);

      await Future.delayed(const Duration(milliseconds: 80));
      IrisController.open();
    }
  }

  void _swapToHomeInstant(HomeDataStore homeDataStore, ProfileDataStore profileDataStore) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => MainShell(homeDataStore: homeDataStore, profileDataStore: profileDataStore),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Transform.scale(
                  scale: _zoom.value,
                  alignment: const Alignment(0.15, 0.12),
                  child: ReadyBackground(
                    hideHintText: hideHintText,
                    username: widget.username,
                  ),
                ),
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
