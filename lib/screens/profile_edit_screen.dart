import 'package:flutter/material.dart';
import '../user/profile_scope.dart';
import 'dart:io';
import '../user/user_profile.dart';
import '../widgets/Profile/profile_edit_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_compress_plus/image_compress_plus.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  UserProfile? _editedProfile;
  bool _isSaving = false;
  bool _isPickingAvatar = false;

  final ImagePicker _picker = ImagePicker();
  File? _selectedAvatarFile;

  @override
  void initState() {
    super.initState();
    _recoverLostAvatarPick();
  }

  void _handleValueChanged(String title, String newValue) {
    if (_editedProfile == null) return;

    setState(() {
      switch (title) {
        case 'Name':
          _editedProfile = _editedProfile!.copyWith(username: newValue);
          break;
        case 'Gender':
          final defaultAvatar = newValue.toLowerCase() == 'male'
              ? 'assets/avatars/boy.png'
              : 'assets/avatars/woman.png';

          _editedProfile = _editedProfile!.copyWith(
            gender: newValue,
            avatarAsset: defaultAvatar,
          );
          break;
        case 'Birthday':
          final zodiac = _getZodiacSign(newValue);
          _editedProfile = _editedProfile!.copyWith(
            birthday: newValue,
            zodiacSign: zodiac,
          );
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

  String _getZodiacSign(String birthday) {
    try {
      final date = DateFormat('dd MMMM yyyy').parse(birthday);

      final day = date.day;
      final month = date.month;

      if ((month == 3 && day >= 21) || (month == 4 && day <= 20)) {
        return 'Aries';
      } else if ((month == 4 && day >= 21) || (month == 5 && day <= 19)) {
        return 'Taurus';
      } else if ((month == 5 && day >= 20) || (month == 6 && day <= 21)) {
        return 'Gemini';
      } else if ((month == 6 && day >= 22) || (month == 7 && day <= 22)) {
        return 'Cancer';
      } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
        return 'Leo';
      } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
        return 'Virgo';
      } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
        return 'Libra';
      } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
        return 'Scorpio';
      } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
        return 'Sagittarius';
      } else if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
        return 'Capricorn';
      } else if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
        return 'Aquarius';
      } else {
        return 'Pisces';
      }
    } catch (_) {
      return _editedProfile?.zodiacSign ?? '';
    }
  }

  Future<void> _recoverLostAvatarPick() async {
    try {
      final response = await _picker.retrieveLostData();
      if (response.isEmpty) return;

      final file = response.file;
      if (file == null) {
        if (response.exception != null && mounted) {
          _showError('Could not restore the selected photo.');
        }
        return;
      }

      if (!mounted) return;

      setState(() {
        _selectedAvatarFile = File(file.path);
      });
    } catch (_) {
      if (!mounted) return;
      _showError('Could not restore the selected photo.');
    }
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

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to save profile')));
    }
  }

  void _showAvatarActionSheet() {
    if (_isPickingAvatar) return;

    final w = MediaQuery.of(context).size.width;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(w * 0.06, 10, w * 0.06, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Edit profile picture',
                    style: TextStyle(
                      fontSize: (w * 0.045).clamp(17.0, 20.0),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Divider(
                    height: 1,
                    thickness: 0.7,
                    color: Colors.black.withValues(alpha: 0.08),
                  ),
                  _BottomSheetActionRow(
                    icon: Icons.image_outlined,
                    label: 'Choose from library',
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      _chooseFromLibrary();
                    },
                  ),
                  _BottomSheetActionRow(
                    icon: Icons.photo_camera_outlined,
                    label: 'Take photo',
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      _takePhoto();
                    },
                  ),
                  _BottomSheetActionRow(
                    icon: Icons.delete_outline,
                    label: 'Remove current picture',
                    isDestructive: true,
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      _removeCurrentPicture();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _chooseFromLibrary() async {
    await _pickAndProcessAvatar(ImageSource.gallery);
  }

  Future<void> _takePhoto() async {
    final permission = await Permission.camera.request();

    if (permission.isDenied) {
      _showError('Camera access was denied.');
      return;
    }

    if (permission.isPermanentlyDenied || permission.isRestricted) {
      _showOpenSettingsDialog(
        title: 'Camera access needed',
        message:
            'Please allow camera access in Settings to take a profile picture.',
      );
      return;
    }

    await _pickAndProcessAvatar(ImageSource.camera);
  }

  Future<void> _pickAndProcessAvatar(ImageSource source) async {
    if (_isPickingAvatar) return;

    setState(() {
      _isPickingAvatar = true;
    });

    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 100,
        preferredCameraDevice: CameraDevice.front,
      );

      if (!mounted) return;

      if (picked == null) {
        setState(() {
          _isPickingAvatar = false;
        });
        return;
      }

      final CroppedFile? cropped = await _cropAvatarToSquare(picked.path);

      if (!mounted) return;

      if (cropped == null) {
        setState(() {
          _isPickingAvatar = false;
        });
        return;
      }

      final File? compressed = await _compressAvatarTo512(cropped.path);

      if (!mounted) return;

      if (compressed == null) {
        setState(() {
          _isPickingAvatar = false;
        });
        _showError('Could not process the selected photo.');
        return;
      }

      setState(() {
        _selectedAvatarFile = compressed;
        _editedProfile = _editedProfile?.copyWith(avatarPath: compressed.path);
        _isPickingAvatar = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isPickingAvatar = false;
      });

      _showError('Could not update your profile picture.');
    }
  }

  Future<CroppedFile?> _cropAvatarToSquare(String sourcePath) async {
    return ImageCropper().cropImage(
      sourcePath: sourcePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
          hideBottomControls: true,
          initAspectRatio: CropAspectRatioPreset.square,
        ),
        IOSUiSettings(
          title: '',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
          rotateButtonsHidden: false,
          rotateClockwiseButtonHidden: false,
        ),
      ],
    );
  }

  Future<File?> _compressAvatarTo512(String sourcePath) async {
    final targetPath =
        '${Directory.systemTemp.path}/avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final XFile? result = await ImageCompressPlus.compressAndGetFile(
      sourcePath,
      targetPath,
      quality: 86,
      minWidth: 512,
      minHeight: 512,
      format: CompressFormat.jpeg,
      keepExif: false,
    );

    if (result == null) return null;
    return File(result.path);
  }

  void _removeCurrentPicture() {
    setState(() {
      _selectedAvatarFile = null;
      _editedProfile = _editedProfile?.copyWith(clearAvatarPath: true);
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showOpenSettingsDialog({
    required String title,
    required String message,
  }) async {
    if (!mounted) return;

    await showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(message),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = ProfileScope.of(context);
    _editedProfile ??= store.profile;
    final p = _editedProfile!;

    final route = ModalRoute.of(context);
    final anim = route?.secondaryAnimation ?? kAlwaysDismissedAnimation;

    final w = MediaQuery.of(context).size.width;

    ImageProvider _buildAvatarProvider(UserProfile p) {
      if (_selectedAvatarFile != null) {
        return FileImage(_selectedAvatarFile!);
      }

      final avatarPath = p.avatarPath;
      if (avatarPath != null && avatarPath.isNotEmpty) {
        final file = File(avatarPath);
        if (file.existsSync()) {
          return FileImage(file);
        }
      }

      return AssetImage(p.avatarAsset);
    }

    final avatarProvider = _buildAvatarProvider(p);

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
                                child: Padding(
                                  padding: EdgeInsets.only(right: (w * 0.005).clamp(6.0, 14.0)),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 180),
                                    child: _isSaving
                                        ? SizedBox(
                                            key: const ValueKey('loading'),
                                            width: (w * 0.055).clamp(
                                              16.0,
                                              35.0,
                                            ),
                                            height: (w * 0.055).clamp(
                                              16.0,
                                              35.0,
                                            ),
                                            child:
                                                const CupertinoActivityIndicator(),
                                          )
                                        : TextButton(
                                            key: const ValueKey('done'),
                                            style: ButtonStyle(
                                              overlayColor:
                                                  WidgetStateProperty.all(
                                                    Colors.transparent,
                                                  ),
                                              foregroundColor:
                                                  WidgetStateProperty.resolveWith(
                                                    (states) {
                                                      if (states.contains(
                                                        WidgetState.pressed,
                                                      )) {
                                                        return Colors.black
                                                            .withValues(
                                                              alpha: 0.45,
                                                            );
                                                      }
                                                      return Colors.black;
                                                    },
                                                  ),
                                              textStyle:
                                                  WidgetStateProperty.all(
                                                    TextStyle(
                                                      fontSize: (w * 0.042)
                                                          .clamp(15.0, 17.0),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                            ),
                                            onPressed: _saveProfile,
                                            child: const Text('Done'),
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

                        Expanded(
                          child: SingleChildScrollView(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            padding: EdgeInsets.only(
                              top: 40,
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom + 24,
                            ),
                            child: Column(
                              children: [
                                Center(
                                  child: GestureDetector(
                                    onTap: _showAvatarActionSheet,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        CircleAvatar(
                                          radius: (w * 0.12).clamp(40.0, 56.0),
                                          backgroundImage: avatarProvider,
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
                                                color: Colors.black.withValues(
                                                  alpha: 0.08,
                                                ),
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
                                ),

                                const SizedBox(height: 45),

                                ProfileEditSection(
                                  profile: p,
                                  onValueChanged: _handleValueChanged,
                                ),
                              ],
                            ),
                          ),
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

class _BottomSheetActionRow extends StatelessWidget {
  const _BottomSheetActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? const Color(0xFFFF2D55) : Colors.black;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
