import 'dart:math';

import 'package:flutter/material.dart';

import '../models/date_picker_widget_config.dart';

/// Display CalendarDatePicker with action buttons
Future<List<DateTime?>?> showDatePickerWidgetDialog({
  required BuildContext context,
  required DatePickerWidgetWithActionButtonsConfig config,
  required Size dialogSize,
  List<DateTime?> value = const [],
  BorderRadius? borderRadius,
  bool useRootNavigator = true,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  bool useSafeArea = true,
  Color? dialogBackgroundColor,
  RouteSettings? routeSettings,
  String? barrierLabel,
  TransitionBuilder? builder,
}) {
  final dialogHeight = config.dayMaxWidth != null
      ? dialogSize.height
      : max(dialogSize.height, 410);
  var dialog = Dialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
    backgroundColor: dialogBackgroundColor ?? Theme.of(context).canvasColor,
    shape: RoundedRectangleBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(10),
    ),
    clipBehavior: Clip.antiAlias,
    child: SizedBox(
      width: dialogSize.width,
      height: dialogHeight.toDouble(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DatePickerWidgetWithActionButtons(
            value: value,
            config: config.copyWith(
              openedFromDialog: true,
              scrollViewConstraints: config.scrollViewConstraints ??
                  (config.calendarViewMode == DatePickerWidgetMode.scroll
                      ? BoxConstraints(
                          maxHeight: dialogHeight.toDouble() - 24 * 2)
                      : null),
            ),
          ),
        ],
      ),
    ),
  );

  return showDialog<List<DateTime?>>(
    context: context,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
  );
}
