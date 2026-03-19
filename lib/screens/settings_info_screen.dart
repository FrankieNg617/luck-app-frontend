import 'package:flutter/material.dart';
import '../widgets/Settings/notifications_widget.dart';

class SettingsInfoScreen extends StatelessWidget {
  const SettingsInfoScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final w = media.size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8F8),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: w * 0.055,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: w * 0.048,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFD9D9D9)),
        ),
      ),

      /// BODY (dynamic content)
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    switch (title) {
      case 'Notifications':
        return const NotificationsContent();

      default:
        return const Center(child: Text("Coming soon"));
    }
  }
}