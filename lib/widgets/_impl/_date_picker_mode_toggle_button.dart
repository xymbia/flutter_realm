part of '../date_picker_widget.dart';

/// A button that used to toggle the [DatePickerWidgetMode] for a date picker.
///
/// This appears above the calendar grid and allows the user to toggle the
/// [DatePickerWidgetMode] to display either the calendar view or the year list.
class _DatePickerModeToggleButton extends StatefulWidget {
  const _DatePickerModeToggleButton({
    required this.mode,
    required this.monthDate,
    required this.onMonthPressed,
    required this.onYearPressed,
    required this.config,
  });

  /// The current display of the calendar picker.
  final DatePickerWidgetMode mode;

  /// The current selected month.
  final DateTime monthDate;

  /// The callback when the month is pressed.
  final VoidCallback onMonthPressed;

  /// The callback when the year is pressed.
  final VoidCallback onYearPressed;

  /// The calendar configurations
  final DatePickerWidgetConfig config;

  @override
  _DatePickerModeToggleButtonState createState() =>
      _DatePickerModeToggleButtonState();
}

class _DatePickerModeToggleButtonState
    extends State<_DatePickerModeToggleButton> with TickerProviderStateMixin {
  late AnimationController _monthController;
  late AnimationController _yearController;
  late MaterialLocalizations _localizations;
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    final isMonthOrYearMode = widget.mode == DatePickerWidgetMode.year ||
        widget.mode == DatePickerWidgetMode.month;
    _monthController = AnimationController(
      value: isMonthOrYearMode ? 0.5 : 0,
      upperBound: 0.5,
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _yearController = AnimationController(
      value: isMonthOrYearMode ? 0.5 : 0,
      upperBound: 0.5,
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMaterialLocalizations(context));
    _localizations = MaterialLocalizations.of(context);
    _locale = Localizations.localeOf(context);
  }

  @override
  void didUpdateWidget(_DatePickerModeToggleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode == widget.mode) {
      return;
    }

    if (widget.mode == DatePickerWidgetMode.month) {
      _monthController.forward();
      _yearController.reverse();
    }

    if (widget.mode == DatePickerWidgetMode.year) {
      _yearController.forward();
      _monthController.reverse();
    }

    if (widget.mode == DatePickerWidgetMode.day) {
      _yearController.reverse();
      _monthController.reverse();
    }
  }

  @override
  void dispose() {
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var datePickerOffsetPadding = _monthNavButtonsWidth;
    if (widget.config.centerAlignModePicker == true) {
      datePickerOffsetPadding /= 2;
    }

    return Container(
      padding: widget.config.centerAlignModePicker == true
          ? EdgeInsets.zero
          : const EdgeInsetsDirectional.only(start: 16, end: 4),
      height: (widget.config.controlsHeight ?? _subHeaderHeight),
      child: Row(
        children: <Widget>[
          // if (widget.mode == DatePickerWidgetMode.day &&
          //     widget.config.centerAlignModePicker == true)
          //   // Give space for the prev/next month buttons that are underneath this row
          //   SizedBox(width: datePickerOffsetPadding),
          // ..._buildModePickerButtons(),
          // if (widget.mode == DatePickerWidgetMode.day)
          //   // Give space for the prev/next month buttons that are underneath this row
          //   SizedBox(width: datePickerOffsetPadding),
        ],
      ),
    );
  }

  List<Widget> _buildModePickerButtons() {
    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;
    final TextTheme textTheme = themeData.textTheme;
    final Color controlColor = colorScheme.onSurface.withValues(alpha: 0.60);
    final controlTextStyle = widget.config.controlsTextStyle ??
        textTheme.titleSmall?.copyWith(color: controlColor);
    final modePickerIcon = widget.config.customModePickerIcon ??
        Icon(
          Icons.arrow_drop_down,
          color: widget.config.controlsTextStyle?.color ?? controlColor,
        );
    final modePickerMainAxisAlignment =
        widget.config.centerAlignModePicker == true
            ? MainAxisAlignment.center
            : MainAxisAlignment.start;
    final horizontalPadding = widget.config.centerAlignModePicker == true
        ? (widget.config.dayMaxWidth ?? (_dayPickerRowHeight - 2)) / 4
        : 8.0;

    return widget.config.disableMonthPicker == true
        ? [
            Flexible(
              child: Semantics(
                label: widget.config.semanticsDictionary?[
                        DatePickerWidgetSemanticsLabel.selectYear] ??
                    MaterialLocalizations.of(context).selectYearSemanticsLabel,
                excludeSemantics: true,
                button: true,
                child: SizedBox(
                  height: (widget.config.controlsHeight ?? _subHeaderHeight),
                  child: InkWell(
                    onTap: widget.config.disableModePicker == true
                        ? null
                        : widget.onYearPressed,
                    child: widget.config.modePickerBuilder?.call(
                          viewMode: widget.mode,
                          monthDate: widget.monthDate,
                        ) ??
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding),
                          child: Row(
                            mainAxisAlignment: modePickerMainAxisAlignment,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  widget.config.modePickerTextHandler
                                          ?.call(monthDate: widget.monthDate) ??
                                      _localizations
                                          .formatMonthYear(widget.monthDate),
                                  overflow: TextOverflow.ellipsis,
                                  style: controlTextStyle,
                                ),
                              ),
                              widget.config.disableModePicker == true
                                  ? const SizedBox()
                                  : RotationTransition(
                                      turns: _yearController,
                                      child: modePickerIcon,
                                    ),
                            ],
                          ),
                        ),
                  ),
                ),
              ),
            ),
          ]
        : [
            Expanded(
              child: Row(
                mainAxisAlignment: modePickerMainAxisAlignment,
                children: [
                  Semantics(
                    label: widget.config.semanticsDictionary?[
                            DatePickerWidgetSemanticsLabel.selectMonth] ??
                        MaterialLocalizations.of(context)
                            .selectYearSemanticsLabel,
                    excludeSemantics: true,
                    button: true,
                    child: SizedBox(
                      height:
                          (widget.config.controlsHeight ?? _subHeaderHeight),
                      child: InkWell(
                        onTap: widget.config.disableModePicker == true
                            ? null
                            : widget.onMonthPressed,
                        child: widget.config.modePickerBuilder?.call(
                              viewMode: widget.mode,
                              monthDate: widget.monthDate,
                              isMonthPicker: true,
                            ) ??
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      widget.config.modePickerTextHandler?.call(
                                            monthDate: widget.monthDate,
                                            isMonthPicker: true,
                                          ) ??
                                          (widget.config.useAbbrLabelForMonthModePicker ==
                                                          true
                                                      ? getLocaleShortMonthFormat
                                                      : getLocaleFullMonthFormat)(
                                                  _locale)
                                              .format(widget.monthDate),
                                      overflow: TextOverflow.ellipsis,
                                      style: controlTextStyle,
                                    ),
                                  ),
                                  widget.config.disableModePicker == true
                                      ? const SizedBox()
                                      : RotationTransition(
                                          turns: _monthController,
                                          child: modePickerIcon,
                                        ),
                                ],
                              ),
                            ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: widget.config.modePickersGap ??
                        (widget.config.centerAlignModePicker == true ? 15 : 5),
                  ),
                  Semantics(
                    label: widget.config.semanticsDictionary?[
                            DatePickerWidgetSemanticsLabel.selectYear] ??
                        MaterialLocalizations.of(context)
                            .selectYearSemanticsLabel,
                    excludeSemantics: true,
                    button: true,
                    child: SizedBox(
                      height:
                          (widget.config.controlsHeight ?? _subHeaderHeight),
                      child: InkWell(
                        onTap: widget.config.disableModePicker == true
                            ? null
                            : widget.onYearPressed,
                        child: widget.config.modePickerBuilder?.call(
                              viewMode: widget.mode,
                              monthDate: widget.monthDate,
                            ) ??
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      widget.config.modePickerTextHandler?.call(
                                              monthDate: widget.monthDate) ??
                                          _localizations
                                              .formatYear(widget.monthDate),
                                      overflow: TextOverflow.ellipsis,
                                      style: controlTextStyle,
                                    ),
                                  ),
                                  widget.config.disableModePicker == true
                                      ? const SizedBox()
                                      : RotationTransition(
                                          turns: _yearController,
                                          child: modePickerIcon,
                                        ),
                                ],
                              ),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ];
  }
}
