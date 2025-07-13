part of '../date_picker_widget.dart';

T? _ambiguate<T>(T? value) => value;

class _CalendarView extends StatefulWidget {
  /// Creates a month picker.
  const _CalendarView({
    required this.config,
    required this.initialMonth,
    required this.selectedDates,
    required this.onChanged,
    required this.onDisplayedMonthChanged,
    Key? key,
  }) : super(key: key);

  /// The calendar configurations
  final DatePickerWidgetConfig config;

  /// The initial month to display.
  final DateTime initialMonth;

  /// The currently selected dates.
  ///
  /// Selected dates are highlighted in the picker.
  final List<DateTime?> selectedDates;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// Called when the user navigates to a new month.
  final ValueChanged<DateTime> onDisplayedMonthChanged;

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<_CalendarView> {
  final GlobalKey _pageViewKey = GlobalKey();
  late DateTime _currentMonth;
  late PageController _pageController;
  late MaterialLocalizations _localizations;
  late TextDirection _textDirection;
  Map<ShortcutActivator, Intent>? _shortcutMap;
  Map<Type, Action<Intent>>? _actionMap;
  late FocusNode _dayGridFocus;
  DateTime? _focusedDay;

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.initialMonth;
    _pageController = widget.config.dayViewController ??
        PageController(
            initialPage:
                DateUtils.monthDelta(widget.config.firstDate, _currentMonth));
    _shortcutMap = const <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.arrowLeft):
          DirectionalFocusIntent(TraversalDirection.left),
      SingleActivator(LogicalKeyboardKey.arrowRight):
          DirectionalFocusIntent(TraversalDirection.right),
      SingleActivator(LogicalKeyboardKey.arrowDown):
          DirectionalFocusIntent(TraversalDirection.down),
      SingleActivator(LogicalKeyboardKey.arrowUp):
          DirectionalFocusIntent(TraversalDirection.up),
    };
    _actionMap = <Type, Action<Intent>>{
      NextFocusIntent:
          CallbackAction<NextFocusIntent>(onInvoke: _handleGridNextFocus),
      PreviousFocusIntent: CallbackAction<PreviousFocusIntent>(
          onInvoke: _handleGridPreviousFocus),
      DirectionalFocusIntent: CallbackAction<DirectionalFocusIntent>(
          onInvoke: _handleDirectionFocus),
    };
    _dayGridFocus = FocusNode(debugLabel: 'Day Grid');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = MaterialLocalizations.of(context);
    _textDirection = Directionality.of(context);
  }

  @override
  void didUpdateWidget(_CalendarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialMonth != oldWidget.initialMonth &&
        widget.initialMonth != _currentMonth) {
      _ambiguate(WidgetsBinding.instance)!.addPostFrameCallback(
        (Duration timeStamp) => _showMonth(widget.initialMonth,
            jump: widget.config.animateToDisplayedMonthDate != true),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dayGridFocus.dispose();
    super.dispose();
  }

  void _handleDateSelected(DateTime selectedDate) {
    _focusedDay = selectedDate;
    widget.onChanged(selectedDate);
  }

  void _handleMonthPageChanged(int monthPage) {
    setState(() {
      final DateTime monthDate =
          DateUtils.addMonthsToMonthDate(widget.config.firstDate, monthPage);
      if (!DateUtils.isSameMonth(_currentMonth, monthDate)) {
        _currentMonth = DateTime(monthDate.year, monthDate.month);
        widget.onDisplayedMonthChanged(_currentMonth);
        if (_focusedDay != null &&
            !DateUtils.isSameMonth(_focusedDay, _currentMonth)) {
          // We have navigated to a new month with the grid focused, but the
          // focused day is not in this month. Choose a new one trying to keep
          // the same day of the month.
          _focusedDay = _focusableDayForMonth(_currentMonth, _focusedDay!.day);
        }
        SemanticsService.announce(
          _localizations.formatMonthYear(_currentMonth),
          _textDirection,
        );
      }
    });
  }

  /// Returns a focusable date for the given month.
  ///
  /// If the preferredDay is available in the month it will be returned,
  /// otherwise the first selectable day in the month will be returned. If
  /// no dates are selectable in the month, then it will return null.
  DateTime? _focusableDayForMonth(DateTime month, int preferredDay) {
    final int daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);

    // Can we use the preferred day in this month?
    if (preferredDay <= daysInMonth) {
      final DateTime newFocus = DateTime(month.year, month.month, preferredDay);
      if (_isSelectable(newFocus)) return newFocus;
    }

    // Start at the 1st and take the first selectable date.
    for (int day = 1; day <= daysInMonth; day++) {
      final DateTime newFocus = DateTime(month.year, month.month, day);
      if (_isSelectable(newFocus)) return newFocus;
    }
    return null;
  }

  /// Navigate to the given month.
  void _showMonth(DateTime month, {bool jump = false}) {
    final int monthPage = DateUtils.monthDelta(widget.config.firstDate, month);
    if (jump) {
      _pageController.jumpToPage(monthPage);
    } else {
      _pageController.animateToPage(
        monthPage,
        duration: _monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  /// True if the earliest allowable month is displayed.
  bool get _isDisplayingFirstMonth {
    return !_currentMonth.isAfter(
      DateTime(widget.config.firstDate.year, widget.config.firstDate.month),
    );
  }

  /// True if the latest allowable month is displayed.
  bool get _isDisplayingLastMonth {
    return !_currentMonth.isBefore(
      DateTime(widget.config.lastDate.year, widget.config.lastDate.month),
    );
  }

  /// Handler for when the overall day grid obtains or loses focus.
  void _handleGridFocusChange(bool focused) {
    setState(() {
      if (focused && _focusedDay == null && widget.selectedDates.isNotEmpty) {
        if (DateUtils.isSameMonth(widget.selectedDates[0], _currentMonth)) {
          _focusedDay = widget.selectedDates[0];
        } else if (DateUtils.isSameMonth(
            widget.config.currentDate, _currentMonth)) {
          _focusedDay = _focusableDayForMonth(
              _currentMonth, widget.config.currentDate.day);
        } else {
          _focusedDay = _focusableDayForMonth(_currentMonth, 1);
        }
      }
    });
  }

  /// Move focus to the next element after the day grid.
  void _handleGridNextFocus(NextFocusIntent intent) {
    _dayGridFocus.requestFocus();
    _dayGridFocus.nextFocus();
  }

  /// Move focus to the previous element before the day grid.
  void _handleGridPreviousFocus(PreviousFocusIntent intent) {
    _dayGridFocus.requestFocus();
    _dayGridFocus.previousFocus();
  }

  /// Move the internal focus date in the direction of the given intent.
  ///
  /// This will attempt to move the focused day to the next selectable day in
  /// the given direction. If the new date is not in the current month, then
  /// the page view will be scrolled to show the new date's month.
  ///
  /// For horizontal directions, it will move forward or backward a day (depending
  /// on the current [TextDirection]). For vertical directions it will move up and
  /// down a week at a time.
  void _handleDirectionFocus(DirectionalFocusIntent intent) {
    setState(() {
      if (_focusedDay != null) {
        final nextDate = _nextDateInDirection(_focusedDay!, intent.direction);
        if (nextDate != null) {
          _focusedDay = nextDate;
          if (!DateUtils.isSameMonth(_focusedDay, _currentMonth)) {
            _showMonth(_focusedDay!);
          }
        }
      } else {
        _focusedDay ??= widget.initialMonth;
      }
    });
  }

  static const Map<TraversalDirection, int> _directionOffset =
      <TraversalDirection, int>{
    TraversalDirection.up: -DateTime.daysPerWeek,
    TraversalDirection.right: 1,
    TraversalDirection.down: DateTime.daysPerWeek,
    TraversalDirection.left: -1,
  };

  int _dayDirectionOffset(
      TraversalDirection traversalDirection, TextDirection textDirection) {
    // Swap left and right if the text direction if RTL
    if (textDirection == TextDirection.rtl) {
      if (traversalDirection == TraversalDirection.left) {
        traversalDirection = TraversalDirection.right;
      } else if (traversalDirection == TraversalDirection.right) {
        traversalDirection = TraversalDirection.left;
      }
    }
    return _directionOffset[traversalDirection]!;
  }

  DateTime? _nextDateInDirection(DateTime date, TraversalDirection direction) {
    final TextDirection textDirection = Directionality.of(context);
    DateTime nextDate = DateUtils.addDaysToDate(
        date, _dayDirectionOffset(direction, textDirection));
    while (!nextDate.isBefore(widget.config.firstDate) &&
        !nextDate.isAfter(widget.config.lastDate)) {
      if (_isSelectable(nextDate)) {
        return nextDate;
      }
      nextDate = DateUtils.addDaysToDate(
          nextDate, _dayDirectionOffset(direction, textDirection));
    }
    return null;
  }

  bool _isSelectable(DateTime date) {
    return widget.config.selectableDayPredicate?.call(date) ?? true;
  }

  List<Widget> _dayHeaders(
      TextStyle? headerStyle, MaterialLocalizations localizations) {
    final List<Widget> result = <Widget>[];
    final weekdays =
        widget.config.weekdayLabels ?? localizations.narrowWeekdays;
    final firstDayOfWeek =
        widget.config.firstDayOfWeek ?? localizations.firstDayOfWeekIndex;
    assert(firstDayOfWeek >= 0 && firstDayOfWeek <= 6,
        'firstDayOfWeek must between 0 and 6');
    for (int i = firstDayOfWeek; true; i = (i + 1) % 7) {
      final String weekday = weekdays[i];
      result.add(ExcludeSemantics(
        child: widget.config.weekdayLabelBuilder?.call(weekday: i) ??
            Center(
              child: Text(weekday,
                  style: Font.apply(FontStyle.regular, FontSize.h6,
                      color: const Color(0xFF5C5E66))),
            ),
      ));
      if (i == (firstDayOfWeek - 1) % 7) break;
    }
    return result;
  }

  Widget _buildItems(BuildContext context, int index) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle? headerStyle = textTheme.bodySmall?.apply(
      color: colorScheme.onSurface.withValues(alpha: 0.60),
    );
    final List<Widget> dayItems = _dayHeaders(headerStyle, localizations);
    final DateTime month =
        DateUtils.addMonthsToMonthDate(widget.config.firstDate, index);

    final nextMonth = DateUtils.addMonthsToMonthDate(month, 1);
    final shouldShowNextMonth = nextMonth.isBefore(widget.config.lastDate) ||
        DateUtils.isSameMonth(nextMonth, widget.config.lastDate);

    // Calculate dynamic heights based on row count
    final firstMonthRows = widget.config.dynamicCalendarRows == true
        ? getDayRowsCount(
            month.year,
            month.month,
            widget.config.firstDayOfWeek ?? _localizations.firstDayOfWeekIndex,
          )
        : _maxDayPickerRowCount;

    final secondMonthRows = widget.config.dynamicCalendarRows == true
        ? getDayRowsCount(
            nextMonth.year,
            nextMonth.month,
            widget.config.firstDayOfWeek ?? _localizations.firstDayOfWeekIndex,
          )
        : _maxDayPickerRowCount;

    // Calculate heights (assuming ~50px per row)
    final firstMonthHeight = (firstMonthRows * 60.0); // +20 for padding
    final secondMonthHeight = (secondMonthRows * 60.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Fixed Day Headers (Non-scrollable)
        SizedBox(
          height: 50,
          child: Expanded(
            child: GridView.custom(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: _DayPickerGridDelegate(
                config: widget.config,
                dayRowsCount: 1,
              ),
              childrenDelegate: SliverChildListDelegate(
                dayItems,
                addRepaintBoundaries: false,
              ),
            ),
          ),
        ),

        // Scrollable Calendar Section with dynamic heights
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 0,
              children: [
                // First month title
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, top: 8.0, bottom: 8.0),
                  child: Text(
                    "${getMonthAbbreviation(month.month)} ${month.year.toString()}",
                    style: Font.apply(FontStyle.bold, FontSize.h6),
                  ),
                ),

                // First month calendar with dynamic height
                SizedBox(
                  height: firstMonthHeight,
                  child: _DayPicker(
                    key: ValueKey<DateTime>(month),
                    selectedDates:
                        widget.selectedDates.whereType<DateTime>().toList(),
                    onChanged: _handleDateSelected,
                    config: widget.config,
                    displayedMonth: month,
                    dayRowsCount: firstMonthRows,
                  ),
                ),

                // Second month section (only if should show)
                if (shouldShowNextMonth) ...[
                  // Second month title
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 16.0, bottom: 8.0),
                    child: Text(
                      "${getMonthAbbreviation(nextMonth.month)} ${nextMonth.year.toString()}",
                      style: Font.apply(FontStyle.bold, FontSize.h6),
                    ),
                  ),

                  // Second month calendar with dynamic height
                  SizedBox(
                    height: secondMonthHeight,
                    child: _DayPicker(
                      key: ValueKey<DateTime>(nextMonth),
                      selectedDates: [],
                      onChanged: _handleDateSelected,
                      config: widget.config,
                      displayedMonth: nextMonth,
                      dayRowsCount: secondMonthRows,
                    ),
                  ),
                ],

                // Bottom padding for better UX
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: Column(
        children: <Widget>[
          Expanded(
            child: FocusableActionDetector(
              shortcuts: _shortcutMap,
              actions: _actionMap,
              focusNode: _dayGridFocus,
              onFocusChange: _handleGridFocusChange,
              child: _FocusedDate(
                date: _dayGridFocus.hasFocus ? _focusedDay : null,
                child: PageView.builder(
                  key: _pageViewKey,
                  physics: widget.config.calendarViewScrollPhysics,
                  controller: _pageController,
                  itemBuilder: _buildItems,
                  itemCount: DateUtils.monthDelta(
                          widget.config.firstDate, widget.config.lastDate) +
                      1,
                  onPageChanged: _handleMonthPageChanged,
                  scrollDirection:
                      widget.config.dayModeScrollDirection ?? Axis.horizontal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
