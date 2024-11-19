import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_realm/presentation/theme/configs.dart';

class AppText {
  // Display
  static late TextStyle displayLarge;
  static late TextStyle displayLargeBold;
  static late TextStyle displayLargeSemiBold;
  static late TextStyle displayMedium;
  static late TextStyle displayMediumBold;
  static late TextStyle displayMediumSemiBold;
  static late TextStyle displaySmall;
  static late TextStyle displaySmallBold;
  static late TextStyle displaySmallSemiBold;

  // Headings
  static late TextStyle headlineLarge;
  static late TextStyle headlineLargeBold;
  static late TextStyle headlineLargeSemiBold;
  static late TextStyle headlineMedium;
  static late TextStyle headlineMediumBold;
  static late TextStyle headlineMediumSemiBold;
  static late TextStyle headlineSmall;
  static late TextStyle headlineSmallBold;
  static late TextStyle headlineSmallSemiBold;

  // Title
  static late TextStyle titleLarge;
  static late TextStyle titleLargeBold;
  static late TextStyle titleLargeSemiBold;
  static late TextStyle titleMedium;
  static late TextStyle titleMediumBold;
  static late TextStyle titleMediumSemiBold;
  static late TextStyle titleSmall;
  static late TextStyle titleSmallBold;
  static late TextStyle titleSmallSemiBold;

  // Body
  static late TextStyle bodyLarge;
  static late TextStyle bodyLargeBold;
  static late TextStyle bodyLargeSemiBold;
  static late TextStyle bodyMedium;
  static late TextStyle bodyMediumBold;
  static late TextStyle bodyMediumSemiBold;
  static late TextStyle bodySmall;
  static late TextStyle bodySmallBold;
  static late TextStyle bodySmallSemiBold;

  // Label
  static late TextStyle labelLarge;
  static late TextStyle labelLargeBold;
  static late TextStyle labelLargeSemiBold;
  static late TextStyle labelMedium;
  static late TextStyle labelMediumBold;
  static late TextStyle labelMediumSemiBold;
  static late TextStyle labelSmall;
  static late TextStyle labelSmallBold;
  static late TextStyle labelSmallSemiBold;

  static init(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 848));

    const b = FontWeight.bold;
    const baseStyle = TextStyle(fontFamily: fontFamily);
    const scalingFactor = 0.93;

    // Display Text Styles
    displayLarge = baseStyle.copyWith(fontSize: 57.sp * scalingFactor);
    displayLargeBold = displayLarge.copyWith(fontWeight: b);
    displayLargeSemiBold = displayLarge.copyWith(fontWeight: FontWeight.w500);

    displayMedium = baseStyle.copyWith(fontSize: 45.sp * scalingFactor);
    displayMediumBold = displayMedium.copyWith(fontWeight: b);
    displayMediumSemiBold = displayMedium.copyWith(fontWeight: FontWeight.w500);

    displaySmall = baseStyle.copyWith(fontSize: 36.sp * scalingFactor);
    displaySmallBold = displaySmall.copyWith(fontWeight: b);
    displaySmallSemiBold = displaySmall.copyWith(fontWeight: FontWeight.w500);

    // Heading Text Styles
    headlineLarge = baseStyle.copyWith(fontSize: 32.sp * scalingFactor);
    headlineLargeBold = headlineLarge.copyWith(fontWeight: b);
    headlineLargeSemiBold = headlineLarge.copyWith(fontWeight: FontWeight.w500);

    headlineMedium = baseStyle.copyWith(fontSize: 28.sp * scalingFactor);
    headlineMediumBold = headlineMedium.copyWith(fontWeight: b);
    headlineMediumSemiBold =
        headlineMedium.copyWith(fontWeight: FontWeight.w500);

    headlineSmall = baseStyle.copyWith(fontSize: 24.sp * scalingFactor);
    headlineSmallBold = headlineSmall.copyWith(fontWeight: b);
    headlineSmallSemiBold = headlineSmall.copyWith(fontWeight: FontWeight.w500);

    // Title Text Styles
    titleLarge = baseStyle.copyWith(fontSize: 22.sp * scalingFactor);
    titleLargeBold = titleLarge.copyWith(fontWeight: b);
    titleLargeSemiBold = titleLarge.copyWith(fontWeight: FontWeight.w500);

    titleMedium = baseStyle.copyWith(fontSize: 16.sp * scalingFactor);
    titleMediumBold = titleMedium.copyWith(fontWeight: b);
    titleMediumSemiBold = titleMedium.copyWith(fontWeight: FontWeight.w500);

    titleSmall = baseStyle.copyWith(fontSize: 14.sp * scalingFactor);
    titleSmallBold = titleSmall.copyWith(fontWeight: b);
    titleSmallSemiBold = titleSmall.copyWith(fontWeight: FontWeight.w500);

    // Body Text Styles
    bodyLarge = baseStyle.copyWith(fontSize: 16.sp * scalingFactor);
    bodyLargeBold = bodyLarge.copyWith(fontWeight: b);
    bodyLargeSemiBold = bodyLarge.copyWith(fontWeight: FontWeight.w500);

    bodyMedium = baseStyle.copyWith(fontSize: 14.sp * scalingFactor);
    bodyMediumBold = bodyMedium.copyWith(fontWeight: b);
    bodyMediumSemiBold = bodyMedium.copyWith(fontWeight: FontWeight.w500);

    bodySmall = baseStyle.copyWith(fontSize: 12.sp * scalingFactor);
    bodySmallBold = bodySmall.copyWith(fontWeight: b);
    bodySmallSemiBold = bodySmall.copyWith(fontWeight: FontWeight.w500);

    // Label Text Styles
    labelLarge = baseStyle.copyWith(fontSize: 14.sp * scalingFactor);
    labelLargeBold = labelLarge.copyWith(fontWeight: b);
    labelLargeSemiBold = labelLarge.copyWith(fontWeight: FontWeight.w500);

    labelMedium = baseStyle.copyWith(fontSize: 12.sp * scalingFactor);
    labelMediumBold = labelMedium.copyWith(fontWeight: b);
    labelMediumSemiBold = labelMedium.copyWith(fontWeight: FontWeight.w500);

    labelSmall = baseStyle.copyWith(fontSize: 11.sp * scalingFactor);
    labelSmallBold = labelSmall.copyWith(fontWeight: b);
    labelSmallSemiBold = labelSmall.copyWith(fontWeight: FontWeight.w500);
  }
}
