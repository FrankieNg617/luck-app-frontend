import 'package:flutter/material.dart';
import 'package:luck_app/screens/ready_screen.dart';
import 'ui/fortune_style.dart';
import 'app_shell.dart';
import 'user/user_profile.dart';
import 'user/profile_scope.dart';
import 'services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();

  runApp(const FortuneApp());
}

class FortuneApp extends StatefulWidget {
  const FortuneApp({super.key});

  @override
  State<FortuneApp> createState() => _FortuneAppState();
}

class _FortuneAppState extends State<FortuneApp> {
  // temp dev store (in-memory)
  late final UserProfileStore _profileStore;

  @override
  void initState() {
    super.initState();
    _profileStore = UserProfileStore(UserProfile.dev);
    _syncNotifications();
  }

  @override
  void dispose() {
    _profileStore.dispose();
    super.dispose();
  }

  Future<void> _syncNotifications() async {
    final prefs = await SharedPreferences.getInstance();

    final onlineEnabled = prefs.getBool('settings_online_remind') ?? true;

    if (onlineEnabled) {
      await NotificationService.testIn10Seconds();
    } else {
      await NotificationService.cancelOnlineReminder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProfileScope(
      store: _profileStore,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Daily Luck',
        theme: FortuneTheme.lightTheme(),

        // Navigator lives here
        home: const ReadyScreen(),

        // AppShell wraps ALL routes and NEVER rebuilds
        builder: (context, child) {
          return AppShell(child: child ?? const SizedBox.shrink());
        },
      ),
    );
  }
}
