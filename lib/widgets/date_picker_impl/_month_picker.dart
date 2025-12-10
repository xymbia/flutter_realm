part of '../date_picker_widget.dart';

/// A scrollable grid of months to allow picking a month.
///
/// The month picker widget is rarely used directly. Instead, consider using [DatePickerWidget]
///
/// See also:
///
///  * [DatePickerWidget], which provides a Material Design date picker
///    interface.
///
///
class _MonthPicker extends StatefulWidget {
  /// Creates a month picker.
  const _MonthPicker({
    required this.config,
    required this.selectedDates,
    required this.onChanged,
    required this.initialMonth,
    Key? key,
  }) : super(key: key);

  /// The calendar configurations
  final DatePickerWidgetConfig config;

  /// The currently selected dates.
  ///
  /// Selected dates are highlighted in the picker.
  final List<DateTime?> selectedDates;

  /// Called when the user picks a month.
  final ValueChanged<DateTime> onChanged;

  /// The initial month to display.
  final DateTime initialMonth;

  @override
  State<_MonthPicker> createState() => _MonthPickerState();
}

class _MonthPickerState extends State<_MonthPicker> {
  late ScrollController _scrollController;
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    final scrollOffset =
        widget.selectedDates.isNotEmpty && widget.selectedDates[0] != null
            ? _scrollOffsetForMonth(widget.selectedDates[0]!)
            : _scrollOffsetForMonth(DateUtils.dateOnly(DateTime.now()));
    _scrollController = widget.config.monthViewController ??
        ScrollController(initialScrollOffset: scrollOffset);
  }

  @override
  void didUpdateWidget(_MonthPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDates != oldWidget.selectedDates) {
      final scrollOffset =
          widget.selectedDates.isNotEmpty && widget.selectedDates[0] != null
              ? _scrollOffsetForMonth(widget.selectedDates[0]!)
              : _scrollOffsetForMonth(DateUtils.dateOnly(DateTime.now()));
      _scrollController.jumpTo(scrollOffset);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMaterialLocalizations(context));
    _locale = Localizations.localeOf(context);
  }

  double _scrollOffsetForMonth(DateTime date) {
    final int initialMonthIndex = date.month - DateTime.january;
    final int initialMonthRow = initialMonthIndex ~/ _monthPickerColumnCount;
    final int centeredMonthRow = initialMonthRow - 2;
    return centeredMonthRow * _monthPickerRowHeight;
  }

  Widget _buildMonthItem(BuildContext context, int index) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final int month = 1 + index;
    final bool isCurrentMonth =
        widget.initialMonth.year == widget.config.currentDate.year &&
            widget.config.currentDate.month == month;
    const double decorationHeight = 85.0;
    const double decorationWidth = 85.0;

    final bool isSelected = widget.selectedDates.isNotEmpty &&
        widget.selectedDates.any((date) =>
            date != null &&
            widget.initialMonth.year == date.year &&
            date.month == month);

    final bool isCurrentlyDisplayedMonth = widget.initialMonth.month == month;

    // var isMonthSelectable =
    //     widget.initialMonth.year >= widget.config.firstDate.year &&
    //         widget.initialMonth.year <= widget.config.lastDate.year;

    var isMonthSelectable = true;

    if (isMonthSelectable) {
      var isAfterFirst = true;
      var isBeforeLast = true;
      if (widget.initialMonth.year == widget.config.firstDate.year) {
        isAfterFirst = month >= widget.config.firstDate.month;
      }

      if (widget.initialMonth.year == widget.config.lastDate.year) {
        isBeforeLast = month <= widget.config.lastDate.month;
      }
      isMonthSelectable = isAfterFirst && isBeforeLast;
    }
    final monthSelectableFromPredicate = widget.config.selectableMonthPredicate
            ?.call(widget.initialMonth.year, month) ??
        true;
    isMonthSelectable = isMonthSelectable && monthSelectableFromPredicate;

    final Color textColor;
    if (isSelected || isCurrentlyDisplayedMonth) {
      textColor = colorScheme.onSurface.withValues(alpha: 0.87);
    } else if (!isMonthSelectable) {
      textColor = colorScheme.onSurface.withValues(alpha: 0.38);
    } else if (isCurrentMonth) {
      textColor =
          widget.config.selectedDayHighlightColor ?? colorScheme.primary;
    } else {
      textColor = colorScheme.onSurface.withValues(alpha: 0.87);
    }

    TextStyle? itemStyle = widget.config.monthTextStyle ??
        textTheme.bodyLarge?.apply(color: textColor);
    if (!isMonthSelectable) {
      itemStyle = widget.config.disabledMonthTextStyle ?? itemStyle;
    }
    if (isSelected || isCurrentlyDisplayedMonth) {
      itemStyle = widget.config.selectedMonthTextStyle ?? itemStyle;
    }

    // Different styling for different states
    BoxDecoration? decoration;

    if (isCurrentlyDisplayedMonth) {
      // Currently displayed month gets dashed border or different style
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(decorationHeight / 2),
        border: Border.all(
            width: 1, color: const Color(0xFFACB1BF), style: BorderStyle.solid),
      );
    }

    if (!isSelected && isCurrentlyDisplayedMonth) {
      // Currently displayed month gets dashed border or different style
      itemStyle = itemStyle?.copyWith(color: Colors.white);
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: const Color(0xFF1A1B1D), // Black background for today's date
        border: Border.all(width: 2, color: const Color(0xFF393B40)),
      );
    }

    if (isCurrentMonth && isMonthSelectable) {
      // Today's month gets its own style
      itemStyle = itemStyle?.copyWith(color: Colors.black87);
      decoration = BoxDecoration(
        border: Border.all(
          color: widget.config.selectedDayHighlightColor ?? colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(decorationHeight),
      );
    }

    if (isCurrentMonth) {
      itemStyle = widget.config.currentMonthTextStyle ?? itemStyle;
    }

    Widget monthItem = widget.config.monthBuilder?.call(
          month: month,
          textStyle: itemStyle,
          decoration: decoration,
          isSelected: isSelected || isCurrentlyDisplayedMonth,
          isDisabled: !isMonthSelectable,
          isCurrentMonth: isCurrentMonth,
        ) ??
        Container(
          decoration: decoration,
          height: decorationHeight,
          width: decorationWidth,
          child: Center(
            child: Semantics(
              selected: isSelected || isCurrentlyDisplayedMonth,
              button: true,
              child: Text(
                getLocaleShortMonthFormat(_locale)
                    .format(DateTime(widget.initialMonth.year, month)),
                style: itemStyle,
              ),
            ),
          ),
        );

    if (!isMonthSelectable) {
      monthItem = ExcludeSemantics(
        child: monthItem,
      );
    } else {
      monthItem = InkWell(
        key: ValueKey<int>(month),
        onTap: !isMonthSelectable
            ? null
            : () {
                widget.onChanged(DateUtils.dateOnly(
                  DateTime(widget.initialMonth.year, month),
                ));
              },
        child: monthItem,
      );
    }

    return monthItem;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    return Column(
      children: <Widget>[
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            gridDelegate: _monthPickerGridDelegate,
            itemBuilder: _buildMonthItem,
            itemCount: 12,
            padding:
                const EdgeInsets.symmetric(horizontal: _monthPickerPadding),
          ),
        )
      ],
    );
  }
}

class _MonthPickerGridDelegate extends SliverGridDelegate {
  const _MonthPickerGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth = (constraints.crossAxisExtent -
            (_monthPickerColumnCount - 1) * _monthPickerRowSpacing) /
        _monthPickerColumnCount;
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: _monthPickerRowHeight,
      crossAxisCount: _monthPickerColumnCount,
      crossAxisStride: tileWidth + _monthPickerRowSpacing,
      mainAxisStride: _monthPickerRowHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_MonthPickerGridDelegate oldDelegate) => false;
}

const _MonthPickerGridDelegate _monthPickerGridDelegate =
    _MonthPickerGridDelegate();
