import 'package:flutter/material.dart';
import 'package:flutter_realm/presentation/theme/color_schemes.dart';

const fontFamily = 'Roboto';

final materialTheme =
    MaterialTheme(ThemeData().textTheme.apply(fontFamily: fontFamily));

final themeLight = materialTheme.light().copyWith(
      splashColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xff8E918F)),
      iconButtonTheme: const IconButtonThemeData(style: ButtonStyle()),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );

final themeDark = materialTheme.dark().copyWith(
      splashColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xff8E918F)),
      iconButtonTheme: const IconButtonThemeData(style: ButtonStyle()),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );

/**
 * {
    "seed": "#D0BCFF",
    "coreColors": {
        "primary": "#D0BCFF",
        "secondary": "#CCC2DC",
        "tertiary": "#EFB8C8",
        "error": "#F2B8B5",
        "neutral": "#79767D",
        "neutralVariant": "#79747E"
    },
 */
