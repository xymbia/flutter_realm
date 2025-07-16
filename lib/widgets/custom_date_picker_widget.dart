import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/date_picker_widget_config.dart';
import '../utils/date_util.dart';
import '../utils/font_helper.dart';
import 'date_picker_widget.dart';

class CustomDatePickerWidget extends StatefulWidget {
  final bool initialSingleMode;
  final DateTime? initialSelectedDate;
  final List<DateTime>? initialSelectedRange;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Color? selectedDayHighlightColor;
  final TextStyle? selectedDayTextStyle;
  final TextStyle? weekdayLabelTextStyle;
  final TextStyle? dayTextStyle;
  final TextStyle? disabledDayTextStyle;
  final TextStyle? controlsTextStyle;
  final BorderRadius? dayBorderRadius;
  final double? dayMaxWidth;
  final double? controlsHeight;
  final void Function(DateTime)? onSingleDateSelected;
  final void Function(DateTime? start, DateTime? end)? onRangeSelected;
  final bool Function(DateTime)? selectableDayPredicate;

  const CustomDatePickerWidget({
    Key? key,
    this.initialSingleMode = true,
    this.initialSelectedDate,
    this.initialSelectedRange,
    this.firstDate,
    this.lastDate,
    this.selectedDayHighlightColor,
    this.selectedDayTextStyle,
    this.weekdayLabelTextStyle,
    this.dayTextStyle,
    this.disabledDayTextStyle,
    this.controlsTextStyle,
    this.dayBorderRadius,
    this.dayMaxWidth,
    this.controlsHeight,
    this.onSingleDateSelected,
    this.onRangeSelected,
    this.selectableDayPredicate,
  }) : super(key: key);

  @override
  State<CustomDatePickerWidget> createState() => _CustomDatePickerWidgetState();
}

class _CustomDatePickerWidgetState extends State<CustomDatePickerWidget> {
  late bool isSingleDateMode;
  late DatePickerWidgetMode mode;
  late List<DateTime?> _singleDatePickerValueWithDefaultValue;
  late List<DateTime> _rangeDatePickerValueWithDefaultValue;
  DateTime? _currentDisplayedMonthDate;
  String selectedMonth = '';
  int selectedYear = 0;

  // State for month/year selection
  String _tempSelectedMonth = "";
  int _tempSelectedYear = 0;
  bool _hasMonthYearChanges = false;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    isSingleDateMode = widget.initialSingleMode;
    mode = isSingleDateMode
        ? DatePickerWidgetMode.day
        : DatePickerWidgetMode.scroll;
    _singleDatePickerValueWithDefaultValue = [
      widget.initialSelectedDate ?? DateTime.now()
    ];
    _rangeDatePickerValueWithDefaultValue = widget.initialSelectedRange ?? [];
    final displayedDate =
        _singleDatePickerValueWithDefaultValue.first ?? DateTime.now();
    _currentDisplayedMonthDate = displayedDate;
    _updateMonthLabel(displayedDate);
    selectedYear = displayedDate.year;

    // Get current month
    final currentMonth = monthAbbreviations[displayedDate.month -
        1]; // months is 0-indexed, DateTime.month is 1-indexed

    // Get next month
    final nextMonthDate = DateTime(displayedDate.year, displayedDate.month + 1);
    final nextMonth = monthAbbreviations[nextMonthDate.month - 1];

    // Display both months
    selectedMonth = '$currentMonth - $nextMonth';
    selectedYear = displayedDate.year;
    _currentDisplayedMonthDate = displayedDate;

    // Initialize temp values
    _tempSelectedMonth = selectedMonth;
    _tempSelectedYear = selectedYear;
  }

  @override
  void didUpdateWidget(covariant CustomDatePickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSingleMode != widget.initialSingleMode) {
      setState(() {
        isSingleDateMode = widget.initialSingleMode;
        mode = isSingleDateMode
            ? DatePickerWidgetMode.day
            : DatePickerWidgetMode.scroll;
      });
    }
  }

  void _updateMonthLabel(DateTime date) {
    final currentMonth = monthAbbreviations[date.month - 1];
    final nextMonthDate = DateTime(date.year, date.month + 1);
    final nextMonth = monthAbbreviations[nextMonthDate.month - 1];
    selectedMonth = '$currentMonth - $nextMonth';

    _tempSelectedMonth = '$currentMonth - $nextMonth';
    _tempSelectedYear = date.year;
  }

  void _handleDisplayedMonthChanged(DateTime date) {
    setState(() {
      _updateMonthLabel(date);
      selectedYear = date.year;
      _currentDisplayedMonthDate = date;
    });
  }

  void _handleMonthSelected(DateTime date) {
    setState(() {
      _currentDisplayedMonthDate = date;
      _updateMonthLabel(date);
      selectedYear = date.year;

      // Check if there are changes
      _hasMonthYearChanges = true;
    });
  }

  void _handleYearSelected(DateTime date) {
    setState(() {
      _currentDisplayedMonthDate = date;
      selectedYear = date.year;
      _updateMonthLabel(date);

      // Check if there are changes
      _hasMonthYearChanges = true;
    });
  }

  void _onSingleDateChanged(List<DateTime?> dates) {
    setState(() {
      _singleDatePickerValueWithDefaultValue = dates;
    });
    if (dates.isNotEmpty &&
        dates.first != null &&
        widget.onSingleDateSelected != null) {
      widget.onSingleDateSelected!(dates.first!);
    }
  }

  void _onRangeDateChanged(List<DateTime?> dates) {
    setState(() {
      _rangeDatePickerValueWithDefaultValue =
          dates.whereType<DateTime>().toList();
    });
    if (widget.onRangeSelected != null) {
      final start = _rangeDatePickerValueWithDefaultValue.isNotEmpty
          ? _rangeDatePickerValueWithDefaultValue.first
          : null;
      final end = _rangeDatePickerValueWithDefaultValue.length > 1
          ? _rangeDatePickerValueWithDefaultValue.last
          : null;
      widget.onRangeSelected!(start, end);
    }
  }

  /// Saves the month/year selection and resets the change flag
  void _saveMonthYearSelection() {
    setState(() {
      selectedMonth = _tempSelectedMonth;
      selectedYear = _tempSelectedYear;
      _hasMonthYearChanges = false;

      // Switch back to day mode after saving
      if (isSingleDateMode) {
        mode = DatePickerWidgetMode.day;
      } else {
        mode = DatePickerWidgetMode.scroll;
      }
    });
  }

  /// Cancels the month/year selection and resets to original values
  void _cancelMonthYearSelection() {
    setState(() {
      // Reset temp values to original
      _tempSelectedMonth = selectedMonth;
      _tempSelectedYear = selectedYear;
      _hasMonthYearChanges = false;

      // Switch back to day mode after canceling
      if (isSingleDateMode) {
        mode = DatePickerWidgetMode.day;
      } else {
        mode = DatePickerWidgetMode.scroll;
      }
    });
  }

  /// Sets the current date selection programmatically
  ///
  /// [date] - The date to set as selected
  /// [updateDisplayedMonth] - Whether to also update the displayed month to show the selected date's month
  void setCurrentDateSelection(DateTime date,
      {bool updateDisplayedMonth = true}) {
    setState(() {
      if (isSingleDateMode) {
        // For single date mode, update the single date picker value
        _singleDatePickerValueWithDefaultValue = [date];
      } else {
        // For range mode, add the date to the range or replace existing selection
        if (_rangeDatePickerValueWithDefaultValue.isEmpty) {
          _rangeDatePickerValueWithDefaultValue = [date];
        } else if (_rangeDatePickerValueWithDefaultValue.length == 1) {
          // If only start date is set, set this as end date
          final startDate = _rangeDatePickerValueWithDefaultValue[0];
          if (date.isAfter(startDate)) {
            _rangeDatePickerValueWithDefaultValue = [startDate, date];
          } else {
            // If selected date is before start date, make it the new start date
            _rangeDatePickerValueWithDefaultValue = [date, startDate];
          }
        } else {
          // If both dates are set, replace with new selection
          _rangeDatePickerValueWithDefaultValue = [date];
        }
      }

      // Update displayed month if requested
      if (updateDisplayedMonth) {
        _currentDisplayedMonthDate = DateTime(date.year, date.month);

        // Update the month/year display
        final currentMonth = monthAbbreviations[date.month - 1];
        final nextMonthDate = DateTime(date.year, date.month + 1);
        final nextMonth = monthAbbreviations[nextMonthDate.month - 1];
        selectedMonth = '$currentMonth - $nextMonth';
        selectedYear = date.year;
      }
    });
  }

  /// Clears all date selections
  void clearDateSelection() {
    setState(() {
      if (isSingleDateMode) {
        _singleDatePickerValueWithDefaultValue = [];
      } else {
        _rangeDatePickerValueWithDefaultValue = [];
      }
    });
  }

  /// Sets today's date as the selected date
  void setTodayAsSelected() {
    clearDateSelection();
    setCurrentDateSelection(DateTime.now());
  }

  Widget _buildCalendarLayout(Widget calendarWidget) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight * 0.9,
          child: Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            color: const Color(0xFFF7F8FA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10.h, bottom: 12.h),
                  child: Text(
                    _handleTitleText(),
                    style: Font.apply(FontStyle.medium, FontSize.h3),
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFEDEEF0)),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 8, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              mode = DatePickerWidgetMode.month;
                            });
                          },
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  selectedMonth,
                                  style: Font.apply(FontStyle.regular, FontSize.h4),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black54,
                                size: 20.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(flex: 3),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              mode = DatePickerWidgetMode.year;
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                selectedYear.toString(),
                                style: Font.apply(FontStyle.regular, FontSize.h4),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black54,
                                size: 20.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: calendarWidget,
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFEDEEF0)),
                Padding(
                  padding: EdgeInsets.all(8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        iconSize: 30.sp,
                        icon: const Icon(Icons.refresh),
                        onPressed: setTodayAsSelected,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MaterialButton(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            onPressed: () {
                              mode == DatePickerWidgetMode.month || mode == DatePickerWidgetMode.year
                                  ? _cancelMonthYearSelection()
                                  : Navigator.pop(context);
                            },
                            child: Text('Cancel', style: Font.apply(FontStyle.regular, FontSize.h4)),
                          ),
                          SizedBox(width: 8.w),
                          SizedBox(
                            height: 40.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                backgroundColor: (mode == DatePickerWidgetMode.month ||
                                    mode == DatePickerWidgetMode.year) &&
                                    _hasMonthYearChanges
                                    ? Colors.black
                                    : const Color(0xFFE0E1E4),
                              ),
                              onPressed: () {
                                switch (mode) {
                                  case DatePickerWidgetMode.month:
                                  case DatePickerWidgetMode.year:
                                    _saveMonthYearSelection();
                                    break;
                                  default:
                                    break;
                                }
                              },
                              child: Text(
                                'Save',
                                style: Font.apply(
                                  FontStyle.regular,
                                  FontSize.h6,
                                  color: (mode == DatePickerWidgetMode.month ||
                                      mode == DatePickerWidgetMode.year) &&
                                      _hasMonthYearChanges
                                      ? Colors.white
                                      : const Color(0xFF393B40),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  String _handleTitleText() {
    switch (mode) {
      case DatePickerWidgetMode.day:
        return 'Select a date';
      case DatePickerWidgetMode.month:
        return 'Select a month';
      case DatePickerWidgetMode.year:
        return 'Select a year';
      case DatePickerWidgetMode.scroll:
        return _rangeDatePickerValueWithDefaultValue.length <= 1
            ? 'Select Start & End Date'
            : formatDateRange(_rangeDatePickerValueWithDefaultValue);
    }
  }

  Widget _buildSingleDatePickerWithValue() {
    return _buildCalendarLayout(DatePickerWidget(
      displayedMonthDate: _currentDisplayedMonthDate ??
          _singleDatePickerValueWithDefaultValue.first,
      config: DatePickerWidgetConfig(
        calendarViewMode: mode,
        hideMonthPickerDividers: true,
        hideScrollViewMonthWeekHeader: true,
        hideScrollViewTopHeader: true,
        selectedDayHighlightColor:
            widget.selectedDayHighlightColor ?? Colors.grey,
        selectedDayTextStyle: widget.selectedDayTextStyle ??
            const TextStyle(color: Colors.black54, fontWeight: FontWeight.normal),
        weekdayLabels: const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        weekdayLabelTextStyle: widget.weekdayLabelTextStyle ??
            const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        firstDayOfWeek: 0,
        controlsHeight: widget.controlsHeight ?? 50,
        dayMaxWidth: widget.dayMaxWidth ?? 50,
        dayBorderRadius: widget.dayBorderRadius ?? BorderRadius.circular(8),
        animateToDisplayedMonthDate: false,
        controlsTextStyle: widget.controlsTextStyle ??
            const TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
        dayTextStyle: widget.dayTextStyle ??
            const TextStyle(
                color: Colors.black54, fontWeight: FontWeight.normal),
        disabledDayTextStyle:
            widget.disabledDayTextStyle ?? const TextStyle(color: Colors.grey),
        centerAlignModePicker: true,
        useAbbrLabelForMonthModePicker: true,
        firstDate: widget.firstDate ??
            DateTime(DateTime.now().year - 2, DateTime.now().month - 1,
                DateTime.now().day - 5),
        lastDate: widget.lastDate ??
            DateTime(DateTime.now().year + 3, DateTime.now().month + 2,
                DateTime.now().day + 10),
        selectableDayPredicate: widget.selectableDayPredicate ??
            (day) {
              return true;
            },
      ),
      value: _singleDatePickerValueWithDefaultValue,
      onValueChanged: _onSingleDateChanged,
      onDisplayedMonthChanged: _handleDisplayedMonthChanged,
      onMonthSelected: _handleMonthSelected,
      onYearSelected: _handleYearSelected,
    ));
  }

  Widget _buildScrollRangeDatePickerWithValue() {
    return _buildCalendarLayout(DatePickerWidget(
      displayedMonthDate: _currentDisplayedMonthDate ??
          _singleDatePickerValueWithDefaultValue.first,
      config: DatePickerWidgetConfig(
        calendarType: DatePickerWidgetType.range,
        calendarViewMode: mode,
        rangeBidirectional: true,
        selectedDayHighlightColor:
            widget.selectedDayHighlightColor ?? Colors.teal[800],
        dynamicCalendarRows: true,
        selectableDayPredicate: widget.selectableDayPredicate ??
            (day) {
              return true;
            },
      ),
      value: _rangeDatePickerValueWithDefaultValue,
      onValueChanged: _onRangeDateChanged,
      onDisplayedMonthChanged: _handleDisplayedMonthChanged,
      onMonthSelected: _handleMonthSelected,
      onYearSelected: _handleYearSelected,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mode toggle
        isSingleDateMode
            ? Expanded(child: _buildSingleDatePickerWithValue())
            : Expanded(child: _buildScrollRangeDatePickerWithValue())
      ],
    );
  }
}
