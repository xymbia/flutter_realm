import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/date_picker_widget_config.dart';
import '../utils/date_util.dart';
import '../utils/font_helper.dart';
import '../widgets/custom_date_picker_widget.dart';

class DatePickerPage extends StatefulWidget {
  const DatePickerPage({
    super.key,
  });

  @override
  State<DatePickerPage> createState() => _DatePickerPageState();
}

class _DatePickerPageState extends State<DatePickerPage> {
  bool isSingleDateMode = true;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(720, 1024),
        minTextAdapt: true,
        splitScreenMode: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DatePicker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: 0.4.sw,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Text(isSingleDateMode == true
                          ? 'Single Mode'
                          : 'Range Mode')),
                  const SizedBox(width: 4),
                  Switch(
                    value: isSingleDateMode,
                    onChanged: (value) {
                      setState(() {
                        isSingleDateMode = value;
                      });
                    },
                  ),
                ],
              )),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomDatePickerWidget(
                      initialSingleMode: isSingleDateMode,
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
                      selectedDayTextStyle: const TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.bold),
                      weekdayLabelTextStyle: Font.apply(
                          FontStyle.regular, FontSize.h2,
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
                        'Sun',
                        'Mon',
                        'Tue',
                        'Wed',
                        'Thu',
                        'Fri',
                        'Sat'
                      ],
                      titleDayMode: 'Pick a Day',
                      titleMonthMode: 'Pick a Month',
                      titleYearMode: 'Pick a Year',
                      titleRangeMode: 'Pick a Date Range',
                      onCancel: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Selection cancelled')),
                        );
                      },
                      onSave: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Selection applied')),
                        );
                      },
                      onRefresh: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reset to today')),
                        );
                      },
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
