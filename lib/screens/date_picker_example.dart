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

  // List of years (can be customized)
  final List<int> years = List.generate(10, (index) => 2025 - index);

  @override
  void initState() {
    super.initState();
    // Initialize with the displayed month date
    final displayedDate = _singleDatePickerValueWithDefaultValue.first ?? DateTime.now();
    
    // Get current month
    final currentMonth = monthAbbreviations[displayedDate.month - 1]; // months is 0-indexed, DateTime.month is 1-indexed
    
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
          child: _buildSingleDatePickerWithValue(),
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
      final currentMonth = monthAbbreviations[date.month - 1]; // months is 0-indexed, DateTime.month is 1-indexed
      
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
      modePickersGap: 0,
      modePickerTextHandler: ({required monthDate, isMonthPicker}) {
        if (isMonthPicker ?? false) {
          // Custom month picker text
          return '${getLocaleShortMonthFormat(const Locale('en')).format(monthDate)} C';
        }

        return null;
      },
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
                        color:
                            Colors.transparent, // material color will cover this
                      ),
                      child: Row(
                        children: [
                          Text(selectedMonth,
                              style: Font.apply(FontStyle.regular, FontSize.h6)),
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
                      // Ensure the year picker shows the currently selected year
                      print('Switching to year picker mode for year: $selectedYear');
                    },
                    hoverColor: Colors.yellow,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            Colors.transparent, // material color will cover this
                      ),
                      child: Row(
                        children: [
                          Text(selectedYear.toString(),
                              style: Font.apply(FontStyle.regular, FontSize.h6)),
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
                displayedMonthDate: _currentDisplayedMonthDate ?? _singleDatePickerValueWithDefaultValue.first,
                config: config,
                value: _singleDatePickerValueWithDefaultValue,
                onValueChanged: (dates) =>
                    setState(() => _singleDatePickerValueWithDefaultValue = dates),
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
                                style: Font.apply(FontStyle.regular, FontSize.h6,
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
}
