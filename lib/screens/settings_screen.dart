import 'package:flutter/material.dart';
import 'settings_info_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _open(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SettingsInfoScreen(title: title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;

    double w(double value) => screenWidth * value;
    double h(double value) => screenHeight * value;

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
            size: w(0.06).clamp(20.0, 24.0),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: w(0.048).clamp(18.0, 22.0),
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFD9D9D9)),
        ),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth * 0.038;
            final itemVerticalPadding = constraints.maxHeight * 0.020;
            final iconBoxWidth = constraints.maxWidth * 0.08;
            final iconSize = (constraints.maxWidth * 0.048).clamp(24.0, 32.0);
            final itemGap = constraints.maxWidth * 0.03;
            final textSize = (constraints.maxWidth * 0.043).clamp(15.5, 18.5);
            final logoutTopGap = constraints.maxHeight * 0.012;
            final logoutHorizontalPadding = constraints.maxWidth * 0.038;
            final logoutTextSize = (constraints.maxWidth * 0.047).clamp(
              16.0,
              19.0,
            );

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _settingsItem(
                          icon: Icons.notifications_none,
                          title: 'Notifications',
                          onTap: () => _open(context, 'Notifications'),
                          horizontalPadding: horizontalPadding,
                          verticalPadding: itemVerticalPadding,
                          iconBoxWidth: iconBoxWidth,
                          iconSize: iconSize,
                          gap: itemGap,
                          textSize: textSize,
                        ),
                        _settingsItem(
                          icon: Icons.person_outline,
                          title: 'Account',
                          onTap: () => _open(context, 'Account'),
                          horizontalPadding: horizontalPadding,
                          verticalPadding: itemVerticalPadding,
                          iconBoxWidth: iconBoxWidth,
                          iconSize: iconSize,
                          gap: itemGap,
                          textSize: textSize,
                        ),
                        _settingsItem(
                          icon: Icons.workspace_premium_outlined,
                          title: 'Subscriptions',
                          onTap: () => _open(context, 'Subscriptions'),
                          horizontalPadding: horizontalPadding,
                          verticalPadding: itemVerticalPadding,
                          iconBoxWidth: iconBoxWidth,
                          iconSize: iconSize,
                          gap: itemGap,
                          textSize: textSize,
                        ),
                        _settingsItem(
                          icon: Icons.chat_bubble_outline,
                          title: 'Comments and recommendations',
                          onTap: () {},
                          horizontalPadding: horizontalPadding,
                          verticalPadding: itemVerticalPadding,
                          iconBoxWidth: iconBoxWidth,
                          iconSize: iconSize,
                          gap: itemGap,
                          textSize: textSize,
                        ),
                        _settingsItem(
                          icon: Icons.share_outlined,
                          title: 'Share to others',
                          onTap: () {},
                          horizontalPadding: horizontalPadding,
                          verticalPadding: itemVerticalPadding,
                          iconBoxWidth: iconBoxWidth,
                          iconSize: iconSize,
                          gap: itemGap,
                          textSize: textSize,
                        ),
                        _settingsItem(
                          icon: Icons.info_outline,
                          title: 'About',
                          onTap: () => _open(context, 'About'),
                          horizontalPadding: horizontalPadding,
                          verticalPadding: itemVerticalPadding,
                          iconBoxWidth: iconBoxWidth,
                          iconSize: iconSize,
                          gap: itemGap,
                          textSize: textSize,
                        ),

                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFD9D9D9),
                        ),

                        SizedBox(height: logoutTopGap),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: logoutHorizontalPadding,
                          ),
                          child: InkWell(
                            onTap: () {
                              // logout logic
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: h(0.012).clamp(8.0, 12.0),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: iconBoxWidth,
                                    child: Icon(
                                      Icons.logout,
                                      color: const Color(0xFFE11D48),
                                      size: iconSize,
                                    ),
                                  ),
                                  SizedBox(width: itemGap),
                                  Text(
                                    'Log out',
                                    style: TextStyle(
                                      color: const Color(0xFFE11D48),
                                      fontSize: logoutTextSize,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _settingsItem({
    required IconData icon,
    required String title,
    required double horizontalPadding,
    required double verticalPadding,
    required double iconBoxWidth,
    required double iconSize,
    required double gap,
    required double textSize,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Row(
          children: [
            SizedBox(
              width: iconBoxWidth,
              child: Icon(icon, color: Colors.black, size: iconSize),
            ),
            SizedBox(width: gap),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: textSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
