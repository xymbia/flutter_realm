import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/date_picker_widget_config.dart';
import '../utils/date_util.dart';
import '../utils/font_helper.dart';

part '../widgets/date_picker_impl/_calendar_scroll_view.dart';

part '../widgets/date_picker_impl/_calendar_view.dart';

part '../widgets/date_picker_impl/_date_picker_mode_toggle_button.dart';

part '../widgets/date_picker_impl/_day_picker.dart';

part '../widgets/date_picker_impl/_focus_date.dart';

part '../widgets/date_picker_impl/_month_picker.dart';

part '../widgets/date_picker_impl/year_picker.dart';

const Duration _monthScrollDuration = Duration(milliseconds: 200);

const double _dayPickerRowHeight = 40.0;
const int _maxDayPickerRowCount = 5; // A 31 day month that starts on Saturday.
const double _monthPickerHorizontalPadding = 0.0;

const int _yearPickerColumnCount = 4;
const double _yearPickerPadding = 0.0;
const double _yearPickerRowHeight = 85.0;
const double _yearPickerRowSpacing = 0.0;

const int _monthPickerColumnCount = 4;
const double _monthPickerPadding = 0.0;
const double _monthPickerRowHeight = 85.0;
const double _monthPickerRowSpacing = 0.0;

const double _subHeaderHeight = 0.0;
const double _monthNavButtonsWidth = 0.0;

class DatePickerWidget extends StatefulWidget {
  DatePickerWidget({
    required this.config,
    required this.value,
    this.onValueChanged,
    this.displayedMonthDate,
    this.onDisplayedMonthChanged,
    this.onMonthSelected,
    this.onYearSelected,
    Key? key,
  }) : super(key: key) {
    const valid = true;
    const invalid = false;

    if (config.calendarType == DatePickerWidgetType.single) {
      assert(value.length < 2,
          'Error: single date picker only allows maximum one initial date');
    }

    if (config.calendarType == DatePickerWidgetType.range && value.length > 1) {
      final isRangePickerValueValid = value[0] == null
          ? (value[1] != null ? invalid : valid)
          : (value[1] != null
              ? (value[1]!.isBefore(value[0]!) ? invalid : valid)
              : valid);

      assert(
        isRangePickerValueValid,
        'Error: range date picker must have start date set before setting end date, and start date must be before end date.',
      );
    }
  }

  /// The calendar UI related configurations
  final DatePickerWidgetConfig config;

  /// The selected [DateTime]s that the picker should display.
  final List<DateTime?> value;

  /// Called when the selected dates changed
  final ValueChanged<List<DateTime>>? onValueChanged;

  /// Date to control calendar displayed month
  final DateTime? displayedMonthDate;

  /// Called when the displayed month changed
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  /// Called when a month is selected from the month picker
  final ValueChanged<DateTime>? onMonthSelected;

  /// Called when a year is selected from the year picker
  final ValueChanged<DateTime>? onYearSelected;

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  bool _announcedInitialDate = false;
  late List<DateTime?> _selectedDates;
  late DatePickerWidgetMode _mode;
  late DateTime _currentDisplayedMonthDate;
  final GlobalKey _dayPickerKey = GlobalKey();
  final GlobalKey _monthPickerKey = GlobalKey();
  final GlobalKey _yearPickerKey = GlobalKey();
  late MaterialLocalizations _localizations;
  late TextDirection _textDirection;

  @override
  void initState() {
    super.initState();
    final config = widget.config;
    final initialDate = widget.displayedMonthDate ??
        (widget.value.isNotEmpty && widget.value[0] != null
            ? DateTime(widget.value[0]!.year, widget.value[0]!.month)
            : DateUtils.dateOnly(DateTime.now()));
    _mode = config.calendarViewMode;
    _currentDisplayedMonthDate = DateTime(initialDate.year, initialDate.month);
    _selectedDates = widget.value.toList();
  }

  @override
  void didUpdateWidget(DatePickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config.calendarViewMode != oldWidget.config.calendarViewMode) {
      _mode = widget.config.calendarViewMode;
    }

    if (widget.displayedMonthDate != null) {
      _currentDisplayedMonthDate = DateTime(
        widget.displayedMonthDate!.year,
        widget.displayedMonthDate!.month,
      );
    }

    _selectedDates = widget.value.toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasDirectionality(context));
    _localizations = MaterialLocalizations.of(context);
    _textDirection = Directionality.of(context);
    if (!_announcedInitialDate && _selectedDates.isNotEmpty) {
      _announcedInitialDate = true;
      for (final date in _selectedDates) {
        if (date != null) {
          SemanticsService.announce(
            _localizations.formatFullDate(date),
            _textDirection,
          );
        }
      }
    }
  }

  void _vibrate() {
    if (widget.config.disableVibration == true) return;

    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        HapticFeedback.vibrate();
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
    }
  }

  void _handleModeChanged(DatePickerWidgetMode mode) {
    _vibrate();
    setState(() {
      _mode = mode;
      if (_selectedDates.isNotEmpty) {
        for (final date in _selectedDates) {
          if (date != null) {
            SemanticsService.announce(
              _mode == DatePickerWidgetMode.day
                  ? _localizations.formatMonthYear(date)
                  : _mode == DatePickerWidgetMode.month
                      ? _localizations.formatMonthYear(date)
                      : _localizations.formatYear(date),
              _textDirection,
            );
          }
        }
      }
    });
  }

  void _handleDisplayedMonthDateChanged(
    DateTime date, {
    bool fromYearPicker = false,
  }) {
    _vibrate();
    setState(() {
      final currentDisplayedMonthDate = DateTime(
        _currentDisplayedMonthDate.year,
        _currentDisplayedMonthDate.month,
      );
      var newDisplayedMonthDate = currentDisplayedMonthDate;

      if (_currentDisplayedMonthDate.year != date.year ||
          _currentDisplayedMonthDate.month != date.month) {
        newDisplayedMonthDate = DateTime(date.year, date.month);
      }

      if (fromYearPicker) {
        final selectedDatesInThisYear = _selectedDates
            .where((d) => d?.year == date.year)
            .toList()
          ..sort((d1, d2) => d1!.compareTo(d2!));
        if (selectedDatesInThisYear.isNotEmpty) {
          newDisplayedMonthDate =
              DateTime(date.year, selectedDatesInThisYear[0]!.month);
        }
      }

      if (currentDisplayedMonthDate.year != newDisplayedMonthDate.year ||
          currentDisplayedMonthDate.month != newDisplayedMonthDate.month) {
        _currentDisplayedMonthDate = DateTime(
          newDisplayedMonthDate.year,
          newDisplayedMonthDate.month,
        );
        widget.onDisplayedMonthChanged?.call(_currentDisplayedMonthDate);
      }
    });
  }

  void _handleMonthChanged(DateTime value) {
    _vibrate();
    setState(() {
      _handleDisplayedMonthDateChanged(value);
    });
    // Notify parent about the selected month
    widget.onMonthSelected?.call(value);
  }

  void _handleYearChanged(DateTime value) {
    _vibrate();

    if (value.isBefore(widget.config.firstDate)) {
      value = widget.config.firstDate;
    } else if (value.isAfter(widget.config.lastDate)) {
      value = widget.config.lastDate;
    }

    setState(() {
      _handleDisplayedMonthDateChanged(value, fromYearPicker: true);
    });
    // Notify parent about the selected year
    widget.onYearSelected?.call(value);
  }

  void _handleDayChanged(DateTime value) {
    _vibrate();
    setState(() {
      var selectedDates = [..._selectedDates];
      selectedDates.removeWhere((d) => d == null);

      final calendarType = widget.config.calendarType;
      switch (calendarType) {
        case DatePickerWidgetType.single:
          selectedDates = [value];
          break;

        case DatePickerWidgetType.multi:
          final index =
              selectedDates.indexWhere((d) => DateUtils.isSameDay(d, value));
          if (index != -1) {
            selectedDates.removeAt(index);
          } else {
            selectedDates.add(value);
          }
          break;

        case DatePickerWidgetType.range:
          if (selectedDates.isEmpty) {
            selectedDates.add(value);
            break;
          }

          final isRangeSet =
              selectedDates.length > 1 && selectedDates[1] != null;
          final isSelectedDayBeforeStartDate =
              value.isBefore(selectedDates[0]!);

          if (isRangeSet) {
            selectedDates = [value, null];
          } else if (isSelectedDayBeforeStartDate &&
              widget.config.rangeBidirectional != true) {
            selectedDates = [value, null];
          } else {
            selectedDates = [selectedDates[0], value];
          }

          break;
      }

      selectedDates
        ..removeWhere((d) => d == null)
        ..sort((d1, d2) => d1!.compareTo(d2!));

      final isValueDifferent =
          widget.config.calendarType != DatePickerWidgetType.single ||
              !DateUtils.isSameDay(selectedDates[0],
                  _selectedDates.isNotEmpty ? _selectedDates[0] : null);
      if (isValueDifferent || widget.config.allowSameValueSelection == true) {
        _selectedDates = [...selectedDates];
        widget.onValueChanged
            ?.call(_selectedDates.whereType<DateTime>().toList());
      }
    });
  }

  Widget _buildPicker() {
    switch (_mode) {
      case DatePickerWidgetMode.day:
        // Calculate next month, ensuring it doesn't exceed lastDate
        final nextMonth =
            DateUtils.addMonthsToMonthDate(_currentDisplayedMonthDate, 1);
        final shouldShowNextMonth =
            nextMonth.isBefore(widget.config.lastDate) ||
                DateUtils.isSameMonth(nextMonth, widget.config.lastDate);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: _CalendarView(
              config: widget.config,
              key: _dayPickerKey,
              initialMonth: _currentDisplayedMonthDate,
              selectedDates: _selectedDates,
              onChanged: _handleDayChanged,
              onDisplayedMonthChanged: _handleDisplayedMonthDateChanged),
        );
      case DatePickerWidgetMode.month:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: _MonthPicker(
            config: widget.config,
            key: _monthPickerKey,
            initialMonth: _currentDisplayedMonthDate,
            selectedDates: _selectedDates,
            onChanged: _handleMonthChanged,
          ),
        );
      case DatePickerWidgetMode.year:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: YearPicker(
            config: widget.config,
            key: _yearPickerKey,
            initialMonth: _currentDisplayedMonthDate,
            selectedDates: _selectedDates,
            onChanged: _handleYearChanged,
          ),
        );
      case DatePickerWidgetMode.scroll:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: _CalendarScrollView(
            config: widget.config,
            key: _dayPickerKey,
            initialMonth: _currentDisplayedMonthDate,
            selectedDates: _selectedDates,
            onChanged: _handleDayChanged,
            onDisplayedMonthChanged: _handleDisplayedMonthDateChanged,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasDirectionality(context));

    // Calculate height based on mode
    double maxContentHeight;

    // For day mode, we show two months in a column, so double the height
    final dayRowsCount = widget.config.dynamicCalendarRows == true
        ? getDayRowsCount(
            _currentDisplayedMonthDate.year,
            _currentDisplayedMonthDate.month,
            widget.config.firstDayOfWeek ?? _localizations.firstDayOfWeekIndex,
          )
        : _maxDayPickerRowCount;
    final totalRowsCount = dayRowsCount + 1;
    final rowHeight = widget.config.dayMaxWidth != null
        ? (widget.config.dayMaxWidth! + 2)
        : _dayPickerRowHeight;
    final singleMonthHeight = rowHeight * totalRowsCount;

    // Calculate next month height as well
    final nextMonth =
        DateUtils.addMonthsToMonthDate(_currentDisplayedMonthDate, 1);
    final shouldShowNextMonth = nextMonth.isBefore(widget.config.lastDate) ||
        DateUtils.isSameMonth(nextMonth, widget.config.lastDate);

    if (shouldShowNextMonth) {
      final nextMonthDayRowsCount = widget.config.dynamicCalendarRows == true
          ? getDayRowsCount(
              nextMonth.year,
              nextMonth.month,
              widget.config.firstDayOfWeek ??
                  _localizations.firstDayOfWeekIndex,
            )
          : _maxDayPickerRowCount;
      final nextMonthTotalRowsCount = nextMonthDayRowsCount + 1;
      final nextMonthHeight = rowHeight * nextMonthTotalRowsCount;

      maxContentHeight = singleMonthHeight +
          16.0 +
          nextMonthHeight; // 16.0 is the SizedBox height
    } else {
      maxContentHeight = singleMonthHeight;
    }

    return widget.config.calendarViewMode == DatePickerWidgetMode.scroll
        ? _buildPicker()
        : Stack(
            children: <Widget>[
              SizedBox(
                height: (widget.config.controlsHeight ?? _subHeaderHeight) +
                    maxContentHeight,
                child: _buildPicker(),
              ),
              // Put the mode toggle button on top so that it won't be covered up by the _CalendarView
              _DatePickerModeToggleButton(
                config: widget.config,
                mode: _mode,
                monthDate: _currentDisplayedMonthDate,
                onMonthPressed: () {
                  if (_mode == DatePickerWidgetMode.year) {
                    _handleModeChanged(DatePickerWidgetMode.month);
                  } else {
                    _handleModeChanged(
                      _mode == DatePickerWidgetMode.month
                          ? DatePickerWidgetMode.day
                          : DatePickerWidgetMode.month,
                    );
                  }
                },
                onYearPressed: () {
                  if (_mode == DatePickerWidgetMode.month) {
                    _handleModeChanged(DatePickerWidgetMode.year);
                  } else {
                    _handleModeChanged(
                      _mode == DatePickerWidgetMode.year
                          ? DatePickerWidgetMode.day
                          : DatePickerWidgetMode.year,
                    );
                  }
                },
              ),
            ],
          );
  }
}
