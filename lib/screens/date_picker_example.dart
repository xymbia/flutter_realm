import 'package:flutter/material.dart';
import 'package:flutter_realm/presentation/theme/app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/date_picker_widget_config.dart';
import '../utils/date_util.dart';
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

  final config = DatePickerWidgetConfig(
    calendarViewMode: DatePickerWidgetMode.day,
    hideMonthPickerDividers: true,
    hideScrollViewMonthWeekHeader: true,
    hideScrollViewTopHeader: true,
    selectedDayHighlightColor: Colors.grey,
    selectedDayTextStyle: const TextStyle(
      color: Colors.black54,
      fontWeight: FontWeight.normal,
    ),
    weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    weekdayLabelTextStyle: const TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold,
    ),
    firstDayOfWeek: 0, // 0 = Sunday, 1 = Monday, etc.
    controlsHeight: 50,
    dayMaxWidth: 25,
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
    centerAlignModePicker: false,
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
            .difference(DateTime.now().add(const Duration(days: 3)))
            .isNegative &&
        day.isBefore(DateTime.now().add(const Duration(days: 30))),
  );

  String selectedMonth = "March";
  int selectedYear = 2025;

  // List of months
  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  // List of years (can be customized)
  final List<int> years = List.generate(10, (index) => 2025 - index);

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
          child: SingleChildScrollView(
            child: _buildSingleDatePickerWithValue(),
          ),
        ));
  }

  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now().add(const Duration(days: 1)),
  ];

  Widget _buildSingleDatePickerWithValue() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header section
          const Text("Select Date",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Month Dropdown
                  DropdownButton<String>(
                    value: selectedMonth,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMonth = newValue!;
                      });
                    },
                    items: months.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    icon: const Icon(Icons.arrow_drop_down),
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 1,
                      color: Colors.black12,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Year Dropdown
                  DropdownButton<int>(
                    value: selectedYear,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedYear = newValue!;
                      });
                    },
                    items: years.map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    icon: Icon(Icons.arrow_drop_down),
                    style: TextStyle(color: Colors.black),
                    underline: Container(
                      height: 1,
                      color: Colors.black12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),

          // Body section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DatePickerWidget(
              displayedMonthDate: _singleDatePickerValueWithDefaultValue.first,
              config: config,
              value: _singleDatePickerValueWithDefaultValue,
              onValueChanged: (dates) => setState(
                  () => _singleDatePickerValueWithDefaultValue = dates),
            ),
          ),
          Divider(height: 1),

          // Footer section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
