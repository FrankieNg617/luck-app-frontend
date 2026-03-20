import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsContent extends StatefulWidget {
  const NotificationsContent({super.key});

  @override
  State<NotificationsContent> createState() => _NotificationsContentState();
}

class _NotificationsContentState extends State<NotificationsContent> {
  static const _onlineKey = 'settings_online_remind';
  static const _dailyTasksKey = 'settings_daily_tasks_remind';

  bool online = true;
  bool daily = true;
  bool _hasRequestedOnOpen  = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasRequestedOnOpen ) {
      _hasRequestedOnOpen  = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _requestNotificationPermissionOnOpen();
      });
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final savedOnline = prefs.getBool(_onlineKey);
    final savedDaily = prefs.getBool(_dailyTasksKey);

    if (!mounted) return;

    setState(() {
      online = savedOnline ?? true;
      daily = savedDaily ?? true;
      _loaded = true;
    });
  }

  Future<void> _saveOnline(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onlineKey, value);
  }

  Future<void> _saveDailyTasks(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dailyTasksKey, value);
  }

  Future<bool> _isAndroid13OrAbove() async {
    if (!Platform.isAndroid) return true;

    final info = await DeviceInfoPlugin().androidInfo;
    return info.version.sdkInt >= 33;
  }

  Future<void> _requestNotificationPermissionOnOpen() async {
    final isAndroid13Plus = await _isAndroid13OrAbove();

    if (!mounted) return;

    // Android 12 or below: no runtime notification permission needed
    if (!isAndroid13Plus) return;

    final status = await Permission.notification.status;
    if (status.isGranted) return;

    final result = await Permission.notification.request();

    if (result.isPermanentlyDenied) {
      debugPrint('notification permission permanently denied');
    }
  }

  Future<void> _handleToggle(
    bool value,
    Future<void> Function(bool) save,
    void Function(bool) updateUi,
  ) async {
    updateUi(value);
    await save(value);

    if (!value) return;

    final isAndroid13Plus = await _isAndroid13OrAbove();
    if (!mounted || !isAndroid13Plus) return;

    final status = await Permission.notification.status;
    if (status.isGranted) return;

    final result = await Permission.notification.request();

    if (!mounted) return;

    if (result.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final w = media.size.width;
    final h = media.size.height;

    final horizontalPadding = w * 0.04;
    final verticalPadding = h * 0.007;
    final textSize = (w * 0.042).clamp(15.0, 18.0);
    final switchScale = (w * 0.0023).clamp(0.85, 1.0);

    if (!_loaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        _item(
          title: "Online remind",
          value: online,
          onChanged: (v) async {
            await _handleToggle(
              v,
              _saveOnline,
              (newValue) => setState(() => online = newValue),
            );
          },
          horizontalPadding: horizontalPadding,
          verticalPadding: verticalPadding,
          textSize: textSize,
          switchScale: switchScale,
        ),
        _item(
          title: "Daily tasks remind",
          value: daily,
          onChanged: (v) async {
            await _handleToggle(
              v,
              _saveDailyTasks,
              (newValue) => setState(() => daily = newValue),
            );
          },
          horizontalPadding: horizontalPadding,
          verticalPadding: verticalPadding,
          textSize: textSize,
          switchScale: switchScale,
        ),
      ],
    );
  }

  Widget _item({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required double horizontalPadding,
    required double verticalPadding,
    required double textSize,
    required double switchScale,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: textSize, color: Colors.black),
                ),
              ),
              Transform.scale(
                scale: switchScale,
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  activeTrackColor: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
