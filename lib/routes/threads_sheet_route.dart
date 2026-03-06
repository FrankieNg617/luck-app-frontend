import 'package:flutter/material.dart';

class ThreadsSheetRoute<T> extends PageRouteBuilder<T> {
  ThreadsSheetRoute({
    required WidgetBuilder builder,
  }) : super(
          opaque: false,
          barrierDismissible: true,
          barrierColor: Colors.black.withValues(alpha: 0.32),
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 520),
          pageBuilder: (context, animation, secondaryAnimation) {
            return builder(context);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutQuart,
              reverseCurve: Curves.easeInCubic,
            );

            final slide = Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curved);

            final fade = Tween<double>(
              begin: 0,
              end: 1,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ));

            return FadeTransition(
              opacity: fade,
              child: SlideTransition(
                position: slide,
                child: child,
              ),
            );
          },
        );
}