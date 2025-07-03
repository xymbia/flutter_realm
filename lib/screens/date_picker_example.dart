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

  @override
  Widget build(BuildContext context) {
    DateTime? selectedDate;
    App.init(context);
    ScreenUtil.init(context, designSize: const Size(390, 848));

    return Scaffold(
        appBar: AppBar(
          title: const Text('DatePicker'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            children: [
              _buildSingleDatePickerWithValue(),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Save action
                      if (selectedDate != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Saved: $selectedDate')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedDate != null ? Colors.grey[800] : Colors.grey[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Save'),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ));
  }

  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now().add(const Duration(days: 1)),
  ];

  Widget _buildSingleDatePickerWithValue() {
    final config = DatePickerWidgetConfig(
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
              .difference(DateTime.now().add(const Duration(days: 3)))
              .isNegative &&
          day.isBefore(DateTime.now().add(const Duration(days: 30))),
    );
    return SizedBox(
      child: DatePickerWidget(
        displayedMonthDate: _singleDatePickerValueWithDefaultValue.first,
        config: config,
        value: _singleDatePickerValueWithDefaultValue,
        onValueChanged: (dates) =>
            setState(() => _singleDatePickerValueWithDefaultValue = dates),
      ),
    );
  }
}
