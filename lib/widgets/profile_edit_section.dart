import 'package:flutter/material.dart';
import '../user/user_profile.dart';
import '../routes/threads_sheet_route.dart';
import '../screens/info_edit_screen.dart';

class ProfileEditSection extends StatelessWidget {
  const ProfileEditSection({
    super.key, 
    required this.profile, 
    required this.onValueChanged
  });

  final UserProfile profile;
  final void Function(String title, String newValue) onValueChanged;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final horizontalPadding = (w * 0.054).clamp(18.0, 26.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: [
          _EditField(title: "Name", value: profile.username, height: w * 0.004, onValueChanged: onValueChanged,),
          _EditField(title: "Gender", value: profile.gender, height: w * 0.004, onValueChanged: onValueChanged,),
          _EditField(title: "Birthday", value: profile.birthday, height: w * 0.0045, onValueChanged: onValueChanged,),
          _EditField(title: "Zodiac sign", value: profile.zodiacSign, height: w * 0.005, tappable: false, onValueChanged: onValueChanged,),
          _EditField(title: "Birth time", value: profile.birthTime, height: w * 0.0046, onValueChanged: onValueChanged,),
          _EditField(title: "Birth place", value: profile.birthPlace, height: w * 0.0045, onValueChanged: onValueChanged,),
        ],
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  const _EditField({
    required this.title,
    required this.value,
    required this.height,
    required this.onValueChanged,
    this.tappable = true,
  });

  final String title;
  final String value;
  final double height;
  final bool tappable;
  final void Function(String title, String newValue) onValueChanged;

  Future<void> handleTap(BuildContext context) async {
    final result = await Navigator.of(context).push<String>(
      ThreadsSheetRoute(
        builder: (_) => InfoEditScreen(
          title: title,
          value: value,
        ),
      ),
    );

    if (result == null) return;
    if (result == value) return;

    onValueChanged(title, result);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    final fieldSpacing = (w * 0.050).clamp(18.0, 26.0);
    final gapSmall = (w * 0.010).clamp(2.0, 8.0);
    final gapMedium = (w * 0.02).clamp(8.0, 12.0);

    final titleSize = (w * 0.034).clamp(13.0, 15.0);
    final valueSize = (w * 0.041).clamp(16.0, 18.0);
    
    return Padding(
      padding: EdgeInsets.only(bottom: fieldSpacing),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: tappable ? () => handleTap(context) : null,
          highlightColor: Colors.grey.withValues(alpha: 0.50),
          splashColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(top: 0, bottom: gapSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: titleSize,
                    color: Colors.black.withValues(alpha: 0.55),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: gapSmall),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: valueSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: gapMedium),
                Container(
                  height: height,
                  color: Colors.black.withValues(alpha: 0.30),
                ),
                SizedBox(height: gapSmall * 0.7),
              ],
            ),
          ),
        ),
      ),
    );
  }
}