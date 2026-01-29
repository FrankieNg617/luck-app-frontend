import 'package:flutter/material.dart';

class IrisController {
  /// 1.0 = fully open (invisible)
  /// 0.0 = fully closed (black screen)
  static final ValueNotifier<double> radiusFactor =
      ValueNotifier<double>(1.0);

  static void close() => radiusFactor.value = 0.0;
  static void open() => radiusFactor.value = 1.0;
}
