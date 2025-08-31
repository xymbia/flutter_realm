import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/date_util.dart';
import '../utils/font_helper.dart';
import '../widgets/custom_date_picker_widget.dart';

class DatePickerPage extends StatefulWidget {
  const DatePickerPage({Key? key}) : super(key: key);

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
                  // Whether the picker is in single date mode (true) or range mode (false)
                  // Possible values: true (single date), false (range)
                  initialSingleMode: isSingleDateMode,
                  // default: true

                  // The initially selected date in single mode
                  // If null, defaults to DateTime.now()
                  initialSelectedDate:
                      DateTime.now().add(const Duration(days: 1)),

                  // The initially selected date range in range mode
                  // Provide a list with up to two DateTime objects [start, end]
                  initialSelectedRange: [
                    DateTime.now().add(const Duration(days: 1)),
                    DateTime.now().add(const Duration(days: 15)),
                  ],

                  // The earliest selectable date
                  // If null, defaults to (DateTime.now().year - 2, DateTime.now().month - 1, DateTime.now().day - 5)
                  firstDate: DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day),

                  // The latest selectable date
                  // If null, defaults to (DateTime.now().year + 3, DateTime.now().month + 2, DateTime.now().day + 10)
                  lastDate: DateTime(DateTime.now().year + 50,
                      DateTime.now().month + 6, DateTime.now().day),

                  // The color used to highlight the selected day
                  // If null, defaults to grey (single) or teal[800] (range)
                  selectedDayHighlightColor: Colors.black87,

                  // The text style for the selected day
                  // If null, defaults to white, normal weight
                  selectedDayTextStyle: const TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold),

                  // The text style for weekday labels (e.g., Sun, Mon)
                  // If null, defaults to black87, bold
                  weekdayLabelTextStyle: Font.apply(
                      FontStyle.regular, FontSize.h2,
                      color: Colors.black87),

                  // The border radius for day cells
                  // If null, defaults to BorderRadius.circular(8)
                  dayBorderRadius: BorderRadius.circular(18),

                  // The maximum width for day cells
                  // If null, defaults to 50
                  dayMaxWidth: 55,

                  // The height for controls (e.g., header)
                  // If null, defaults to 50
                  controlsHeight: 55,

                  // Callback when a single date is selected (single mode)
                  onSingleDateSelected: (date) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          duration: const Duration(milliseconds: 2500),
                          content: Text('Selected: \t	${formatDate(date)}')),
                    );
                  },

                  // Callback when a date range is selected (range mode)
                  onRangeSelected: (start, end) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          duration: const Duration(milliseconds: 2500),
                          content:
                              Text('Range: 	${formatDateRange([start, end])}')),
                    );
                  },

                  // Allows days to be selected based on following predicate
                  selectableDayPredicate: (day) {
                    return !day
                        .difference(
                            DateTime.now().add(const Duration(days: -1)))
                        .isNegative;
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
