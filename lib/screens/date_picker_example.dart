import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/date_util.dart';
import '../utils/font_helper.dart';
import '../widgets/custom_date_picker_widget.dart';

enum DatePickerSelectionMode { single, multi, range }

class DatePickerPage extends StatefulWidget {
  const DatePickerPage({
    super.key,
  });

  @override
  State<DatePickerPage> createState() => _DatePickerPageState();
}

class _DatePickerPageState extends State<DatePickerPage> {
  DatePickerSelectionMode _selectionMode = DatePickerSelectionMode.single;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(540, 1080),
        minTextAdapt: true,
        splitScreenMode: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DatePicker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Radio<DatePickerSelectionMode>(
                    value: DatePickerSelectionMode.single,
                    groupValue: _selectionMode,
                    onChanged: (value) {
                      setState(() {
                        _selectionMode = value!;
                      });
                    },
                  ),
                  const Text('Single'),
                  Radio<DatePickerSelectionMode>(
                    value: DatePickerSelectionMode.multi,
                    groupValue: _selectionMode,
                    onChanged: (value) {
                      setState(() {
                        _selectionMode = value!;
                      });
                    },
                  ),
                  const Text('Multi'),
                  Radio<DatePickerSelectionMode>(
                    value: DatePickerSelectionMode.range,
                    groupValue: _selectionMode,
                    onChanged: (value) {
                      setState(() {
                        _selectionMode = value!;
                      });
                    },
                  ),
                  const Text('Range'),
                ],
              ),
            ],
          )),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomDatePickerWidget(
                      selectionMode: _selectionMode,
                      initialSelectedDate:
                          DateTime.now().add(const Duration(days: 1)),
                      initialSelectedRange: [
                        DateTime.now().add(const Duration(days: 1)),
                        DateTime.now().add(const Duration(days: 15)),
                      ],
                      firstDate: DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day),
                      lastDate: DateTime(DateTime.now().year + 50,
                          DateTime.now().month + 6, DateTime.now().day),
                      selectedDayHighlightColor: Colors.black87,
                      selectedDayTextStyle: Font.apply(
                          FontStyle.regular, FontSize.h6,
                          color: Colors.black87),
                      selectedMonthTextStyle: const TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.bold),
                      selectedYearTextStyle: const TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.bold),
                      weekdayLabelTextStyle: Font.apply(
                          FontStyle.regular, FontSize.h6,
                          color: Colors.black87),
                      dayTextStyle: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                      disabledDayTextStyle:
                          const TextStyle(color: Colors.black),
                      controlsTextStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      dayBorderRadius: BorderRadius.circular(18),
                      dayMaxWidth: 55,
                      controlsHeight: 55,
                      showMonthNavButtons: true,
                      show2Months: false,
                      showMonthYearLabel: false,
                      onSingleDateSelected: (date) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              duration: const Duration(milliseconds: 2500),
                              content:
                                  Text('Selected: \t\t${formatDate(date)}')),
                        );
                      },
                      onRangeSelected: (start, end) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              duration: const Duration(milliseconds: 2500),
                              content: Text(
                                  'Range: \t${formatDateRange([start, end])}')),
                        );
                      },
                      onMultiDatesSelected: (dates) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(milliseconds: 2500),
                            content: Text(
                                'Multi: \t${dates.map(formatDate).join(", ")}'),
                          ),
                        );
                      },
                      selectableDayPredicate: (day) {
                        return !day
                            .difference(
                                DateTime.now().add(const Duration(days: -1)))
                            .isNegative;
                      },
                      cardElevation: 2,
                      cardColor: Colors.grey[50],
                      dividerColor: Colors.blueGrey[100],
                      cancelButtonLabel: 'Dismiss',
                      saveButtonLabel: 'Apply',
                      refreshTooltip: 'Reset to Today',
                      iconColor: Colors.deepPurple,
                      cardMargin: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      cardPadding: const EdgeInsets.only(top: 18, bottom: 18),
                      calendarPadding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      customWeekdayLabels: const [
                        'S',
                        'M',
                        'T',
                        'W',
                        'T',
                        'F',
                        'S'
                      ],
                      weekdayLabelDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color(0xFFBBFBBA),
                        // Black background for today's date
                        border: Border.all(
                            width: 1, color: const Color(0xFFBBFBBA)),
                      ),
                      titleDayMode: 'Pick a Day',
                      titleMonthMode: 'Pick a Month',
                      titleYearMode: 'Pick a Year',
                      titleRangeMode: 'Pick a Date Range',
                      showSaveButton: true,
                      showCancelButton: true,
                      showRefreshButton: true,
                      showTitleDay: true,
                      showTitleMonth: true,
                      showTitleYear: true,
                      showTitleRange: true,
                      isTodayDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.redAccent,
                        border: Border.all(width: 1, color: Colors.pink),
                        shape: BoxShape.circle,
                      ),
                      isSelectedDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color(0xFFCFCFCF),
                        border: Border.all(
                            width: 1, color: const Color(0xFF393B40)),
                        shape: BoxShape.circle,
                      ),
                      isDisabledDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color(0xFFCFCFCF),
                        border: Border.all(
                            width: 1, color: const Color(0xFF393B40)),
                      )))),
        ],
      ),
    );
  }
}
