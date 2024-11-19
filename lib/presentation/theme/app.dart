import 'dart:core';
import 'package:flutter/material.dart';
import 'app_typography.dart';
import 'space.dart';
import 'ui.dart';
import 'ui_props.dart';

class App {
  static bool? isLtr;

  static init(BuildContext context) async {
    UI.init(context);
    UIProps.init(context);
    Space.init(context);
    AppText.init(context);
    isLtr = Directionality.of(context) == TextDirection.ltr;
  }

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
}
