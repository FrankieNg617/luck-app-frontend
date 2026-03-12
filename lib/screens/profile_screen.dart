import 'dart:io';
import 'package:flutter/material.dart';
import '../background/profile_background.dart';
import '../user/profile_scope.dart';
import '../routes/threads_sheet_route.dart';
import 'profile_edit_screen.dart';
import '../utils/date_format.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _planetForSign(String sign) {
    final s = sign.trim().toLowerCase();
    const map = <String, String>{
      'aries': 'mars',
      'taurus': 'venus',
      'gemini': 'mercury',
      'cancer': 'moon',
      'leo': 'sun',
      'virgo': 'mercury',
      'libra': 'venus',
      'scorpio': 'pluto',
      'sagittarius': 'jupiter',
      'capricorn': 'saturn',
      'aquarius': 'uranus',
      'pisces': 'neptune',
    };
    return map[s] ?? 'sun';
  }

  ImageProvider _buildAvatarProvider(dynamic p) {
    final avatarPath = p.avatarPath;

    if (avatarPath != null && avatarPath.isNotEmpty) {
      final file = File(avatarPath);
      if (file.existsSync()) {
        return FileImage(file);
      }
    }

    return AssetImage(p.avatarAsset);
  }

  @override
  Widget build(BuildContext context) {
    final store = ProfileScope.of(context);
    final p = store.profile;
    final route = ModalRoute.of(context);

    final anim = route?.secondaryAnimation ?? kAlwaysDismissedAnimation;

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final planet = _planetForSign(p.zodiacSign);
    final avatarSize = (w * 0.24).clamp(84.0, 130.0);
    final planetBox = (w * 0.67).clamp(220.0, 360.0);
    final planetSize = (planetBox * 0.60).clamp(140.0, 240.0);

    final zodiacSymbolPath =
        'assets/zodiac_symbols/${p.zodiacSign.trim().toLowerCase()}.png';
    final planetPath = 'assets/planets/${planet.toLowerCase()}.png';

    final avatarProvider = _buildAvatarProvider(p);

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: anim,
        builder: (context, child) {
          final curved = anim.status == AnimationStatus.reverse
              ? Curves.easeInCubic.transform(anim.value) // return faster
              : Curves.easeOutCubic.transform(anim.value);

          // Threads-like: slight shrink + rounded corners + tiny downward shift
          final scale = 1.0 - (0.09 * curved); // 1.00 -> 0.94
          final radius = 15.0 * curved; // 0 -> 28
          final dy = 35.0 * curved;

          return Transform.translate(
            offset: Offset(0, dy),
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.topCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: child
              ),
            ),
          );
        },
        child: ProfileBackground(
          child: SafeArea(
            child: Stack(
              children: [
                // Main content
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: (w * 0.06).clamp(16.0, 28.0),
                    right: (w * 0.06).clamp(16.0, 28.0),
                    top: 65,
                    bottom: 28,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 18),

                      // Avatar (top-center)
                      Container(
                        width: avatarSize,
                        height: avatarSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.18),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 26,
                              spreadRadius: 2,
                              color: Colors.black.withValues(alpha: 0.35),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image(image: avatarProvider, fit: BoxFit.cover),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Username + zodiac symbol
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            p.username,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: (w * 0.055).clamp(18.0, 24.0),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Image.asset(
                            zodiacSymbolPath,
                            width: (w * 0.07).clamp(22.0, 34.0),
                            height: (w * 0.07).clamp(22.0, 34.0),
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.auto_awesome_rounded,
                              size: (w * 0.07).clamp(22.0, 34.0),
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Zodiac sign + planet label
                      Text(
                        '${p.zodiacSign} - ${_titleCase(planet)}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.92),
                          fontSize: (w * 0.045).clamp(15.0, 20.0),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 15),

                      // Edit profile button
                      SizedBox(
                        width: (w * 0.35).clamp(180.0, 240.0),
                        height: h * 0.035,
                        child: OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.white.withValues(alpha: 0.06),
                            ),

                            side: WidgetStateProperty.all(
                              BorderSide(
                                color: Colors.white.withValues(alpha: 0.28),
                              ),
                            ),

                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),

                            // Disable default button highlight
                            overlayColor: WidgetStateProperty.all(
                              Colors.transparent,
                            ),

                            // Change text color when pressed
                            foregroundColor: WidgetStateProperty.resolveWith((states,) {
                              if (states.contains(WidgetState.pressed)) {
                                return Colors.white.withValues(alpha: 0.75);
                              }
                              return Colors.white;
                            }),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              ThreadsSheetRoute(
                                builder: (_) => const ProfileEditScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Edit profile',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),

                      const SizedBox(height: 76),

                      // Planet image with 4 info around it
                      SizedBox(
                        width: planetBox,
                        height: planetBox,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            // planet
                            Image.asset(
                              planetPath,
                              width: planetSize,
                              height: planetSize,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.public_rounded,
                                size: planetSize,
                                color: Colors.white.withValues(alpha: 0.75),
                              ),
                            ),

                            // ABOVE (birthday)
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: _InfoBadge(
                                icon: Icons.cake_rounded,
                                label: formatBirthdayShort(p.birthday),
                              ),
                            ),

                            // RIGHT (birth time)
                            Positioned(
                              right: 0,
                              top: planetBox * 0.40,
                              child: _InfoBadge(
                                icon: Icons.access_time_rounded,
                                label: p.birthTime,
                              ),
                            ),

                            // LEFT (gender)
                            Positioned(
                              left: 0,
                              top: planetBox * 0.40,
                              child: _InfoBadge(
                                icon: p.gender.toLowerCase() == 'male'
                                    ? Icons.male
                                    : Icons.female,
                                label: p.gender,
                              ),
                            ),

                            // BELOW (birthplace)
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: _InfoBadge(
                                icon: Icons.place_rounded,
                                label: p.birthPlace,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: (h * 0.02).clamp(12.0, 20.0)),
                    ],
                  ),
                ),

                // Settings button (top-right)
                Positioned(
                  top: 6,
                  right: 6,
                  child: IconButton(
                    icon: const Icon(Icons.settings_rounded),
                    color: Colors.white.withValues(alpha: 0.9),
                    tooltip: 'Settings',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  const _InfoBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final iconSize = (w * 0.070).clamp(16.0, 32.0);
    final fontSize = (w * 0.035).clamp(11.0, 14.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: iconSize, color: Colors.white.withValues(alpha: 0.9)),
        const SizedBox(height: 7),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B10),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Text('Empty for now', style: TextStyle(color: Colors.white70)),
      ),
    );
  }
}

String _titleCase(String s) {
  if (s.isEmpty) return s;
  final lower = s.toLowerCase();
  return lower[0].toUpperCase() + lower.substring(1);
}
