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
  bool switchValue = true;
  DatePickerWidgetMode mode = DatePickerWidgetMode.day;

  String selectedMonth = "";
  int selectedYear = 0;
  bool isSingleDateMode = true;

  List<DateTime?> _rangeDatePickerValueWithDefaultValue = [
    DateTime(1999, 5, 6),
    DateTime(1999, 5, 21),
  ];

  // List of years (can be customized)
  final List<int> years = List.generate(10, (index) => 2025 - index);

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
              child: Text('Select Date',
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
              child: DatePickerWidget(
                displayedMonthDate: _currentDisplayedMonthDate ??
                    _singleDatePickerValueWithDefaultValue.first,
                config: config,
                value: _singleDatePickerValueWithDefaultValue,
                onValueChanged: (dates) => setState(
                    () => _singleDatePickerValueWithDefaultValue = dates),
                onDisplayedMonthChanged: _handleDisplayedMonthChanged,
                onMonthSelected: _handleMonthSelected,
                onYearSelected: _handleYearSelected,
              ),
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
                            onPressed: () {},
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

  Widget _buildScrollRangeDatePickerWithValue() {
    final config = DatePickerWidgetConfig(
      centerAlignModePicker: true,
      calendarType: DatePickerWidgetType.range,
      calendarViewMode: DatePickerWidgetMode.scroll,
      rangeBidirectional: true,
      selectedDayHighlightColor: Colors.teal[800],
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      dynamicCalendarRows: true,
      weekdayLabelBuilder: ({required weekday, isScrollViewTopHeader}) {
        if (weekday == DateTime.wednesday && isScrollViewTopHeader != true) {
          return const Center(
            child: Text(
              'W',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        return null;
      },
      modePickerTextHandler: ({required monthDate, isMonthPicker}) {
        if (isMonthPicker ?? false) {
          return '${getLocaleShortMonthFormat(const Locale('en')).format(monthDate)} New';
        }

        return null;
      },
      disabledDayTextStyle:
          const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
      selectableDayPredicate: (day) {
        if (_rangeDatePickerValueWithDefaultValue.isEmpty ||
            _rangeDatePickerValueWithDefaultValue.length == 2) {
          // exclude Wednesday
          return day.weekday != DateTime.wednesday;
        } else {
          // Make sure range does not contain any Wednesday
          final firstDate = _rangeDatePickerValueWithDefaultValue.first;
          final range = [firstDate!, day]..sort();
          for (var date = range.first;
              date.compareTo(range.last) <= 0;
              date = date.add(const Duration(days: 1))) {
            if (date.weekday == DateTime.wednesday) {
              return false;
            }
          }
        }
        return true;
      },
    );
    return SizedBox(
      width: 375,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          const Text('Scroll Range Date Picker'),
          SizedBox(
            height: 800,
            child: DatePickerWidget(
              config: config,
              value: _rangeDatePickerValueWithDefaultValue,
              onValueChanged: (dates) =>
                  setState(() => _rangeDatePickerValueWithDefaultValue = dates),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
