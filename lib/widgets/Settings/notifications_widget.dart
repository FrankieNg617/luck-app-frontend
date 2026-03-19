import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:luck_app/popup/notifications_popup.dart';

class NotificationsContent extends StatefulWidget {
  const NotificationsContent({super.key});

  @override
  State<NotificationsContent> createState() =>
      _NotificationsContentState();
}

class _NotificationsContentState extends State<NotificationsContent> {
  bool online = true;
  bool daily = true;
  bool _checkedPermission = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_checkedPermission) {
      _checkedPermission = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkAndShowPermissionDialog();
      });
    }
  }

  Future<void> _checkAndShowPermissionDialog() async {
    final status = await Permission.notification.status;

    if (!mounted) return;

    if (!status.isGranted) {
      await showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (context) => NotificationPermissionDialog(
          onAllow: () async {
            Navigator.of(context).pop();

            final result = await Permission.notification.request();

            if (!mounted) return;

            if (result.isGranted) {
              setState(() {
                online = true;
                daily = true;
              });
            }
          },
          onDontAllow: () {
            Navigator.of(context).pop();
          },
        ),
      );
    } else {
      setState(() {
        online = true;
        daily = true;
      });
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

    return Column(
      children: [
        _item(
          title: "Online remind",
          value: online,
          onChanged: (v) async {
            final granted = await Permission.notification.isGranted;

            if (!granted && v) {
              if (!mounted) return;
              await _checkAndShowPermissionDialog();
              return;
            }

            setState(() => online = v);
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
            final granted = await Permission.notification.isGranted;

            if (!granted && v) {
              if (!mounted) return;
              await _checkAndShowPermissionDialog();
              return;
            }

            setState(() => daily = v);
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
                  style: TextStyle(
                    fontSize: textSize,
                    color: Colors.black,
                  ),
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