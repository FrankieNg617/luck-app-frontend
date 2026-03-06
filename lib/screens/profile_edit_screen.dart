import 'package:flutter/material.dart';
import '../user/profile_scope.dart';
import '../widgets/profile_edit_section.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = ProfileScope.of(context);
    final p = store.profile;

    final route = ModalRoute.of(context);
    final anim = route?.secondaryAnimation ?? kAlwaysDismissedAnimation;

    return AnimatedBuilder(
      animation: anim,
      builder: (context, child) {
        final curved = anim.status == AnimationStatus.reverse
              ? Curves.easeInCubic.transform(anim.value) // return 
              : Curves.easeOutCubic.transform(anim.value);

        final scale = 1 - (0.09 * curved);
        final radius = 15 * curved;
        final dy = -10 * curved;

        return Transform.translate(
          offset: Offset(0, dy),
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.topCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: child,
            ),
          ),
        );
      },
      child: SafeArea(
        top: false,
        bottom: false,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.95,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 4),

                  // Threads-like nav row
                  SizedBox(
                    height: 52,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            style: ButtonStyle(
                              overlayColor: WidgetStateProperty.all(
                                Colors.transparent,
                              ),

                              foregroundColor: WidgetStateProperty.resolveWith((
                                states,
                              ) {
                                if (states.contains(WidgetState.pressed)) {
                                  return Colors.black.withValues(alpha: 0.45);
                                }
                                return Colors.black;
                              }),

                              textStyle: WidgetStateProperty.all(
                                const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Edit profile',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            style: ButtonStyle(
                              overlayColor: WidgetStateProperty.all(
                                Colors.transparent,
                              ),

                              foregroundColor: WidgetStateProperty.resolveWith((
                                states,
                              ) {
                                if (states.contains(WidgetState.pressed)) {
                                  return Colors.black.withValues(alpha: 0.45);
                                }
                                return Colors.black;
                              }),

                              textStyle: WidgetStateProperty.all(
                                const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Done'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(
                    height: 1,
                    thickness: 0.7,
                    color: Colors.black.withValues(alpha: 0.65),
                  ),

                  const SizedBox(height: 40),

                  // Avatar + profile edit widget
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundImage: AssetImage(p.avatarAsset),
                        ),

                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black.withValues(alpha: 0.08),
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 17,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 45),

                  // profile edit widget
                  ProfileEditSection(profile: p),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
