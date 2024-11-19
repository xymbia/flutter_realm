import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class UIProps {
  // Radius
  static late BorderRadius radius;
  static late BorderRadius tabRadius;
  static late BorderRadius buttonRadius;
  static late BorderRadius radiusXS;
  static late BorderRadius radiusS;
  static late BorderRadius radiusL;
  static late BorderRadius radiusXL;
  static late BoxDecoration borderButton;
  static late BorderRadius topBoth15;
  static late BorderRadius topBoth30;
  static late BorderRadius topBoth50;
  static late BorderRadius leftBoth15;
  static late BorderRadius leftBoth30;
  static late BorderRadius leftBoth50;
  static late BorderRadius rightBoth15;
  static late BorderRadius rightBoth30;
  static late BorderRadius rightBoth50;

  static init(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 848));

    initRadius(context);
  }

  static initRadius(BuildContext context) {
    radiusXS = BorderRadius.circular(ScreenUtil().radius(3));
    radiusS = BorderRadius.circular(ScreenUtil().radius(8));

    radius = BorderRadius.circular(ScreenUtil().radius(15));

    radiusL = BorderRadius.circular(ScreenUtil().radius(25));
    radiusXL = BorderRadius.circular(ScreenUtil().radius(100));

    tabRadius = radiusS;
    buttonRadius = radiusS;

    topBoth15 = BorderRadius.only(
      topLeft: Radius.circular(ScreenUtil().radius(15)),
      topRight: Radius.circular(ScreenUtil().radius(15)),
    );

    topBoth30 = BorderRadius.only(
      topLeft: Radius.circular(ScreenUtil().radius(30)),
      topRight: Radius.circular(ScreenUtil().radius(30)),
    );

    topBoth50 = BorderRadius.only(
      topLeft: Radius.circular(ScreenUtil().radius(50)),
      topRight: Radius.circular(ScreenUtil().radius(50)),
    );

    leftBoth15 = BorderRadius.only(
      topLeft: Radius.circular(ScreenUtil().radius(15)),
      bottomLeft: Radius.circular(ScreenUtil().radius(15)),
    );

    leftBoth30 = BorderRadius.only(
      topLeft: Radius.circular(ScreenUtil().radius(30)),
      bottomLeft: Radius.circular(ScreenUtil().radius(30)),
    );

    leftBoth50 = BorderRadius.only(
      topLeft: Radius.circular(ScreenUtil().radius(50)),
      bottomLeft: Radius.circular(ScreenUtil().radius(50)),
    );

    rightBoth15 = BorderRadius.only(
      topRight: Radius.circular(ScreenUtil().radius(15)),
      bottomRight: Radius.circular(ScreenUtil().radius(15)),
    );

    rightBoth30 = BorderRadius.only(
      bottomRight: Radius.circular(ScreenUtil().radius(30)),
      topRight: Radius.circular(ScreenUtil().radius(30)),
    );

    rightBoth50 = BorderRadius.only(
      bottomRight: Radius.circular(ScreenUtil().radius(50)),
      topRight: Radius.circular(ScreenUtil().radius(50)),
    );
  }

  static BorderRadius radiusAll([double radius = 15]) =>
      BorderRadius.circular(ScreenUtil().radius(radius));

  static BorderRadius radiusf(
          {double tl = 0, double tr = 0, double bl = 0, double br = 0}) =>
      BorderRadius.only(
        topLeft: Radius.circular(ScreenUtil().radius(tl)),
        topRight: Radius.circular(ScreenUtil().radius(tr)),
        bottomLeft: Radius.circular(ScreenUtil().radius(bl)),
        bottomRight: Radius.circular(ScreenUtil().radius(br)),
      );
}
