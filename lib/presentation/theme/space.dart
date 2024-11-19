import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ui.dart';

class Space {
  static late Widget x;
  static late Widget y;
  static late Widget x1;
  static late Widget y1;
  static late Widget x2;
  static late Widget y2;
  static late Widget xm;
  static late Widget ym;

  static late EdgeInsets z;
  static late EdgeInsets h;
  static late EdgeInsets v;
  static late EdgeInsets h1;
  static late EdgeInsets v1;
  static late EdgeInsets h2;
  static late EdgeInsets v2;

  static late Widget top;
  static late Widget bottom;

  static void init(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 848));

    x = SizedBox(width: 10.w);
    y = SizedBox(height: 12.h);

    x1 = SizedBox(width: 17.w);
    y1 = SizedBox(height: 19.h);

    x2 = SizedBox(width: 22.w);
    y2 = SizedBox(height: 24.h);

    z = EdgeInsets.zero;
    h = EdgeInsets.symmetric(horizontal: 12.w);
    v = EdgeInsets.symmetric(vertical: 12.h);

    h1 = EdgeInsets.symmetric(horizontal: 20.w);
    v1 = EdgeInsets.symmetric(vertical: 19.h);

    h2 = EdgeInsets.symmetric(horizontal: 24.w);
    v2 = EdgeInsets.symmetric(vertical: 24.h);

    xm = ym = const Spacer();

    top = SizedBox(height: UI.padding!.top);
    bottom = SizedBox(height: UI.padding!.bottom);
  }

  static Widget xf([double no = 5]) => SizedBox(width: no.w);
  static Widget yf([double no = 5]) => SizedBox(height: no.h);

  static EdgeInsets hf([double no = 10]) =>
      EdgeInsets.symmetric(horizontal: no.w);
  static EdgeInsets vf([double no = 10]) =>
      EdgeInsets.symmetric(vertical: no.h);

  static EdgeInsets all([double h = 12, double? v]) => EdgeInsets.symmetric(
        vertical: v != null ? v.w : h.w,
        horizontal: h.w,
      );
}
