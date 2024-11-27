import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter_realm/presentation/theme/app_typography.dart';
import 'package:flutter_realm/presentation/theme/space.dart';

showCalendarViewer(
    BuildContext context, DateTime yearDate, List<DateTime> selectedDates) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: CalendarView(
          yearDate: yearDate,
          selectedDates: selectedDates
              .map((date) => DateTime(date.year, date.month, date.day))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
        actionsPadding: EdgeInsets.only(bottom: 8.h, right: 16.w),
        contentPadding: EdgeInsets.all(8.w),
      );
    },
  );
}

class CalendarView extends StatefulWidget {
  final DateTime yearDate;
  final List<DateTime> selectedDates;

  const CalendarView({super.key, 
    required this.yearDate,
    required this.selectedDates,
  });

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late DateTime _currentYearDate;

  @override
  void initState() {
    super.initState();
    _currentYearDate = widget.yearDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            YearNavigator(
              yearDate: _currentYearDate,
              onChanged: (date) {
                setState(() {
                  _currentYearDate = date;
                });
              },
            ),
            const Header(),
            Space.y1
          ],
        ),
        Expanded(
          child: YearView(
            yearDate: _currentYearDate,
            selectedDates: widget.selectedDates,
          ),
        ),
      ],
    );
  }
}

class YearView extends StatelessWidget {
  final DateTime yearDate;
  final List<DateTime> selectedDates;

  const YearView({super.key, 
    required this.yearDate,
    required this.selectedDates,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(12, (index) {
            return MonthView(
                monthDate: DateTime(yearDate.year, index + 1, 1),
                selectedDates: selectedDates);
          }),
        ),
      ),
    );
  }
}

class MonthView extends StatelessWidget {
  final DateTime monthDate;
  final List<DateTime> selectedDates;

  const MonthView({super.key, 
    required this.monthDate,
    required this.selectedDates,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final firstDateOfMonth = DateTime(monthDate.year, monthDate.month, 1);

    int getWeekNumber(DateTime date) {
      int dayOfYear = int.parse(DateFormat("D").format(date));
      return ((dayOfYear - date.weekday + 10) / 7).floor();
    }

    int getNumberOfWeeksInMonth(int year, int month) {
      DateTime firstDayOfMonth = DateTime(year, month, 1);
      DateTime lastDayOfMonth = DateTime(year, month + 1, 0);

      int firstWeekNumber = getWeekNumber(firstDayOfMonth);
      int lastWeekNumber = getWeekNumber(lastDayOfMonth);

      return lastWeekNumber - firstWeekNumber + 1;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Space.yf(16),
        Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: Text(DateFormat('MMMM yyyy').format(firstDateOfMonth),
              style: AppText.titleSmallSemiBold
                  .copyWith(color: colorScheme.onSurface)),
        ),
        Space.yf(12),
        ...List.generate(
            getNumberOfWeeksInMonth(monthDate.year, monthDate.month), (index) {
          return WeekView(
              weekStartDate: firstDateOfMonth.add(Duration(days: 7 * index)),
              currentMonth: monthDate.month,
              selectedDates: selectedDates);
        })
      ],
    );
  }
}

class WeekView extends StatelessWidget {
  const WeekView({
    super.key,
    required this.weekStartDate,
    required this.currentMonth,
    required this.selectedDates,
  });

  final DateTime weekStartDate;
  final int currentMonth;
  final List<DateTime> selectedDates;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    DateTime startOfCurrentWeek =
        weekStartDate.subtract(Duration(days: weekStartDate.weekday - 1));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        DateTime? currentDate = startOfCurrentWeek.add(Duration(days: index));

        if (currentDate.month != currentMonth) {
          currentDate = null;
        }

        return _dateCell(
          date: currentDate,
          selectedDates: selectedDates,
          colorScheme: colorScheme,
        );
      }),
    );
  }
}

Widget _dateText({
  DateTime? date,
  required bool isToday,
  required bool isSelected,
  required ColorScheme colorScheme,
}) {
  Widget dateContent = Container(
    padding: EdgeInsets.all(4.w),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: (isToday ? colorScheme.primary : Colors.transparent),
    ),
    child: SizedBox(
      width: 25.w,
      child: Center(
        child: Text(
          (date == null ? '' : DateFormat('d').format(date)),
          style: AppText.bodyLarge.copyWith(
              color: isToday
                  ? colorScheme.onPrimary
                  : isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface),
        ),
      ),
    ),
  );
  return isSelected
      ? DottedBorder(
          color: colorScheme.primary,
          borderType: BorderType.Circle,
          dashPattern: const [3, 3],
          child: dateContent,
        )
      : dateContent;
}

Widget _dateCell(
    {DateTime? date,
    required List<DateTime> selectedDates,
    required ColorScheme colorScheme}) {
  bool isToday = date == null ? false : isSameDate(date, DateTime.now());
  bool isSelected = date == null
      ? false
      : selectedDates.contains(DateTime(date.year, date.month, date.day));
  return Column(
    children: [
      Space.y,
      _dateText(
          date: date,
          isToday: isToday,
          isSelected: isSelected,
          colorScheme: colorScheme),
    ],
  );
}

bool isSameDate(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

class YearNavigator extends StatelessWidget {
  final DateTime _selectedYearDate;
  final void Function(DateTime) onChanged;

  const YearNavigator(
      {super.key, required DateTime yearDate, required this.onChanged})
      : _selectedYearDate = yearDate;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton(
          onPressed: () {
            onChanged(DateTime(_selectedYearDate.year - 1));
          },
          child: const Icon(Icons.arrow_left),
        ),
        Text('${_selectedYearDate.year}',
            style: AppText.labelLargeSemiBold
                .copyWith(color: colorScheme.onSurfaceVariant)),
        TextButton(
          onPressed: () {
            onChanged(DateTime(_selectedYearDate.year + 1));
          },
          child: const Icon(Icons.arrow_right),
        ),
      ],
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((e) {
        return Column(
          children: [
            Space.y,
            Text(
              e,
              style: AppText.bodyLarge,
            ),
          ],
        );
      }).toList(),
    );
  }
}
