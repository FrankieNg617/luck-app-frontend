import 'package:flutter/material.dart';
import '../background/profile_background.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    // required this.username,
    // required this.zodiacSign,
    // required this.birthday,
    // required this.birthPlace,
    // required this.gender,
    this.avatarAsset = 'assets/avatars/avatar.png',
  });

  final String username = 'Frankie';
  final String zodiacSign = 'Scorpio';
  final String birthday = '03 Nov 2001';
  final String birthPlace = 'Hong Kong';
  final String gender = 'Male';
  final String avatarAsset;

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

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final planet = _planetForSign(zodiacSign);
    final avatarSize = (w * 0.24).clamp(84.0, 130.0);
    final planetBox = (w * 0.65).clamp(220.0, 360.0);
    final planetSize = (planetBox * 0.62).clamp(140.0, 240.0);

    final zodiacSymbolPath =
        'assets/zodiac_symbols/${zodiacSign.trim().toLowerCase()}.png';
    final planetPath = 'assets/planets/${planet.toLowerCase()}.png';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ProfileBackground(
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
                        child: Image.asset(avatarAsset, fit: BoxFit.cover),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      username,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: (w * 0.055).clamp(18.0, 24.0),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 10),

                    // Zodiac sign + symbol
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          zodiacSign,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.92),
                            fontSize: (w * 0.045).clamp(15.0, 20.0),
                            fontWeight: FontWeight.w600,
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

                    const SizedBox(height: 86),

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
                              label: birthday,
                            ),
                          ),

                          // RIGHT (planet)
                          Positioned(
                            right: 0,
                            top: planetBox * 0.40,
                            child: _InfoBadge(
                              icon: Icons.brightness_3_rounded,
                              label: _titleCase(planet),
                            ),
                          ),

                          // LEFT (gender)
                          Positioned(
                            left: 0,
                            top: planetBox * 0.40,
                            child: _InfoBadge(
                              icon: Icons.wc_rounded,
                              label: gender,
                            ),
                          ),

                          // BELOW (birthplace)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: _InfoBadge(
                              icon: Icons.place_rounded,
                              label: birthPlace,
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
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
              ),
            ],
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
    final iconSize = (w * 0.055).clamp(16.0, 22.0);
    final fontSize = (w * 0.032).clamp(11.0, 14.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: iconSize, color: Colors.white.withValues(alpha: 0.9)),
        const SizedBox(height: 4),
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
