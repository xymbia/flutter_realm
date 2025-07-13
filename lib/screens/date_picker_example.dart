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
                          if(value){
                            mode = DatePickerWidgetMode.day;
                          }else{
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
    });
  }

  void _handleMonthSelected(DateTime date) {
    setState(() {
      _currentDisplayedMonthDate = date;

      // Update selectedMonth to show both current and next month
      final currentMonth = monthAbbreviations[date.month - 1];
      final nextMonthDate = DateTime(date.year, date.month + 1);
      final nextMonth = monthAbbreviations[nextMonthDate.month - 1];
      selectedMonth = '$currentMonth - $nextMonth';
    });
  }

  void _handleYearSelected(DateTime date) {
    setState(() {
      _currentDisplayedMonthDate = date;
    });
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
              child: Text(
                  _handleTitleText(),
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
                      // ...
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
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
                              backgroundColor: const Color(0xFFE0E1E4),
                              foregroundColor: const Color(0xFFE0E1E4),
                            ),
                            onPressed: () {

                              switch(mode){
                                case DatePickerWidgetMode.day:
                                  log('Selected Date: ${_singleDatePickerValueWithDefaultValue.first}');
                                  break;
                                case DatePickerWidgetMode.month:
                                  log('Selected Month: $selectedMonth');

                                  if(isSingleDateMode){
                                    setState(() {
                                      mode = DatePickerWidgetMode.day;
                                    });
                                  }else{
                                    setState(() {
                                      mode = DatePickerWidgetMode.scroll;
                                    });
                                  }

                                  break;
                                case DatePickerWidgetMode.year:
                                  log('Selected Year: $selectedYear');

                                  if(isSingleDateMode){
                                    setState(() {
                                      mode = DatePickerWidgetMode.day;
                                    });
                                  }else{
                                    setState(() {
                                      mode = DatePickerWidgetMode.scroll;
                                    });
                                  }
                                  break;
                                case DatePickerWidgetMode.scroll:
                                  log('Selected Year: $selectedYear');
                                  break;
                              }
                            },
                            child: Text('Save',
                                style: Font.apply(
                                    FontStyle.regular, FontSize.h6,
                                    color: const Color(0xFF393B40))),
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
        return _rangeDatePickerValueWithDefaultValue.length<=1 ? 'Select Start & End Date'
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
