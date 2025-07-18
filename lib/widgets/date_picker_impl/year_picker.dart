part of '../date_picker_widget.dart';

/// A scrollable grid of years to allow picking a year.
///
/// The year picker widget is rarely used directly. Instead, consider using
/// [DatePickerWidget], or [showDatePicker2] which create full date pickers.
///
/// See also:
///
///  * [DatePickerWidget], which provides a Material Design date picker
///    interface.
///
///  * [showDatePicker2], which shows a dialog containing a Material Design
///    date picker.
///
class YearPicker extends StatefulWidget {
  /// Creates a year picker.
  const YearPicker({
    required this.config,
    required this.selectedDates,
    required this.onChanged,
    required this.initialMonth,
    this.dragStartBehavior = DragStartBehavior.start,
    Key? key,
  }) : super(key: key);

  /// The calendar configurations
  final DatePickerWidgetConfig config;

  /// The currently selected dates.
  ///
  /// Selected dates are highlighted in the picker.
  final List<DateTime?> selectedDates;

  /// Called when the user picks a year.
  final ValueChanged<DateTime> onChanged;

  /// The initial month to display.
  final DateTime initialMonth;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  @override
  State<YearPicker> createState() => _YearPickerState();
}

class _YearPickerState extends State<YearPicker> {
  late ScrollController _scrollController;

  // The approximate number of years necessary to fill the available space.
  static const int minYears = 18;

  @override
  void initState() {
    super.initState();
    final scrollOffset =
        widget.selectedDates.isNotEmpty && widget.selectedDates[0] != null
            ? _scrollOffsetForYear(widget.selectedDates[0]!)
            : _scrollOffsetForYear(DateUtils.dateOnly(DateTime.now()));
    _scrollController = widget.config.yearViewController ??
        ScrollController(initialScrollOffset: scrollOffset);
  }

  @override
  void didUpdateWidget(YearPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDates != oldWidget.selectedDates) {
      final scrollOffset =
          widget.selectedDates.isNotEmpty && widget.selectedDates[0] != null
              ? _scrollOffsetForYear(widget.selectedDates[0]!)
              : _scrollOffsetForYear(DateUtils.dateOnly(DateTime.now()));
      _scrollController.jumpTo(scrollOffset);
    }
  }

  double _scrollOffsetForYear(DateTime date) {
    final int initialYearIndex = date.year - widget.config.firstDate.year;
    final int initialYearRow = initialYearIndex ~/ _yearPickerColumnCount;
    // Move the offset down by 2 rows to approximately center it.
    final int centeredYearRow = initialYearRow - 2;
    return _itemCount < minYears ? 0 : centeredYearRow * _yearPickerRowHeight;
  }

  Widget _buildYearItem(BuildContext context, int index) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Backfill the _YearPicker with disabled years if necessary.
    final int offset = _itemCount < minYears ? (minYears - _itemCount) ~/ 2 : 0;
    final int year = widget.config.firstDate.year + index - offset;
    final bool isSelected = widget.selectedDates.any((d) => d?.year == year);
    final bool isCurrentYear = year == widget.config.currentDate.year;
    // Consider the currently displayed year as selected
    final bool isCurrentlyDisplayedYear = year == widget.initialMonth.year;
    final yearSelectableFromPredicate =
        widget.config.selectableYearPredicate?.call(year) ?? true;
    final isDisabled = (year < widget.config.firstDate.year ||
            year > widget.config.lastDate.year) ||
        !yearSelectableFromPredicate;
    const double decorationHeight = 85.0;
    const double decorationWidth = 85.0;

    final Color textColor;
    if (isSelected || isCurrentlyDisplayedYear) {
      textColor = colorScheme.onSurface.withValues(alpha: 0.87);
    } else if (isDisabled) {
      textColor = colorScheme.onSurface.withValues(alpha: 0.38);
    } else if (isCurrentYear) {
      textColor =
          widget.config.selectedDayHighlightColor ?? colorScheme.primary;
    } else {
      textColor = colorScheme.onSurface.withValues(alpha: 0.87);
    }
    TextStyle? itemStyle = widget.config.yearTextStyle ??
        textTheme.bodyLarge?.apply(color: textColor);
    if (isDisabled) {
      itemStyle = widget.config.disabledYearTextStyle ?? itemStyle;
    }
    if (isSelected || isCurrentlyDisplayedYear) {
      itemStyle = widget.config.selectedYearTextStyle ?? itemStyle;
    }

    BoxDecoration? decoration;
    if (isCurrentlyDisplayedYear) {
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(decorationHeight/2),
        border: Border.all(width: 1, color: const Color(0xFFACB1BF)),
      );
    }

    if (!isSelected && isCurrentlyDisplayedYear) {
      // Currently displayed month gets dashed border or different style
      itemStyle = itemStyle?.copyWith(color: Colors.white);
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: const Color(0xFF1A1B1D), // Black background for today's date
        border: Border.all(
            width: 2,
            color: const Color(
                0xFF393B40)),
      );
    }

    if (isCurrentYear && !isDisabled) {
      itemStyle = itemStyle?.copyWith(color: Colors.black87);
      decoration = BoxDecoration(
        border: Border.all(
          color: widget.config.selectedDayHighlightColor ?? colorScheme.primary,
        ),
        borderRadius: widget.config.yearBorderRadius ??
            BorderRadius.circular(decorationHeight / 2),
      );
    }

    Widget yearItem = widget.config.yearBuilder?.call(
          year: year,
          textStyle: itemStyle,
          decoration: decoration,
          isSelected: isSelected,
          isDisabled: isDisabled,
          isCurrentYear: isCurrentYear,
        ) ??
        Center(
          child: Container(
            decoration: decoration,
            height: decorationHeight,
            width: decorationWidth,
            child: Center(
              child: Semantics(
                selected: isSelected || isCurrentlyDisplayedYear,
                button: true,
                child: Text(
                  year.toString(),
                  style: itemStyle,
                ),
              ),
            ),
          ),
        );

    if (isDisabled) {
      yearItem = ExcludeSemantics(
        child: yearItem,
      );
    } else {
      yearItem = InkWell(
        key: ValueKey<int>(year),
        onTap: () => widget.onChanged(
          DateTime(
            year,
            widget.initialMonth.month,
          ),
        ),
        child: yearItem,
      );
    }

    return yearItem;
  }

  int get _itemCount {
    return widget.config.lastDate.year - widget.config.firstDate.year + 1;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    return Column(
      children: <Widget>[
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            dragStartBehavior: widget.dragStartBehavior,
            gridDelegate: _yearPickerGridDelegate,
            itemBuilder: _buildYearItem,
            itemCount: math.max(_itemCount, minYears),
            padding: const EdgeInsets.symmetric(horizontal: _yearPickerPadding),
          ),
        )
      ],
    );
  }
}

class _YearPickerGridDelegate extends SliverGridDelegate {
  const _YearPickerGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth = (constraints.crossAxisExtent -
            (_yearPickerColumnCount - 1) * _yearPickerRowSpacing) /
        _yearPickerColumnCount;
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: _yearPickerRowHeight,
      crossAxisCount: _yearPickerColumnCount,
      crossAxisStride: tileWidth + _yearPickerRowSpacing,
      mainAxisStride: _yearPickerRowHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_YearPickerGridDelegate oldDelegate) => false;
}

const _YearPickerGridDelegate _yearPickerGridDelegate =
    _YearPickerGridDelegate();
