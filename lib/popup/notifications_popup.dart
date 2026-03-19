import 'package:flutter/material.dart';

class NotificationPermissionDialog extends StatelessWidget {
  const NotificationPermissionDialog({
    required this.onAllow,
    required this.onDontAllow,
  });

  final VoidCallback onAllow;
  final VoidCallback onDontAllow;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final w = media.size.width;

    final dialogWidth = w * 0.82;
    final titleSize = (w * 0.05).clamp(18.0, 22.0);
    final bodySize = (w * 0.04).clamp(14.0, 16.0);
    final buttonSize = (w * 0.043).clamp(15.0, 17.0);

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: w * 0.09),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: SizedBox(
        width: dialogWidth,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            w * 0.06,
            w * 0.07,
            w * 0.06,
            w * 0.05,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Don't miss your message",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: w * 0.035),
              Text(
                "Enable notifications to get daily reminders",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: bodySize,
                  color: const Color(0xFF666666),
                  height: 1.4,
                ),
              ),
              SizedBox(height: w * 0.07),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onAllow,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: w * 0.035),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Allow",
                    style: TextStyle(
                      fontSize: buttonSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: w * 0.025),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: onDontAllow,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: w * 0.03),
                  ),
                  child: Text(
                    "Don't allow",
                    style: TextStyle(
                      fontSize: buttonSize,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}