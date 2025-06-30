## Objective

Develop a reusable Date Picker widget that supports both single and range date selection modes. The widget should provide a calendar interface with month and year navigation, multiple date states, and user interactions for various scheduling and date selection scenarios.

## Requirements

## UI Components

## Core Calendar Interface

- A **Calendar Grid** displaying dates for the current month with day-of-week headers Sunday through Saturday

- A **Month/Year Header** displaying current month and year with dropdown functionality

- **Actions Buttons** for confirming date selections

## Date Selection Modes

- **Single Date Picker**

  - Header: "Select Date"
  - Single date selection capability
  - Selected date should be highlighted

- **Range Date Picker**
  - Header: "Select Start & End Date" (initially), then "[start date]-[end date]" after selection
  - Start and end date selection capability
  - Dates between start date & end date should be highlighted

## Month & Year Selectors

    - A grid layout showing all 12 months with current month selected
    - A grid layout showing multiple years with current year highlighted

## Date States Visual Indicators

- **Default Date** would be the standard appearance for all dates that are selectable

- **Inactive Date** would be the grayed out appearance for all dates that are non-selectable

- **Current Date** would be the highlighted today's date

- **Selected Date** would have the bold appearance for chosen date(s)

- **Range Date** would have a visual styling for dates within the start date and end date

- **Preview Date** would have a subtle highlighting for scenarios where we would want to preview dates for an upcoming event/task etc.

## Data Management

**Sample Model Structure**

```
class DatePickerData {
  DateTime? selectedDate;
  DateTime? startDate;
  DateTime? endDate;
  DateTime currentMonth;
  List<DateTime> disabledDates;
  DatePickerMode mode;
}

enum DatePickerMode {
  single,
  range
}
```

**Sample Service Class Impl**

- **fetchAvailableDates()** - Returns list of selectable dates
- **fetchDisabledDates()** - Returns list of disabled dates
- **validateDateSelection()** - Validates selected dates against rules
- **saveSelectedDates()** - Persists date selections

## State Management

- Use Flutter's built-in state management (StatefulWidget)
- Maintain current calendar view state (month, year)
- Handle month/year navigation state
- Manage date validation and error states

## Navigation & Interactions

**Calendar Navigation**

- Month Navigation: Left/right arrows to navigate between months
- Year Navigation: Dropdown or picker interface for year selection
- Month Selection: Tap to open month picker, select month to navigate to that month

**Date Selection Logic**

- Single Mode: Tap any date to select it, replace previous selection

- Range Mode:
  - First tap sets start date
  - Second tap sets end date (if after start date) or new start date (if before start date)

## Validation & Business Logic

**Date Validation Rules**

- Prevent selection of disabled dates
- Ensure start date is before end date in range mode
- Validate against minimum/maximum date constraints
- Handle edge cases (month boundaries, leap years)

## Unit Testing

- Write unit tests for service class to ensure it returns the expected data format and values.

- Test the logic to verify that it correctly handles data fetching and state updates.

- Use Flutter's built-in testing framework and mockito for mocking and testing

## Guidelines

**Code Quality Standards**

- Follow Flutter and Dart best practices and conventions
- Implement proper separation of concerns (UI, business logic, data)
- Use meaningful variable and function names
- Write comprehensive documentation and comments
- Ensure code is maintainable and scalable

**Performance Considerations**

- Efficient rendering of calendar grids
- Minimize widget rebuilds during navigation

**Customization Support**

- Allow theming and styling customization

## Submission

- Follow submission guidelines as mentioned in the repository Readme.

## Project Structure (Can be customized based on widget requirements)

- **/lib/**

  - **main.dart -** _Entry point of the application._

  - **/assets/images/**

  - **/models/**

    - date_picker_data.dart

  - **/services/**

  - **/screens/**

    - date_picker_example.dart

  - **/widgets/**

    - date_picker.dart
    - calendar_grid.dart
    - month_picker.dart
    - year_picker.dart
    - date_picker_header.dart

## Figma Reference

Design specifications: [Date Range Picker Widget](https://www.figma.com/design/WWtxsUlJhNCmacODCGRk80/03---Calendar?node-id=2517-90578&t=EiARDsC829ht8gbd-0)
