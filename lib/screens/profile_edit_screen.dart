import 'package:flutter/material.dart';
import '../user/profile_scope.dart';
import '../user/user_profile.dart';
import '../widgets/profile_edit_section.dart';
import 'package:flutter/cupertino.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  UserProfile? _editedProfile;
  bool _isSaving = false;

  void _handleValueChanged(String title, String newValue) {
    if (_editedProfile == null) return;

    setState(() {
      switch (title) {
        case 'Name':
          _editedProfile = _editedProfile!.copyWith(username: newValue);
          break;
        case 'Gender':
          _editedProfile = _editedProfile!.copyWith(gender: newValue);
          break;
        case 'Birthday':
          _editedProfile = _editedProfile!.copyWith(birthday: newValue);
          break;
        case 'Birth time':
          _editedProfile = _editedProfile!.copyWith(birthTime: newValue);
          break;
        case 'Birth place':
          _editedProfile = _editedProfile!.copyWith(birthPlace: newValue);
          break;
      }
    });
  }

  Future<void> _saveProfile() async {
  if (_isSaving || _editedProfile == null) return;

  final store = ProfileScope.of(context);

  setState(() {
    _isSaving = true;
  });

  try {
    await Future.wait([
      store.update(_editedProfile!), // actual save
      Future.delayed(const Duration(seconds: 2)), // minimum loading time
    ]);

    if (!mounted) return;
    Navigator.of(context).pop();
  } catch (_) {
    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to save profile')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final store = ProfileScope.of(context);
    _editedProfile ??= store.profile;
    final p = _editedProfile!;

    final route = ModalRoute.of(context);
    final anim = route?.secondaryAnimation ?? kAlwaysDismissedAnimation;

    final w = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: anim,
      builder: (context, child) {
        final curved = anim.status == AnimationStatus.reverse
            ? Curves.easeInCubic.transform(anim.value)
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
            child: AbsorbPointer(
              absorbing: _isSaving,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.95,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 4),

                        SizedBox(
                          height: (w * 0.11).clamp(48.0, 56.0),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  style: ButtonStyle(
                                    overlayColor: WidgetStateProperty.all(
                                      Colors.transparent,
                                    ),
                                    foregroundColor:
                                        WidgetStateProperty.resolveWith((states) {
                                      if (states.contains(WidgetState.pressed)) {
                                        return Colors.black.withValues(alpha: 0.45);
                                      }
                                      return Colors.black;
                                    }),
                                    textStyle: WidgetStateProperty.all(
                                      TextStyle(
                                        fontSize: (w * 0.042).clamp(15.0, 17.0),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Edit profile',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: (w * 0.042).clamp(15.0, 17.0),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  width: (w * 0.16).clamp(54.0, 72.0),
                                  child: Center(
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 180),
                                      child: _isSaving
                                          ? SizedBox(
                                              key: const ValueKey('loading'),
                                              width: (w * 0.055).clamp(16.0, 35.0),
                                              height: (w * 0.055).clamp(16.0, 35.0),
                                              child: const CupertinoActivityIndicator(
                                                //strokeWidth: 2.2,
                                                // valueColor:
                                                //     AlwaysStoppedAnimation<Color>(
                                                //   Colors.black,
                                                // ),
                                              ),
                                            )
                                          : TextButton(
                                              key: const ValueKey('done'),
                                              style: ButtonStyle(
                                                overlayColor: WidgetStateProperty.all(
                                                  Colors.transparent,
                                                ),
                                                foregroundColor:
                                                    WidgetStateProperty.resolveWith((
                                                  states,
                                                ) {
                                                  if (states.contains(
                                                    WidgetState.pressed,
                                                  )) {
                                                    return Colors.black.withValues(
                                                      alpha: 0.45,
                                                    );
                                                  }
                                                  return Colors.black;
                                                }),
                                                textStyle: WidgetStateProperty.all(
                                                  TextStyle(
                                                    fontSize:
                                                        (w * 0.042).clamp(15.0, 17.0),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              onPressed: _saveProfile,
                                              child: const Text('Done'),
                                            ),
                                    ),
                                  ),
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

                        Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                radius: (w * 0.12).clamp(40.0, 56.0),
                                backgroundImage: AssetImage(p.avatarAsset),
                              ),
                              Positioned(
                                bottom: w * 0.0001,
                                right: w * 0.0001,
                                child: Container(
                                  width: w * 0.07,
                                  height: w * 0.07,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black.withValues(alpha: 0.08),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt_rounded,
                                    size: w * 0.040,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 45),

                        ProfileEditSection(
                          profile: p,
                          onValueChanged: _handleValueChanged,
                        ),
                      ],
                    ),

                    if (_isSaving)
                      Positioned.fill(
                        child: Container(
                          color: Colors.white.withValues(alpha: 0.01),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}