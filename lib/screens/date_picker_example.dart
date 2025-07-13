import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_realm/presentation/theme/app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/date_picker_widget_config.dart';
import '../utils/date_util.dart';
import '../utils/font_helper.dart';
import '../widgets/date_picker_widget.dart';

class DatePickerPage extends StatefulWidget {
  const DatePickerPage({
    super.key,
  });

  @override
  State<DatePickerPage> createState() => _SwitchTilePageState();
}

class _SwitchTilePageState extends State<DatePickerPage> {
  DatePickerWidgetMode mode = DatePickerWidgetMode.day;

  String selectedMonth = "";
  int selectedYear = 0;
  bool isSingleDateMode = true;

  // State for month/year selection
  String _tempSelectedMonth = "";
  int _tempSelectedYear = 0;
  bool _hasMonthYearChanges = false;

  List<DateTime> _rangeDatePickerValueWithDefaultValue = [];

  @override
  void initState() {
    super.initState();
    // Initialize with the displayed month date
    final displayedDate =
        _singleDatePickerValueWithDefaultValue.first ?? DateTime.now();

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
  Widget build(BuildContext context) {
    DateTime? selectedDate;
    App.init(context);
    ScreenUtil.init(context, designSize: const Size(390, 848));

    return Scaffold(
        appBar: AppBar(
          title: const Text('DatePicker'),
        ),
        body: Center(
          child: Column(
            children: [
              // Mode toggle section
              SizedBox(
                width: 0.4.sw,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(isSingleDateMode == true
                            ? 'Single Mode'
                            : 'Range Mode')),
                    const SizedBox(width: 4),
                    Switch(
                      value: isSingleDateMode,
                      onChanged: (bool value) {
                        setState(() {
                          if (value) {
                            mode = DatePickerWidgetMode.day;
                          } else {
                            mode = DatePickerWidgetMode.scroll;
                          }
                          isSingleDateMode = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              isSingleDateMode
                  ? _buildSingleDatePickerWithValue()
                  : _buildScrollRangeDatePickerWithValue(),
            ],
          ),
        ));
  }

  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now().add(const Duration(days: 1)),
  ];

  // Track the currently displayed month date
  DateTime? _currentDisplayedMonthDate;

  void _handleDisplayedMonthChanged(DateTime date) {
    setState(() {
      // Get current month
      final currentMonth = monthAbbreviations[
          date.month - 1]; // months is 0-indexed, DateTime.month is 1-indexed

      // Get next month
      final nextMonthDate = DateTime(date.year, date.month + 1);
      final nextMonth = monthAbbreviations[nextMonthDate.month - 1];

      // Display both months
      selectedMonth = '$currentMonth - $nextMonth';
      selectedYear = date.year;
      _currentDisplayedMonthDate = date;
      
      // Update temp values to match
      _tempSelectedMonth = selectedMonth;
      _tempSelectedYear = selectedYear;
    });
  }

  void _handleMonthSelected(DateTime date) {
    setState(() {
      _currentDisplayedMonthDate = date;

      // Update temp selectedMonth to show both current and next month
      final currentMonth = monthAbbreviations[date.month - 1];
      final nextMonthDate = DateTime(date.year, date.month + 1);
      final nextMonth = monthAbbreviations[nextMonthDate.month - 1];
      _tempSelectedMonth = '$currentMonth - $nextMonth';
      _tempSelectedYear = date.year;
      
      // Check if there are changes
      _hasMonthYearChanges = true;
    });
  }

  void _handleYearSelected(DateTime date) {
    setState(() {
      _currentDisplayedMonthDate = date;
      _tempSelectedYear = date.year;
      
      // Check if there are changes
      _hasMonthYearChanges = true;
    });
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
    return SizedBox(
      height: 0.8.sh,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: const Color(0xFFF7F8FA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Header section
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
              child: Text(_handleTitleText(),
                  style: Font.apply(FontStyle.medium, FontSize.h4)),
            ),
            const Divider(height: 1, color: Color(0xFFEDEEF0)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    splashColor: Colors.white,
                    onTap: () {
                      setState(() {
                        mode = DatePickerWidgetMode.month;
                      });
                    },
                    hoverColor: Colors.yellow,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors
                            .transparent, // material color will cover this
                      ),
                      child: Row(
                        children: [
                          Text(selectedMonth,
                              style:
                                  Font.apply(FontStyle.regular, FontSize.h6)),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black54,
                            size: 24.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.white,
                    onTap: () {
                      setState(() {
                        mode = DatePickerWidgetMode.year;
                      });
                    },
                    hoverColor: Colors.yellow,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors
                            .transparent, // material color will cover this
                      ),
                      child: Row(
                        children: [
                          Text(selectedYear.toString(),
                              style:
                                  Font.apply(FontStyle.regular, FontSize.h6)),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black54,
                            size: 24.sp,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            // Body section
            SizedBox(
              height: 0.55.sh,
              width: 0.95.sw,
              child: calendarWidget,
            ),
            const Divider(height: 1, color: Color(0xFFEDEEF0)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    iconSize: 24,
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      setTodayAsSelected();
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          switch (mode) {
                            case DatePickerWidgetMode.month:
                            case DatePickerWidgetMode.year:
                              // Cancel month/year selection
                              _cancelMonthYearSelection();
                              break;
                            default:
                              Navigator.pop(context);
                              break;
                          }
                        },
                        child: Text('Cancel',
                            style: Font.apply(FontStyle.regular, FontSize.h6,
                                color: const Color(0xFF393B40))),
                      ),
                      const Padding(padding: EdgeInsets.only(right: 8.0)),
                      SizedBox(
                          height: 50.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: (mode == DatePickerWidgetMode.month || mode == DatePickerWidgetMode.year) && _hasMonthYearChanges
                                  ? Colors.black
                                  : const Color(0xFFE0E1E4),
                              foregroundColor: (mode == DatePickerWidgetMode.month || mode == DatePickerWidgetMode.year) && _hasMonthYearChanges
                                  ? Colors.white
                                  : const Color(0xFFE0E1E4),
                            ),
                            onPressed: () {
                              switch (mode) {
                                case DatePickerWidgetMode.day:
                                  log('Selected Date: ${_singleDatePickerValueWithDefaultValue.first}');
                                  break;
                                case DatePickerWidgetMode.month:
                                case DatePickerWidgetMode.year:
                                  // Save the month/year selection
                                  _saveMonthYearSelection();
                                  log('Saved ${mode == DatePickerWidgetMode.month ? 'Month' : 'Year'}: ${mode == DatePickerWidgetMode.month ? selectedMonth : selectedYear}');
                                  break;
                                case DatePickerWidgetMode.scroll:
                                  log('Selected Range: ${_rangeDatePickerValueWithDefaultValue.length} dates');
                                  break;
                              }
                            },
                            child: Text('Save',
                                style: Font.apply(
                                    FontStyle.regular, FontSize.h6,
                                    color: (mode == DatePickerWidgetMode.month || mode == DatePickerWidgetMode.year) && _hasMonthYearChanges
                                        ? Colors.white
                                        : const Color(0xFF393B40))),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
    final config = DatePickerWidgetConfig(
      calendarViewMode: mode,
      hideMonthPickerDividers: true,
      hideScrollViewMonthWeekHeader: true,
      hideScrollViewTopHeader: true,
      selectedDayHighlightColor: Colors.grey,
      selectedDayTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.normal,
      ),
      weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      firstDayOfWeek: 0,
      // 0 = Sunday, 1 = Monday, etc.
      controlsHeight: 50,
      dayMaxWidth: 50,
      dayBorderRadius: BorderRadius.circular(8),
      animateToDisplayedMonthDate: false,
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      dayTextStyle: const TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.normal,
      ),
      disabledDayTextStyle: const TextStyle(
        color: Colors.grey,
      ),
      centerAlignModePicker: true,
      useAbbrLabelForMonthModePicker: true,
      firstDate: DateTime(DateTime.now().year - 2, DateTime.now().month - 1,
          DateTime.now().day - 5),
      lastDate: DateTime(DateTime.now().year + 3, DateTime.now().month + 2,
          DateTime.now().day + 10),
      selectableDayPredicate: (day) =>
          !day
              .difference(DateTime.now().add(const Duration(days: -1)))
              .isNegative &&
          day.isBefore(DateTime.now().add(const Duration(days: 60))),
    );
    return _buildCalendarLayout(DatePickerWidget(
      displayedMonthDate: _currentDisplayedMonthDate ??
          _singleDatePickerValueWithDefaultValue.first,
      config: config,
      value: _singleDatePickerValueWithDefaultValue,
      onValueChanged: (dates) =>
          setState(() => _singleDatePickerValueWithDefaultValue = dates),
      onDisplayedMonthChanged: _handleDisplayedMonthChanged,
      onMonthSelected: _handleMonthSelected,
      onYearSelected: _handleYearSelected,
    ));
  }

  Widget _buildScrollRangeDatePickerWithValue() {
    final config = DatePickerWidgetConfig(
      calendarType: DatePickerWidgetType.range,
      calendarViewMode: mode,
      rangeBidirectional: true,
      selectedDayHighlightColor: Colors.teal[800],
      dynamicCalendarRows: true,
      selectableDayPredicate: (day) {
        return true;
      },
    );
    return _buildCalendarLayout(DatePickerWidget(
      config: config,
      value: _rangeDatePickerValueWithDefaultValue,
      onValueChanged: (dates) =>
          setState(() => _rangeDatePickerValueWithDefaultValue = dates),
      onDisplayedMonthChanged: _handleDisplayedMonthChanged,
      onMonthSelected: _handleMonthSelected,
      onYearSelected: _handleYearSelected,
    ));
  }
}
