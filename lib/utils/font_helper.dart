import 'package:flutter/material.dart';

//This font class will return TextStyle with color, weight, size with optional text-decoration
class Font {
  static apply(FontStyle style, FontSize size,
      {Color? color, TextDecoration? decoration}) {
    return TextStyle(
        color: color ?? Colors.black87,
        fontWeight: style.value,
        fontSize: size.value,
        fontFamily: 'Roboto',
        decoration: decoration);
  }
}

//This enum is defined for text size in the form of headings
enum FontSize {
  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
  h7,
  h8,
  h9,
  h10;
}

//This enum is defined for font-weight
enum FontStyle { semiBold, bold, extraBold, medium, regular }

//This will return value of text size
extension FontSizes on FontSize {
  double get value {
    switch (this) {
      case FontSize.h1:
        return 28;
      case FontSize.h2:
        return 26;
      case FontSize.h3:
        return 22;
      case FontSize.h4:
        return 20;
      case FontSize.h5:
        return 18;
      case FontSize.h6:
        return 16;
      case FontSize.h7:
        return 14;
      case FontSize.h8:
        return 12;
      case FontSize.h9:
        return 10;
      case FontSize.h10:
        return 8;
    }
  }
}

//This will return style for text
extension FontStyles on FontStyle {
  FontWeight get value {
    switch (this) {
      case FontStyle.regular:
        return FontWeight.normal;

      case FontStyle.bold:
        return FontWeight.bold;

      case FontStyle.semiBold:
        return FontWeight.w700;

      case FontStyle.medium:
        return FontWeight.w600;

      case FontStyle.extraBold:
        return FontWeight.w900;
    }
  }
}
