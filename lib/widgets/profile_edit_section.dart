import 'package:flutter/material.dart';
import '../user/user_profile.dart';

class ProfileEditSection extends StatelessWidget {
  const ProfileEditSection({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          _EditField(title: "Name", value: profile.username, height: 1),
          _EditField(title: "Gender", value: profile.gender, height: 1),
          _EditField(title: "Birthday", value: profile.birthday, height: 1),
          _EditField(title: "Zodiac sign", value: profile.zodiacSign, height: 1),
          _EditField(title: "Birth time", value: profile.birthTime, height: 1.2),
          _EditField(title: "Birth place", value: profile.birthPlace, height: 1),
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
  });

  final String title;
  final String value;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black.withValues(alpha: 0.55),
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            //margin: const EdgeInsets.symmetric(horizontal: 6),
            height: height,
            color: Colors.black.withValues(alpha: 0.08),
          ),

          //const SizedBox(height: 3),
        ],
      ),
    );
  }
}