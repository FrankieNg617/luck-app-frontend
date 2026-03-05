import 'package:flutter/material.dart';
import 'user_profile.dart';

class ProfileScope extends InheritedNotifier<UserProfileStore> {
  const ProfileScope({
    super.key,
    required UserProfileStore store,
    required Widget child,
  }) : super(notifier: store, child: child);

  static UserProfileStore of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ProfileScope>();
    assert(scope != null, 'ProfileScope not found. Wrap your app with ProfileScope.');
    return scope!.notifier!;
  }
}