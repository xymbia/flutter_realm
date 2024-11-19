import 'package:flutter/material.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xFF6750A4),
      surfaceTint: Color(0xFF66558F),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFEADDFF),
      onPrimaryContainer: Color(0xFF21005D),
      secondary: Color(0xFF625B71),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFE8DEF8),
      onSecondaryContainer: Color(0xFF1D192B),
      tertiary: Color(0xFF7D5260),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFFFD8E4),
      onTertiaryContainer: Color(0xFF31111D),
      error: Color(0xFFB3261E),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFF9DEDC),
      onErrorContainer: Color(0xFF410E0B),
      background: Color(0xFFFEF7FF),
      onBackground: Color(0xFF1D1B20),
      surface: Color(0xFFFEF7FF),
      onSurface: Color(0xFF1D1B20),
      surfaceVariant: Color(0xFFE7E0EB),
      onSurfaceVariant: Color(0xFF49454F),
      outline: Color(0xFF79747E),
      outlineVariant: Color(0xFFCAC4D0),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF322F35),
      inverseOnSurface: Color(0xFFF5EFF7),
      inversePrimary: Color(0xFFD0BCFF),
      primaryFixed: Color(0xFFEADDFF),
      onPrimaryFixed: Color(0xFF21005D),
      primaryFixedDim: Color(0xFFD0BCFF),
      onPrimaryFixedVariant: Color(0xFF4F378B),
      secondaryFixed: Color(0xFFE8DEF8),
      onSecondaryFixed: Color(0xFF1D192B),
      secondaryFixedDim: Color(0xFFCCC2DC),
      onSecondaryFixedVariant: Color(0xFF4A4458),
      tertiaryFixed: Color(0xFFFFD8E4),
      onTertiaryFixed: Color(0xFF31111D),
      tertiaryFixedDim: Color(0xFFEFB8C8),
      onTertiaryFixedVariant: Color(0xFF633B48),
      surfaceDim: Color(0xFFDED8E1),
      surfaceBright: Color(0xFFFEF7FF),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF7F2FA),
      surfaceContainer: Color(0xFFF3EDF7),
      surfaceContainerHigh: Color(0xFFECE6F0),
      surfaceContainerHighest: Color(0xFFE6E0E9),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xFF493971),
      surfaceTint: Color(0xFF66558F),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFF7C6BA6),
      onPrimaryContainer: Color(0xFFFFFFFF),
      secondary: Color(0xFF4A3971),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFF7D6BA6),
      onSecondaryContainer: Color(0xFFFFFFFF),
      tertiary: Color(0xFF6B2F45),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFA55F77),
      onTertiaryContainer: Color(0xFFFFFFFF),
      error: Color(0xFF6E2F2E),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFAA5F5D),
      onErrorContainer: Color(0xFFFFFFFF),
      background: Color(0xFFFEF7FF),
      onBackground: Color(0xFF1D1B20),
      surface: Color(0xFFFDF8FF),
      onSurface: Color(0xFF1C1B20),
      surfaceVariant: Color(0xFFE7E0EB),
      onSurfaceVariant: Color(0xFF45414A),
      outline: Color(0xFF625D67),
      outlineVariant: Color(0xFF7E7983),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF312F36),
      inverseOnSurface: Color(0xFFF4EFF7),
      inversePrimary: Color(0xFFD0BCFE),
      primaryFixed: Color(0xFF7C6BA6),
      onPrimaryFixed: Color(0xFFFFFFFF),
      primaryFixedDim: Color(0xFF63538C),
      onPrimaryFixedVariant: Color(0xFFFFFFFF),
      secondaryFixed: Color(0xFF7D6BA6),
      onSecondaryFixed: Color(0xFFFFFFFF),
      secondaryFixedDim: Color(0xFF63528C),
      onSecondaryFixedVariant: Color(0xFFFFFFFF),
      tertiaryFixed: Color(0xFFA55F77),
      onTertiaryFixed: Color(0xFFFFFFFF),
      tertiaryFixedDim: Color(0xFF88475F),
      onTertiaryFixedVariant: Color(0xFFFFFFFF),
      surfaceDim: Color(0xFFDDD8E0),
      surfaceBright: Color(0xFFFDF8FF),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF7F2FA),
      surfaceContainer: Color(0xFFF1ECF4),
      surfaceContainerHigh: Color(0xFFEBE6EE),
      surfaceContainerHighest: Color(0xFFE6E1E9),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xFF28174E),
      surfaceTint: Color(0xFF66558F),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFF493971),
      onPrimaryContainer: Color(0xFFFFFFFF),
      secondary: Color(0xFF28174E),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFF4A3971),
      onSecondaryContainer: Color(0xFFFFFFFF),
      tertiary: Color(0xFF420E25),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFF6B2F45),
      onTertiaryContainer: Color(0xFFFFFFFF),
      error: Color(0xFF440F11),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFF6E2F2E),
      onErrorContainer: Color(0xFFFFFFFF),
      background: Color(0xFFFEF7FF),
      onBackground: Color(0xFF1D1B20),
      surface: Color(0xFFFDF8FF),
      onSurface: Color(0xFF000000),
      surfaceVariant: Color(0xFFE7E0EB),
      onSurfaceVariant: Color(0xFF26232B),
      outline: Color(0xFF45414A),
      outlineVariant: Color(0xFF45414A),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF312F36),
      inverseOnSurface: Color(0xFFFFFFFF),
      inversePrimary: Color(0xFFF2E8FF),
      primaryFixed: Color(0xFF493971),
      onPrimaryFixed: Color(0xFFFFFFFF),
      primaryFixedDim: Color(0xFF332259),
      onPrimaryFixedVariant: Color(0xFFFFFFFF),
      secondaryFixed: Color(0xFF4A3971),
      onSecondaryFixed: Color(0xFFFFFFFF),
      secondaryFixedDim: Color(0xFF332259),
      onSecondaryFixedVariant: Color(0xFFFFFFFF),
      tertiaryFixed: Color(0xFF6B2F45),
      onTertiaryFixed: Color(0xFFFFFFFF),
      tertiaryFixedDim: Color(0xFF4F192F),
      onTertiaryFixedVariant: Color(0xFFFFFFFF),
      surfaceDim: Color(0xFFDDD8E0),
      surfaceBright: Color(0xFFFDF8FF),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF7F2FA),
      surfaceContainer: Color(0xFFF1ECF4),
      surfaceContainerHigh: Color(0xFFEBE6EE),
      surfaceContainerHighest: Color(0xFFE6E1E9),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFD0BCFF),
      surfaceTint: Color(0xFFD0BCFE),
      onPrimary: Color(0xFF381E72),
      primaryContainer: Color(0xFF4F378B),
      onPrimaryContainer: Color(0xFFEADDFF),
      secondary: Color(0xFFCCC2DC),
      onSecondary: Color(0xFF332D41),
      secondaryContainer: Color(0xFF4A4458),
      onSecondaryContainer: Color(0xFFE8DEF8),
      tertiary: Color(0xFFEFB8C8),
      onTertiary: Color(0xFF492532),
      tertiaryContainer: Color(0xFF633B48),
      onTertiaryContainer: Color(0xFFFFD8E4),
      error: Color(0xFFF2B8B5),
      onError: Color(0xFF601410),
      errorContainer: Color(0xFF8C1D18),
      onErrorContainer: Color(0xFFF9DEDC),
      background: Color(0xFF141218),
      onBackground: Color(0xFFE6E0E9),
      surface: Color(0xFF141218),
      onSurface: Color(0xFFE6E0E9),
      surfaceVariant: Color(0xFF49454E),
      onSurfaceVariant: Color(0xFFCAC4D0),
      outline: Color(0xFF938F99),
      outlineVariant: Color(0xFF49454F),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE6E0E9),
      inverseOnSurface: Color(0xFF322F35),
      inversePrimary: Color(0xFF6750A4),
      primaryFixed: Color(0xFFEADDFF),
      onPrimaryFixed: Color(0xFF21005D),
      primaryFixedDim: Color(0xFFD0BCFF),
      onPrimaryFixedVariant: Color(0xFF4F378B),
      secondaryFixed: Color(0xFFE8DEF8),
      onSecondaryFixed: Color(0xFF1D192B),
      secondaryFixedDim: Color(0xFFCCC2DC),
      onSecondaryFixedVariant: Color(0xFF4A4458),
      tertiaryFixed: Color(0xFFFFD8E4),
      onTertiaryFixed: Color(0xFF31111D),
      tertiaryFixedDim: Color(0xFFEFB8C8),
      onTertiaryFixedVariant: Color(0xFF633B48),
      surfaceDim: Color(0xFF141218),
      surfaceBright: Color(0xFF3B383E),
      surfaceContainerLowest: Color(0xFF0F0D13),
      surfaceContainerLow: Color(0xFF1D1B20),
      surfaceContainer: Color(0xFF211F26),
      surfaceContainerHigh: Color(0xFF2B2930),
      surfaceContainerHighest: Color(0xFF36343B),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFD4C1FF),
      surfaceTint: Color(0xFFD0BCFE),
      onPrimary: Color(0xFF1C0941),
      primaryContainer: Color(0xFF9987C5),
      onPrimaryContainer: Color(0xFF000000),
      secondary: Color(0xFFD4C1FF),
      onSecondary: Color(0xFF1C0841),
      secondaryContainer: Color(0xFF9987C4),
      onSecondaryContainer: Color(0xFF000000),
      tertiary: Color(0xFFFFB7CD),
      onTertiary: Color(0xFF330218),
      tertiaryContainer: Color(0xFFC57B94),
      onTertiaryContainer: Color(0xFF000000),
      error: Color(0xFFF2B8B5),
      onError: Color(0xFF601410),
      errorContainer: Color(0xFF8C1D18),
      onErrorContainer: Color(0xFFF9DEDC),
      background: Color(0xFF141218),
      onBackground: Color(0xFFE6E0E9),
      surface: Color(0xFF141218),
      onSurface: Color(0xFFE6E0E9),
      surfaceVariant: Color(0xFF49454E),
      onSurfaceVariant: Color(0xFFCAC4D0),
      outline: Color(0xFFA7A1AB),
      outlineVariant: Color(0xFF86818B),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE6E0E9),
      inverseOnSurface: Color(0xFF322F35),
      inversePrimary: Color(0xFF6750A4),
      primaryFixed: Color(0xFFE9DDFF),
      onPrimaryFixed: Color(0xFF16033C),
      primaryFixedDim: Color(0xFFD0BCFE),
      onPrimaryFixedVariant: Color(0xFF3C2C63),
      secondaryFixed: Color(0xFFE9DDFF),
      onSecondaryFixed: Color(0xFF17033C),
      secondaryFixedDim: Color(0xFFD0BCFE),
      onSecondaryFixedVariant: Color(0xFF3D2C63),
      tertiaryFixed: Color(0xFFFFD9E3),
      onTertiaryFixed: Color(0xFF2B0013),
      tertiaryFixedDim: Color(0xFFFFB0C9),
      onTertiaryFixedVariant: Color(0xFF5B2239),
      surfaceDim: Color(0xFF141218),
      surfaceBright: Color(0xFF3B383E),
      surfaceContainerLowest: Color(0xFF0F0D13),
      surfaceContainerLow: Color(0xFF1D1B20),
      surfaceContainer: Color(0xFF211F26),
      surfaceContainerHigh: Color(0xFF2B2930),
      surfaceContainerHighest: Color(0xFF36343B),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFFF9FF),
      surfaceTint: Color(0xFFD0BCFE),
      onPrimary: Color(0xFF000000),
      primaryContainer: Color(0xFFD4C1FF),
      onPrimaryContainer: Color(0xFF000000),
      secondary: Color(0xFFFFF9FF),
      onSecondary: Color(0xFF000000),
      secondaryContainer: Color(0xFFD4C1FF),
      onSecondaryContainer: Color(0xFF000000),
      tertiary: Color(0xFFFFF9F9),
      onTertiary: Color(0xFF000000),
      tertiaryContainer: Color(0xFFFFB7CD),
      onTertiaryContainer: Color(0xFF000000),
      error: Color(0xFFFFF9F9),
      onError: Color(0xFF000000),
      errorContainer: Color(0xFFFFB9B6),
      onErrorContainer: Color(0xFF000000),
      background: Color(0xFF141218),
      onBackground: Color(0xFFE6E0E9),
      surface: Color(0xFF141318),
      onSurface: Color(0xFFFFFFFF),
      surfaceVariant: Color(0xFF49454E),
      onSurfaceVariant: Color(0xFFFFF9FF),
      outline: Color(0xFFCFC8D3),
      outlineVariant: Color(0xFFCFC8D3),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE6E1E9),
      inverseOnSurface: Color(0xFF000000),
      inversePrimary: Color(0xFF302056),
      primaryFixed: Color(0xFFEDE2FF),
      onPrimaryFixed: Color(0xFF000000),
      primaryFixedDim: Color(0xFFD4C1FF),
      onPrimaryFixedVariant: Color(0xFF1C0941),
      secondaryFixed: Color(0xFFEDE2FF),
      onSecondaryFixed: Color(0xFF000000),
      secondaryFixedDim: Color(0xFFD4C1FF),
      onSecondaryFixedVariant: Color(0xFF1C0841),
      tertiaryFixed: Color(0xFFFFDFE7),
      onTertiaryFixed: Color(0xFF000000),
      tertiaryFixedDim: Color(0xFFFFB7CD),
      onTertiaryFixedVariant: Color(0xFF330218),
      surfaceDim: Color(0xFF141318),
      surfaceBright: Color(0xFF3A383E),
      surfaceContainerLowest: Color(0xFF0F0D13),
      surfaceContainerLow: Color(0xFF1C1B20),
      surfaceContainer: Color(0xFF201F24),
      surfaceContainerHigh: Color(0xFF2B292F),
      surfaceContainerHighest: Color(0xFF36343B),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        fontFamily: 'Roboto',
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
      );

  List<ExtendedColor> get extendedColors => [];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      secondary: secondary,
      surface: surface,
      error: error,
      onPrimary: onPrimary,
      onSecondary: onSecondary,
      onSurface: onSurface,
      onError: onError,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
      primaryFixed: primaryFixed,
      onPrimaryFixed: onPrimaryFixed,
      primaryFixedDim: primaryFixedDim,
      onPrimaryFixedVariant: onPrimaryFixedVariant,
      secondaryFixed: secondaryFixed,
      onSecondaryFixed: onSecondaryFixed,
      secondaryFixedDim: secondaryFixedDim,
      onSecondaryFixedVariant: onSecondaryFixedVariant,
      tertiaryFixed: tertiaryFixed,
      onTertiaryFixed: onTertiaryFixed,
      tertiaryFixedDim: tertiaryFixedDim,
      onTertiaryFixedVariant: onTertiaryFixedVariant,
      surfaceDim: surfaceDim,
      surfaceBright: surfaceBright,
      surfaceContainerLowest: surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow,
      surfaceContainer: surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh,
      surfaceContainerHighest: surfaceContainerHighest,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surfaceTint: surfaceTint,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
