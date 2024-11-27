## Objective

Develop a simplified reminder dialog box that displays information about when the reminder should occur and whether the reminder should be an email or a notification.

## Requirements

### UI Components

- A numerical input field that takes input ranging from 0-999.

- A dropdown input field that has the options \[minute, hour, day, week, month, year] and the user has to choose one.

- Two checkboxes with text Email & Notification in front of them telling how the reminder should be sent to the user.

- Figma designs are given -> https\://www\.figma.com/design/oXPyen9XZFY2jrjvJsmXxG/flutter-widgets?node-id=1-12756\&node-type=frame\&t=lblR5kJYxHW0Gvth-0

### Data Management

- Use a mock service class to simulate fetching reminder data. The service class should use async operations to return reminder data.

- Sample data format:

![Reminder Widget](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcTvuW-mrtNWSAkfZ6giTQ-y4divTayFBQpTTd-Uy2s7ox8YGqrxolVEGD45Y_CBbhtm0H-f28ut13_B2WYLlpNuKHmb1DXg2zxPPWSW8xgN51tLdxNj5dYa0Rmv8Pql0SN6HuaTg?key=kWhJidEGgzNElMLO8pBNhyWo)

### Navigation

- No navigation is required for this widget.

### Unit Testing

- Write unit tests for the mock service class to ensure it returns the expected data format and values.

- Test the logic to verify that it correctly handles data fetching and state updates.

## Guidelines

- Focus on code quality, readability, and adherence to Flutter best practices.

- Follow the given project structure as outlined in the README file.

- Ensure that no business logic is found inside UI files. Keep UI components and business logic as decoupled as possible.

- Write comments and documentation to explain the reasoning behind certain decisions.

## Submission

- Follow submission guidelines as mentioned in the repository Readme.

##

## Project Structure

- **/lib/**

  - **main.dart -** _Entry point of the application._

  - **/assets/images/**

  - **/models/**

    - task*reminder.dart - \_Model for reminder data.*

  - **/services/**

  - **/screens/**

    - reminder*example.dart - \_Displays current reminder details.*

  - **/widgets/**

    - reminder.dart - _A reusable widget to display reminder information._
