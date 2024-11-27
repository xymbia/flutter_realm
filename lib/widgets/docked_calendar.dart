import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter_realm/presentation/theme/app_typography.dart';
import 'package:flutter_realm/presentation/theme/space.dart';

showDockedDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  required void Function(DateTime) onChanged,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: DockedCalendarContent(
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
          onChanged: onChanged,
        ),
      );
    },
  );
}

class DockedCalendarContent extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(DateTime) onChanged;

  const DockedCalendarContent(
      {super.key,
      required this.initialDate,
      this.firstDate,
      this.lastDate,
      required this.onChanged});

  @override
  State<DockedCalendarContent> createState() => _DockedCalendarContentState();
}

class _DockedCalendarContentState extends State<DockedCalendarContent> {
  late DateTime? _selectedDate;
  late DateTime viewDate;
  late DateTime _firstDate;
  late DateTime _lastDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _firstDate = widget.firstDate ?? DateTime(now.year - 50);
    _lastDate = widget.lastDate ?? DateTime(now.year + 100);
    if (_firstDate.isAfter(_lastDate)) {
      throw Exception('Invalid range');
    }
    if (widget.initialDate != null &&
        widget.initialDate!.isAfter(_firstDate) &&
        widget.initialDate!.isBefore(_lastDate)) {
      viewDate = widget.initialDate!;
    } else {
      viewDate = _firstDate;
    }
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(8.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Space.y,
          Text(
              _selectedDate != null
                  ? DateFormat('EEE, MMM d').format(_selectedDate!)
                  : 'Select Date',
              style: AppText.headlineMedium
                  .copyWith(color: colorScheme.onSurface)),
          Space.y,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              MonthSelector(
                selectedYear: viewDate.year,
                selectedMonth: viewDate.month,
                firstDate: _firstDate,
                lastDate: _lastDate,
                onChanged: (month) {
                  setState(() {
                    viewDate = DateTime(viewDate.year, month, viewDate.day);
                  });
                },
                onYearChanged: ({required bool incrementYear}) {
                  setState(() {
                    int newYear = viewDate.year + (incrementYear ? 1 : -1);
                    viewDate = DateTime(newYear, viewDate.month, viewDate.day);
                  });
                },
              ),
              YearSelector(
                selectedYear: viewDate.year,
                firstDate: _firstDate,
                lastDate: _lastDate,
                onChanged: (year) {
                  setState(() {
                    viewDate = DateTime(year, viewDate.month, viewDate.day);
                  });
                },
              ),
            ],
          ),
          MonthScroller(
            viewDate: viewDate,
            selectedDate: _selectedDate,
            firstDate: _firstDate,
            lastDate: _lastDate,
            onChanged: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
            onViewChanged: (date) {
              setState(() {
                viewDate = date;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _selectedDate != null
                      ? widget.onChanged(_selectedDate!)
                      : null;
                },
                child: const Text('Ok'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class MonthScroller extends StatefulWidget {
  const MonthScroller({
    super.key,
    required this.selectedDate,
    required this.viewDate,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
    required this.onViewChanged,
  });
  final DateTime? selectedDate;
  final DateTime viewDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final void Function(DateTime) onChanged;
  final void Function(DateTime) onViewChanged;

  @override
  State<MonthScroller> createState() => _MonthScrollerState();
}

class _MonthScrollerState extends State<MonthScroller> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    const List<double> pages = [0.0, 1.0, 2.0, 4.0, 5.0, 6.0];
    const int center = 3;
    _pageController = PageController(
      initialPage: center,
    );
    _pageController.addListener(() {
      double currentPage = _pageController.page ?? center.toDouble();
      if (pages.contains(currentPage)) {
        bool isFirstMonth = ((widget.viewDate.year == widget.firstDate.year &&
            widget.viewDate.month == 1));
        bool isLastMonth = ((widget.viewDate.year == widget.lastDate.year &&
            widget.viewDate.month == 12));
        if (!((isLastMonth && center < currentPage) ||
            (isFirstMonth && center > currentPage))) {
          widget.onViewChanged(DateTime(widget.viewDate.year,
              (widget.viewDate.month + (currentPage - center).toInt()), 1));
        }
        _pageController.jumpToPage(center);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400.h,
      child: PageView(
          controller: _pageController,
          physics:
              const PageScrollPhysics().applyTo(const ClampingScrollPhysics()),
          children: [-3, -2, -1, 0, 1, 2, 3]
              .map(
                (month) => MonthView(
                  monthDate: DateTime(
                      widget.viewDate.year, (widget.viewDate.month + month), 1),
                  selectedDate: widget.selectedDate,
                  onChanged: widget.onChanged,
                  firstDate: widget.firstDate,
                  lastDate: widget.lastDate,
                ),
              )
              .toList()),
    );
  }
}

class MonthView extends StatelessWidget {
  final DateTime monthDate;
  final DateTime? selectedDate;
  final void Function(DateTime) onChanged;
  final DateTime firstDate;
  final DateTime lastDate;

  const MonthView({super.key, 
    required this.monthDate,
    required this.selectedDate,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
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
        const Header(),
        Space.yf(12),
        ...List.generate(
            getNumberOfWeeksInMonth(monthDate.year, monthDate.month), (index) {
          return WeekView(
            weekStartDate: firstDateOfMonth.add(Duration(days: 7 * index)),
            currentMonth: monthDate.month,
            selectedDate: selectedDate,
            onChanged: onChanged,
            firstDate: firstDate,
            lastDate: lastDate,
          );
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
    this.selectedDate,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTime weekStartDate;
  final int currentMonth;
  final DateTime? selectedDate;
  final void Function(DateTime) onChanged;
  final DateTime firstDate;
  final DateTime lastDate;

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
          selectedDate: selectedDate,
          colorScheme: colorScheme,
          onTap: onChanged,
          firstDate: firstDate,
          lastDate: lastDate,
        );
      }),
    );
  }
}

bool isSameDate(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

Widget _dateCell({
  DateTime? date,
  DateTime? selectedDate,
  required ColorScheme colorScheme,
  required void Function(DateTime) onTap,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  bool isToday = date == null ? false : isSameDate(date, DateTime.now());
  bool isSelected = (selectedDate != null && date != null)
      ? isSameDate(date, selectedDate)
      : false;
  return Column(
    children: [
      Space.y,
      _dateText(
        date: date,
        isToday: isToday,
        isSelected: isSelected,
        colorScheme: colorScheme,
        onTap: onTap,
        firstDate: firstDate,
        lastDate: lastDate,
      ),
    ],
  );
}

Widget _dateText({
  DateTime? date,
  required bool isToday,
  required bool isSelected,
  required ColorScheme colorScheme,
  required void Function(DateTime) onTap,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  bool isOutOfRange =
      date != null && (date.isBefore(firstDate) || date.isAfter(lastDate));
  return GestureDetector(
    onTap: isOutOfRange
        ? null
        : () {
            if (date != null) onTap(date);
          },
    child: Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (isSelected ? colorScheme.primary : Colors.transparent),
        border: Border.all(
          color: isToday ? colorScheme.primary : Colors.transparent,
          style: BorderStyle.solid,
        ),
      ),
      child: SizedBox(
        width: 25.w,
        child: Center(
          child: Opacity(
            opacity: isOutOfRange ? 0.5 : 1,
            child: Text(
              (date == null ? '' : DateFormat('d').format(date)),
              style: AppText.bodyLarge.copyWith(
                  color: isSelected
                      ? colorScheme.onPrimary
                      : isToday
                          ? colorScheme.primary
                          : colorScheme.onSurface),
            ),
          ),
        ),
      ),
    ),
  );
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((e) {
        return Column(
          children: [
            Space.y,
            Container(
              padding: EdgeInsets.all(4.w),
              child: SizedBox(
                width: 25.w,
                child: Center(
                  child: Text(
                    e,
                    style: AppText.bodyLarge.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      }).toList(),
    );
  }
}

class YearSelector extends StatelessWidget {
  final int selectedYear;
  final DateTime firstDate;
  final DateTime lastDate;
  final void Function(int) onChanged;

  const YearSelector({super.key, 
    required this.selectedYear,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final List<int> years = List<int>.generate(
        lastDate.year - firstDate.year + 1,
        (index) => DateTime(firstDate.year + index).year);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: selectedYear == firstDate.year
              ? null
              : () {
                  onChanged(selectedYear - 1);
                },
        ),
        DropdownButton<int>(
          underline: const SizedBox.shrink(),
          menuMaxHeight: 400.h,
          isDense: true,
          value: selectedYear,
          items: years.map((int year) {
            return DropdownMenuItem<int>(
              value: year,
              child: Text(
                year.toString(),
                style: AppText.labelLargeSemiBold
                    .copyWith(color: colorScheme.onSurfaceVariant),
              ),
            );
          }).toList(),
          onChanged: (int? newValue) {
            onChanged(newValue!);
          },
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: selectedYear == lastDate.year
              ? null
              : () {
                  onChanged(selectedYear + 1);
                },
        ),
      ],
    );
  }
}

class MonthSelector extends StatelessWidget {
  final int selectedMonth;
  final int selectedYear;
  final DateTime firstDate;
  final DateTime lastDate;
  final void Function(int) onChanged;
  final void Function({required bool incrementYear}) onYearChanged;

  MonthSelector({super.key, 
    required this.selectedMonth,
    required this.selectedYear,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
    required this.onYearChanged,
  });

  final List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: (selectedYear == firstDate.year && selectedMonth == 1)
              ? null
              : () {
                  int temp = (selectedMonth - 1) % 12;
                  if (temp == 0) {
                    onYearChanged(incrementYear: false);
                    temp = 12;
                  }
                  onChanged(temp);
                },
        ),
        DropdownButton<int>(
          underline: const SizedBox.shrink(),
          menuMaxHeight: 400.h,
          isDense: true,
          value: selectedMonth,
          items: List.generate(12, (index) {
            return DropdownMenuItem<int>(
              value: index + 1,
              child: Text(
                months[index],
                style: AppText.labelLargeSemiBold
                    .copyWith(color: colorScheme.onSurfaceVariant),
              ),
            );
          }).toList(),
          onChanged: (int? newValue) {
            onChanged(newValue!);
          },
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: (selectedYear == lastDate.year && selectedMonth == 12)
              ? null
              : () {
                  if (selectedMonth == 12) {
                    onYearChanged(incrementYear: true);
                  }
                  onChanged((selectedMonth % 12) + 1);
                },
        ),
      ],
    );
  }
}
