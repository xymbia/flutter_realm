import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/date_picker_widget_config.dart';
import '../screens/date_picker_example.dart';
import '../utils/date_util.dart';
import '../utils/font_helper.dart';
import 'date_picker_widget.dart';

class CustomDatePickerWidget extends StatefulWidget {
  final DatePickerSelectionMode selectionMode;
  final DateTime? initialSelectedDate;
  final List<DateTime>? initialSelectedRange;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Color? selectedDayHighlightColor;
  final TextStyle? selectedRangeDayTextStyle;
  final TextStyle? selectedDayTextStyle;
  final TextStyle? weekdayLabelTextStyle;
  final TextStyle? dayTextStyle;
  final TextStyle? selectedMonthTextStyle;
  final TextStyle? selectedYearTextStyle;
  final TextStyle? disabledDayTextStyle;
  final TextStyle? controlsTextStyle;
  final BorderRadius? dayBorderRadius;
  final double? dayMaxWidth;
  final double? controlsHeight;
  final void Function(DateTime)? onSingleDateSelected;
  final void Function(DateTime? start, DateTime? end)? onRangeSelected;
  final bool Function(DateTime)? selectableDayPredicate;
  final double? cardElevation;
  final Color? cardColor;
  final Color? dividerColor;
  final String? cancelButtonLabel;
  final String? saveButtonLabel;
  final String? refreshTooltip;
  final Color? iconColor;
  final EdgeInsetsGeometry? cardMargin;
  final EdgeInsetsGeometry? cardPadding;
  final EdgeInsetsGeometry? calendarPadding;
  final List<String>? customWeekdayLabels;
  final EdgeInsets? weekdayLabelPadding;
  final EdgeInsets? monthPickerPadding;
  final EdgeInsets? yearPickerPadding;
  final BoxDecoration? weekdayLabelDecoration;
  final BoxDecoration? monthPickerDecoration;
  final BoxDecoration? yearPickerDecoration;
  final String? titleDayMode;
  final String? titleMonthMode;
  final String? titleYearMode;
  final String? titleRangeMode;
  final void Function()? onCancel;
  final void Function()? onSave;
  final void Function()? onRefresh;
  final void Function(List<DateTime>)? onMultiDatesSelected;

  // New parameters for controlling visibility
  final bool showSaveButton;
  final bool showCancelButton;
  final bool showRefreshButton;
  final bool showTitleDay;
  final bool showTitleMonth;
  final bool showTitleYear;
  final bool showTitleRange;
  final bool showMonthNavButtons;
  final bool show2Months;
  final bool showMonthYearLabel;

  // Decoration parameters
  final BoxDecoration? isTodayDecoration;
  final BoxDecoration? isSelectedDecoration;
  final BoxDecoration? isDisabledDecoration;
  final DatePickerWidgetConfig? config;
  final ScrollController? monthViewController;

  const CustomDatePickerWidget({
    Key? key,
    required this.selectionMode,
    this.initialSelectedDate,
    this.initialSelectedRange,
    this.firstDate,
    this.lastDate,
    this.selectedDayHighlightColor,
    this.selectedRangeDayTextStyle,
    this.selectedDayTextStyle,
    this.weekdayLabelTextStyle,
    this.dayTextStyle,
    this.selectedMonthTextStyle,
    this.selectedYearTextStyle,
    this.disabledDayTextStyle,
    this.controlsTextStyle,
    this.dayBorderRadius,
    this.dayMaxWidth,
    this.controlsHeight,
    this.onSingleDateSelected,
    this.onRangeSelected,
    this.selectableDayPredicate,
    this.cardElevation,
    this.cardColor,
    this.dividerColor,
    this.cancelButtonLabel,
    this.saveButtonLabel,
    this.refreshTooltip,
    this.iconColor,
    this.cardMargin,
    this.cardPadding,
    this.calendarPadding,
    this.customWeekdayLabels,
    this.weekdayLabelPadding,
    this.monthPickerPadding,
    this.yearPickerPadding,
    this.weekdayLabelDecoration,
    this.monthPickerDecoration,
    this.yearPickerDecoration,
    this.titleDayMode,
    this.titleMonthMode,
    this.titleYearMode,
    this.titleRangeMode,
    this.onCancel,
    this.onSave,
    this.onRefresh,
    // Initialize new parameters with default values
    this.showSaveButton = true,
    this.showCancelButton = true,
    this.showRefreshButton = true,
    this.showTitleDay = true,
    this.showTitleMonth = true,
    this.showTitleYear = true,
    this.showTitleRange = true,
    this.isTodayDecoration,
    this.isSelectedDecoration,
    this.isDisabledDecoration,
    this.config,
    this.onMultiDatesSelected,
    this.monthViewController,
    this.showMonthNavButtons = false,
    this.show2Months = true,
    this.showMonthYearLabel = true,
  }) : super(key: key);

  @override
  State<CustomDatePickerWidget> createState() => _CustomDatePickerWidgetState();
}

class _CustomDatePickerWidgetState extends State<CustomDatePickerWidget> {
  late DatePickerSelectionMode selectionMode;
  late DatePickerWidgetMode mode;
  late List<DateTime?> _singleDatePickerValueWithDefaultValue;
  late List<DateTime> _rangeDatePickerValueWithDefaultValue;
  DateTime? _currentDisplayedMonthDate;
  DateTime? _userSelectedMonthDate;
  String selectedMonth = '';
  int selectedYear = 0;

  // State for month/year selection
  String _tempSelectedMonth = "";
  int _tempSelectedYear = 0;
  bool _hasMonthYearChanges = false;
  DateTime? selectedDate;

  // Add ScrollController for calendar scroll view
  final ScrollController _calendarScrollController = ScrollController();
  bool _suspendDisplayedMonthUpdate = false;

  final today = DateUtils.dateOnly(DateTime.now());
  late List<DateTime?> _multiDatePickerValueWithDefaultValue = [];

  @override
  void initState() {
    super.initState();
    selectionMode = widget.selectionMode;
    mode = selectionMode == DatePickerSelectionMode.single ||
            selectionMode == DatePickerSelectionMode.multi
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
    _updateYearLabel(displayedDate);
    selectedYear = displayedDate.year;

    // Get current month
    final currentMonth = monthAbbreviations[displayedDate.month -
        1]; // months is 0-indexed, DateTime.month is 1-indexed

    // Get next month
    final nextMonthDate = DateTime(displayedDate.year, displayedDate.month + 1);
    final nextMonth = monthAbbreviations[nextMonthDate.month - 1];

    // Display both months
    if (widget.show2Months == true) {
      selectedMonth = '$currentMonth - $nextMonth';
    } else {
      selectedMonth = currentMonth;
    }
    selectedYear = displayedDate.year;
    _currentDisplayedMonthDate = displayedDate;

    // Initialize temp values
    _tempSelectedMonth = selectedMonth;
    _tempSelectedYear = selectedYear;
  }

  @override
  void didUpdateWidget(covariant CustomDatePickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectionMode != widget.selectionMode) {
      setState(() {
        selectionMode = widget.selectionMode;
        mode = selectionMode == DatePickerSelectionMode.single ||
                selectionMode == DatePickerSelectionMode.multi
            ? DatePickerWidgetMode.day
            : DatePickerWidgetMode.scroll;
      });
    }
  }

  void _updateMonthLabel(DateTime date) {
    final currentMonth = monthAbbreviations[date.month - 1];
    final nextMonthDate = DateTime(date.year, date.month + 1);
    final nextMonth = monthAbbreviations[nextMonthDate.month - 1];

    if (widget.show2Months == true) {
      selectedMonth = '$currentMonth - $nextMonth';
    } else {
      selectedMonth = currentMonth;
    }
    selectedYear = date.year;

    if (widget.show2Months == true) {
      _tempSelectedMonth = '$currentMonth - $nextMonth';
    } else {
      _tempSelectedMonth = currentMonth;
    }
    _tempSelectedYear = date.year;
  }

  void _updateYearLabel(DateTime date) {
    final nextYearDate = DateTime(date.year, date.month);
    selectedYear = nextYearDate.year;

    _tempSelectedYear = date.year;
  }

  void _handleDisplayedMonthChanged(DateTime date) {
    if (_suspendDisplayedMonthUpdate) {
      _suspendDisplayedMonthUpdate = false;
      return;
    }
    setState(() {
      _updateMonthLabel(date);
      _updateYearLabel(date);
      selectedYear = date.year;
      _currentDisplayedMonthDate = date;
    });
  }

  void _handleDisplayedMYearChanged(DateTime date) {
    if (_suspendDisplayedMonthUpdate) {
      _suspendDisplayedMonthUpdate = false;
      return;
    }
    setState(() {
      _updateYearLabel(date);
      selectedYear = date.year;
      _currentDisplayedMonthDate = date;
    });
  }

  void _handleMonthSelected(DateTime date) {
    _userSelectedMonthDate = date;

    setState(() {
      _currentDisplayedMonthDate = date;
      _updateMonthLabel(date);
      _updateYearLabel(date);
      selectedYear = date.year;

      // Check if there are changes
      _hasMonthYearChanges = true;
    });

    if (widget.showSaveButton == false) {
      _saveMonthYearSelection();
    }
  }

  void _handleYearSelected(DateTime date) {
    _userSelectedMonthDate = date;

    setState(() {
      _currentDisplayedMonthDate = date;
      selectedYear = date.year;
      _updateMonthLabel(date);
      _updateYearLabel(date);

      // Check if there are changes
      _hasMonthYearChanges = true;
    });

    if (widget.showSaveButton == false) {
      _saveMonthYearSelection();
    }
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

      // Get selected month index from 'Jan - Feb'
      final firstMonthAbbr = selectedMonth.split(' - ').first;
      final monthIndex = monthAbbreviations.indexOf(firstMonthAbbr) + 1;
      final newDate = DateTime(selectedYear, monthIndex, 1);

      // Suppress next scroll update!
      _suspendDisplayedMonthUpdate = true;

      if (selectionMode == DatePickerSelectionMode.single ||
          selectionMode == DatePickerSelectionMode.multi) {
        _singleDatePickerValueWithDefaultValue = [newDate];
        _currentDisplayedMonthDate = newDate;
      } else {
        _rangeDatePickerValueWithDefaultValue = [newDate];
        _currentDisplayedMonthDate = newDate;
      }

      mode = selectionMode == DatePickerSelectionMode.single ||
              selectionMode == DatePickerSelectionMode.multi
          ? DatePickerWidgetMode.day
          : DatePickerWidgetMode.scroll;
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
      if (selectionMode == DatePickerSelectionMode.single ||
          selectionMode == DatePickerSelectionMode.multi) {
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
      if (selectionMode == DatePickerSelectionMode.single) {
        // For single date mode, update the single date picker value
        _singleDatePickerValueWithDefaultValue = [date];
      } else if (selectionMode == DatePickerSelectionMode.multi) {
        // For multi date mode, update the multi date picker value
        _multiDatePickerValueWithDefaultValue = [];
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

        if (widget.show2Months == true) {
          selectedMonth = '$currentMonth - $nextMonth';
        } else {
          selectedMonth = currentMonth;
        }
        selectedYear = date.year;
      }
    });
  }

  /// Clears all date selections
  void clearDateSelection() {
    setState(() {
      _userSelectedMonthDate = null;
      _suspendDisplayedMonthUpdate = false;
      _hasMonthYearChanges = false;
      _tempSelectedMonth = '';
      _tempSelectedYear = 0;
      _currentDisplayedMonthDate = null;

      if (selectionMode == DatePickerSelectionMode.single ||
          selectionMode == DatePickerSelectionMode.multi) {
        _singleDatePickerValueWithDefaultValue = [];
      } else {
        _rangeDatePickerValueWithDefaultValue = [];
      }
    });
  }

  /// Sets today's date as the selected date
  void setTodayAsSelected() {
    clearDateSelection();
    final today = DateTime.now();
    setCurrentDateSelection(today);

    setState(() {
      _currentDisplayedMonthDate = DateTime(today.year, today.month);
    });

    // Scroll to today's month using controller logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_calendarScrollController.hasClients) {
        final firstDate = widget.firstDate ??
            DateTime(today.year - 2, today.month - 1, today.day - 5);
        final monthIndex = DateUtils.monthDelta(firstDate, today);

        final rowHeight =
            widget.dayMaxWidth != null ? (widget.dayMaxWidth! + 2) : 50.0;
        final dayRowsCount = 6; // Use max row count
        final totalRows = dayRowsCount + 1; // Week header + day rows
        final scrollOffset = monthIndex * (totalRows * rowHeight);

        _calendarScrollController.animateTo(
          scrollOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onUserScrolled() {
    _suspendDisplayedMonthUpdate = false;
  }

  Widget _buildCalendarLayout(Widget calendarWidget) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight * 0.9,
          child: Card(
            elevation: widget.cardElevation ?? 4,
            margin: widget.cardMargin ??
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            color: widget.cardColor ?? const Color(0xFFF7F8FA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                if (_shouldShowTitle())
                  Padding(
                    padding: widget.cardPadding ??
                        EdgeInsets.only(top: 10.h, bottom: 12.h),
                    child: Text(
                      _handleTitleText(),
                      style: Font.apply(FontStyle.medium, FontSize.h1),
                    ),
                  ),
                Divider(
                    height: 1,
                    color: widget.dividerColor ?? const Color(0xFFEDEEF0)),
                Padding(
                  padding: widget.calendarPadding ??
                      const EdgeInsets.only(left: 20, right: 8, top: 8),
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
                          child: Container(
                              padding: widget.monthPickerPadding ??
                                  EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 6.h),
                              decoration: widget.monthPickerDecoration,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      selectedMonth,
                                      style: widget.selectedMonthTextStyle,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: widget.iconColor ?? Colors.black54,
                                    size: 20.sp,
                                  ),
                                ],
                              )),
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
                          child: Container(
                              padding: widget.yearPickerPadding ??
                                  EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 6.h),
                              decoration: widget.yearPickerDecoration,
                              child: Row(
                                children: [
                                  Flexible(
                                      child: Text(
                                    selectedYear.toString(),
                                    style: widget.selectedYearTextStyle,
                                  )),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: widget.iconColor ?? Colors.black54,
                                    size: 20.sp,
                                  ),
                                ],
                              )),
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
                Divider(
                    height: 1,
                    color: widget.dividerColor ?? const Color(0xFFEDEEF0)),
                Padding(
                  padding: EdgeInsets.all(8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.showRefreshButton)
                        IconButton(
                          iconSize: 30.sp,
                          icon: const Icon(Icons.refresh),
                          color: widget.iconColor,
                          tooltip: widget.refreshTooltip ?? 'Refresh',
                          onPressed: widget.onRefresh ?? setTodayAsSelected,
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (widget.showCancelButton)
                            MaterialButton(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              onPressed: () {
                                if (mode == DatePickerWidgetMode.month ||
                                    mode == DatePickerWidgetMode.year) {
                                  if (widget.onCancel != null) {
                                    widget.onCancel!();
                                  } else {
                                    _cancelMonthYearSelection();
                                  }
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(widget.cancelButtonLabel ?? 'Cancel',
                                  style: Font.apply(
                                      FontStyle.regular, FontSize.h4)),
                            ),
                          if (widget.showSaveButton) SizedBox(width: 8.w),
                          if (widget.showSaveButton)
                            SizedBox(
                              height: 40.h,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  backgroundColor: (mode ==
                                                  DatePickerWidgetMode.month ||
                                              mode ==
                                                  DatePickerWidgetMode.year) &&
                                          _hasMonthYearChanges
                                      ? Colors.black
                                      : const Color(0xFFE0E1E4),
                                ),
                                onPressed: () {
                                  switch (mode) {
                                    case DatePickerWidgetMode.month:
                                    case DatePickerWidgetMode.year:
                                      if (widget.onSave != null) {
                                        widget.onSave!();
                                      } else {
                                        _saveMonthYearSelection();
                                      }
                                      break;
                                    default:
                                      break;
                                  }
                                },
                                child: Text(
                                  widget.saveButtonLabel ?? 'Save',
                                  style: Font.apply(
                                    FontStyle.regular,
                                    FontSize.h6,
                                    color:
                                        (mode == DatePickerWidgetMode.month ||
                                                    mode ==
                                                        DatePickerWidgetMode
                                                            .year) &&
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
        return widget.showTitleDay
            ? (widget.titleDayMode ?? 'Select a date')
            : '';
      case DatePickerWidgetMode.month:
        return widget.showTitleMonth
            ? (widget.titleMonthMode ?? 'Select a month')
            : '';
      case DatePickerWidgetMode.year:
        return widget.showTitleYear
            ? (widget.titleYearMode ?? 'Select a year')
            : '';
      case DatePickerWidgetMode.scroll:
        return widget.showTitleRange
            ? (widget.titleRangeMode ??
                (_rangeDatePickerValueWithDefaultValue.length <= 1
                    ? 'Select Start & End Date'
                    : formatDateRange(_rangeDatePickerValueWithDefaultValue)))
            : '';
    }
  }

  bool _shouldShowTitle() {
    switch (mode) {
      case DatePickerWidgetMode.day:
        return widget.showTitleDay;
      case DatePickerWidgetMode.month:
        return widget.showTitleMonth;
      case DatePickerWidgetMode.year:
        return widget.showTitleYear;
      case DatePickerWidgetMode.scroll:
        return widget.showTitleRange;
    }
  }

  Widget _buildSingleDatePickerWithValue() {
    final DatePickerWidgetConfig effectiveConfig = widget.config ??
        DatePickerWidgetConfig(
            calendarViewMode: mode,
            hideMonthPickerDividers: true,
            hideScrollViewMonthWeekHeader: true,
            hideScrollViewTopHeader: true,
            selectedDayHighlightColor:
                widget.selectedDayHighlightColor ?? Colors.grey,
            selectedRangeDayTextStyle: widget.selectedRangeDayTextStyle ??
                const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.normal),
            selectedDayTextStyle: widget.selectedDayTextStyle ??
                const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.normal),
            selectedMonthTextStyle: widget.selectedMonthTextStyle ??
                const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.normal),
            selectedYearTextStyle: widget.selectedYearTextStyle ??
                const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.normal),
            weekdayLabels: widget.customWeekdayLabels ??
                const ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
            weekdayLabelDecoration: widget.weekdayLabelDecoration,
            monthPickerPadding: widget.monthPickerPadding,
            yearPickerPadding: widget.yearPickerPadding,
            weekdayLabelPadding: widget.weekdayLabelPadding,
            weekdayLabelTextStyle: widget.weekdayLabelTextStyle ??
                Font.apply(FontStyle.regular, FontSize.h1,
                    color: Colors.black87),
            firstDayOfWeek: 0,
            controlsHeight: widget.controlsHeight ?? 50,
            dayMaxWidth: widget.dayMaxWidth ?? 50,
            dayBorderRadius: widget.dayBorderRadius ?? BorderRadius.circular(8),
            animateToDisplayedMonthDate: false,
            controlsTextStyle: widget.controlsTextStyle ??
                const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
            dayTextStyle: widget.dayTextStyle ??
                const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.normal),
            disabledDayTextStyle: widget.disabledDayTextStyle ??
                const TextStyle(color: Colors.grey),
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
            scrollViewController: _calendarScrollController,
            scrollViewOnScrolling: (_) => _onUserScrolled(),
            isTodayDecoration: widget.isTodayDecoration,
            isSelectedDecoration: widget.isSelectedDecoration,
            isDisabledDecoration: widget.isDisabledDecoration,
            show2months: widget.show2Months,
            showMonthYearLabel: widget.showMonthYearLabel,
            monthViewController: widget.monthViewController,
            hideLastMonthIcon: !widget.showMonthNavButtons,
            hideNextMonthIcon: !widget.showMonthNavButtons);
    return _buildCalendarLayout(DatePickerWidget(
      displayedMonthDate: _currentDisplayedMonthDate ??
          _singleDatePickerValueWithDefaultValue.first,
      config: effectiveConfig,
      value: _singleDatePickerValueWithDefaultValue,
      onValueChanged: _onSingleDateChanged,
      onDisplayedMonthChanged: _handleDisplayedMonthChanged,
      onDisplayedYearChanged: _handleDisplayedMYearChanged,
      onMonthSelected: _handleMonthSelected,
      onYearSelected: _handleYearSelected,
      suppressVisibleMonthReporting: _suspendDisplayedMonthUpdate,
      userSelectedDate: _userSelectedMonthDate,
      onMultiDatesSelected: widget.onMultiDatesSelected,
    ));
  }

  Widget _buildScrollRangeDatePickerWithValue() {
    final DatePickerWidgetConfig effectiveConfig = widget.config ??
        DatePickerWidgetConfig(
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
            hideMonthPickerDividers: true,
            hideScrollViewMonthWeekHeader: true,
            hideScrollViewTopHeader: true,
            selectedRangeDayTextStyle: widget.selectedRangeDayTextStyle ??
                const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.normal),
            selectedDayTextStyle: widget.selectedDayTextStyle ??
                const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.normal),
            selectedMonthTextStyle: widget.selectedMonthTextStyle ??
                const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.normal),
            selectedYearTextStyle: widget.selectedYearTextStyle ??
                const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.normal),
            weekdayLabels: widget.customWeekdayLabels ??
                const ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
            monthPickerPadding: widget.monthPickerPadding,
            yearPickerPadding: widget.yearPickerPadding,
            weekdayLabelPadding: widget.weekdayLabelPadding,
            weekdayLabelDecoration: widget.weekdayLabelDecoration,
            weekdayLabelTextStyle: widget.weekdayLabelTextStyle ??
                Font.apply(FontStyle.regular, FontSize.h1,
                    color: Colors.black87),
            firstDayOfWeek: 0,
            controlsHeight: widget.controlsHeight ?? 50,
            dayMaxWidth: widget.dayMaxWidth ?? 50,
            dayBorderRadius: widget.dayBorderRadius ?? BorderRadius.circular(8),
            animateToDisplayedMonthDate: false,
            controlsTextStyle: widget.controlsTextStyle ??
                const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
            dayTextStyle: widget.dayTextStyle ??
                const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.normal),
            disabledDayTextStyle: widget.disabledDayTextStyle ??
                const TextStyle(color: Colors.grey),
            centerAlignModePicker: true,
            useAbbrLabelForMonthModePicker: true,
            firstDate: widget.firstDate ??
                DateTime(DateTime.now().year - 2, DateTime.now().month - 1,
                    DateTime.now().day - 5),
            lastDate: widget.lastDate ??
                DateTime(DateTime.now().year + 3, DateTime.now().month + 2,
                    DateTime.now().day + 10),
            scrollViewController: _calendarScrollController,
            scrollViewOnScrolling: (_) => _onUserScrolled(),
            isTodayDecoration: widget.isTodayDecoration,
            isSelectedDecoration: widget.isSelectedDecoration,
            isDisabledDecoration: widget.isDisabledDecoration,
            show2months: widget.show2Months,
            showMonthYearLabel: widget.showMonthYearLabel,
            hideLastMonthIcon: !widget.showMonthNavButtons,
            hideNextMonthIcon: !widget.showMonthNavButtons);
    return _buildCalendarLayout(DatePickerWidget(
      displayedMonthDate: _currentDisplayedMonthDate ??
          _singleDatePickerValueWithDefaultValue.first,
      config: effectiveConfig,
      value: _rangeDatePickerValueWithDefaultValue,
      onValueChanged: _onRangeDateChanged,
      onDisplayedMonthChanged: _handleDisplayedMonthChanged,
      onDisplayedYearChanged: _handleDisplayedMYearChanged,
      onMonthSelected: _handleMonthSelected,
      onYearSelected: _handleYearSelected,
      suppressVisibleMonthReporting: _suspendDisplayedMonthUpdate,
      userSelectedDate: _userSelectedMonthDate,
      onMultiDatesSelected: widget.onMultiDatesSelected,
    ));
  }

  Widget _buildMultiDatePickerWithValue() {
    final DatePickerWidgetConfig effectiveConfig = widget.config ??
        DatePickerWidgetConfig(
            calendarType: DatePickerWidgetType.multi,
            calendarViewMode: mode,
            rangeBidirectional: true,
            selectedDayHighlightColor:
                widget.selectedDayHighlightColor ?? Colors.teal[800],
            dynamicCalendarRows: true,
            selectableDayPredicate: widget.selectableDayPredicate ??
                (day) {
                  return true;
                },
            hideMonthPickerDividers: true,
            hideScrollViewMonthWeekHeader: true,
            hideScrollViewTopHeader: true,
            selectedRangeDayTextStyle: widget.selectedRangeDayTextStyle ??
                const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.normal),
            selectedDayTextStyle: widget.selectedDayTextStyle ??
                const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.normal),
            selectedMonthTextStyle: widget.selectedMonthTextStyle ??
                const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.normal),
            selectedYearTextStyle: widget.selectedYearTextStyle ??
                const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.normal),
            weekdayLabels: widget.customWeekdayLabels ??
                const ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
            monthPickerPadding: widget.monthPickerPadding,
            yearPickerPadding: widget.yearPickerPadding,
            weekdayLabelPadding: widget.weekdayLabelPadding,
            weekdayLabelDecoration: widget.weekdayLabelDecoration,
            weekdayLabelTextStyle: widget.weekdayLabelTextStyle ??
                Font.apply(FontStyle.regular, FontSize.h1,
                    color: Colors.black87),
            firstDayOfWeek: 0,
            controlsHeight: widget.controlsHeight ?? 50,
            dayMaxWidth: widget.dayMaxWidth ?? 50,
            dayBorderRadius: widget.dayBorderRadius ?? BorderRadius.circular(8),
            animateToDisplayedMonthDate: false,
            controlsTextStyle: widget.controlsTextStyle ??
                const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
            dayTextStyle: widget.dayTextStyle ??
                const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.normal),
            disabledDayTextStyle: widget.disabledDayTextStyle ??
                const TextStyle(color: Colors.grey),
            centerAlignModePicker: true,
            useAbbrLabelForMonthModePicker: true,
            firstDate: widget.firstDate ??
                DateTime(DateTime.now().year - 2, DateTime.now().month - 1,
                    DateTime.now().day - 5),
            lastDate: widget.lastDate ??
                DateTime(DateTime.now().year + 3, DateTime.now().month + 2,
                    DateTime.now().day + 10),
            scrollViewController: _calendarScrollController,
            scrollViewOnScrolling: (_) => _onUserScrolled(),
            isTodayDecoration: widget.isTodayDecoration,
            isSelectedDecoration: widget.isSelectedDecoration,
            isDisabledDecoration: widget.isDisabledDecoration,
            show2months: widget.show2Months,
            showMonthYearLabel: widget.showMonthYearLabel,
            hideLastMonthIcon: !widget.showMonthNavButtons,
            hideNextMonthIcon: !widget.showMonthNavButtons);
    return _buildCalendarLayout(DatePickerWidget(
      config: effectiveConfig,
      value: _multiDatePickerValueWithDefaultValue,
      onValueChanged: (dates) =>
          setState(() => _multiDatePickerValueWithDefaultValue = dates),
      onDisplayedMonthChanged: _handleDisplayedMonthChanged,
      onDisplayedYearChanged: _handleDisplayedMYearChanged,
      onMultiDatesSelected: widget.onMultiDatesSelected,
      onMonthSelected: _handleMonthSelected,
      onYearSelected: _handleYearSelected,
    ));
  }

  @override
  void dispose() {
    _calendarScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mode toggle
        selectionMode == DatePickerSelectionMode.single
            ? Expanded(child: _buildSingleDatePickerWithValue())
            : selectionMode == DatePickerSelectionMode.multi
                ? Expanded(child: _buildMultiDatePickerWithValue())
                : Expanded(child: _buildScrollRangeDatePickerWithValue())
      ],
    );
  }
}
