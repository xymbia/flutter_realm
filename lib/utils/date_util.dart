import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Get the number of days offset for the first day in a month.
int getMonthFirstDayOffset(int year, int month, int firstDayOfWeekIndex) {
  // 0-based day of week for the month and year, with 0 representing Monday.
  final int weekdayFromMonday = DateTime(year, month).weekday - 1;

  // firstDayOfWeekIndex recomputed to be Monday-based, in order to compare with
  // weekdayFromMonday.
  firstDayOfWeekIndex = (firstDayOfWeekIndex - 1) % 7;

  // Number of days between the first day of week appearing on the calendar,
  // and the day corresponding to the first of the month.
  return (weekdayFromMonday - firstDayOfWeekIndex) % 7;
}

/// Get short month format for the given locale.
DateFormat getLocaleShortMonthFormat(Locale locale) {
  final String localeName = Platform.localeName;
  var monthFormat = DateFormat.MMM();
  if (DateFormat.localeExists(localeName)) {
    monthFormat = DateFormat.MMM(localeName);
  } else if (DateFormat.localeExists(locale.languageCode)) {
    monthFormat = DateFormat.MMM(locale.languageCode);
  }

  return monthFormat;
}

/// Get full month format for the given locale.
DateFormat getLocaleFullMonthFormat(Locale locale) {
  final String localeName = Intl.canonicalizedLocale(locale.toString());
  var monthFormat = DateFormat.MMMM();
  if (DateFormat.localeExists(localeName)) {
    monthFormat = DateFormat.MMMM(localeName);
  } else if (DateFormat.localeExists(locale.languageCode)) {
    monthFormat = DateFormat.MMMM(locale.languageCode);
  }

  return monthFormat;
}

/// Get the number of rows required to display all days in a month.
int getDayRowsCount(int year, int month, int firstDayOfWeekIndex) {
  final int monthFirstDayOffset =
      getMonthFirstDayOffset(year, month, firstDayOfWeekIndex);
  final int totalDays = DateUtils.getDaysInMonth(year, month);
  final int remainingDays = totalDays - (7 - monthFirstDayOffset);
  return (remainingDays / 7).ceil() + 1;
}

const List<String> monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

const List<String> monthAbbreviations = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

/// Returns full month name from month number (1-12)
String getMonthName(int monthNumber) {
  if (monthNumber >= 1 && monthNumber <= 12) {
    return monthNames[monthNumber - 1];
  }
  throw ArgumentError('Month number must be between 1 and 12');
}

String getMonthAbbreviation(int monthNumber) {
  if (monthNumber >= 1 && monthNumber <= 12) {
    return monthAbbreviations[monthNumber - 1];
  }
  throw ArgumentError('Month number must be between 1 and 12');
}

String formatDateRange(List<DateTime?> dates) {
  if (dates.isEmpty || dates.length == 1) return '';

  // Sort dates just in case
  dates.sort();

  DateTime start = dates.first!;
  DateTime end = dates.last!;

  String startDay = DateFormat('d').format(start);
  String startMonth = DateFormat('MMMM').format(start);

  String endDay = DateFormat('d').format(end);
  String endMonth = DateFormat('MMMM').format(end);

  String year = DateFormat('y').format(end);

  return "$startDay $startMonth - $endDay $endMonth, $year";
}

String formatDate(DateTime date) {
  String startDay = DateFormat('d').format(date);
  String startMonth = DateFormat('MMMM').format(date);
  String year = DateFormat('y').format(date);

  return "$startDay $startMonth, $year";
}