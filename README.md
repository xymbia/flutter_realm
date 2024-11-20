# Flutter Realm

Welcome to **Flutter Realm**! This repository serves as a testing ground for Flutter developers. The primary goal is to allow candidates to showcase their skills by building and submitting new Flutter widgets. Each candidate contributes through a pull request (PR) which will be evaluated based on coding practices, creativity, and functionality. This structured approach enables an efficient, hands-on assessment of Flutter skills.

## Purpose

**Flutter Realm** is designed for Flutter developer candidates to demonstrate their abilities in:

- **Widget Creation**: Building and implementing custom widgets that integrate seamlessly within a larger Flutter app.
- **Flutter Fundamentals**: Showcasing knowledge of Dart, widget trees, state management, and Flutter’s core libraries.
- **Code Quality**: Writing clean, maintainable, and efficient code that aligns with best practices.
- **Collaboration**: Using GitHub workflows to make PRs, follow coding standards, and adhere to version control etiquette.

## Project Structure (Needs to be Updated)

The project is based on **Gregertw’s ActingWeb FirstApp** and has been modified to provide a framework for candidates to contribute their work easily.

### Folder Structure

```plaintext
flutter_realm/
├── lib/
│   ├── main.dart                # Entry point of the app
│   ├── widgets/                 # Folder for candidate-created widgets
│   ├── screens/                 # Core screens for navigating between candidate widgets
│   ├── models/                  # Data models (if needed)
│   ├── services/                # Services for backend calls (if applicable)
│   └── utils/                   # Utility classes and functions
├── test/                        # Unit and widget tests
├── pubspec.yaml                 # Package dependencies
└── README.md                    # Project documentation
```

### Screens

- **Home Screen**: Provides an overview of the app and introduces the “Realm” for widget contributions.
- **Widget Realm Screen**: A dedicated screen that loads and showcases each widget submitted by candidates. Widgets will appear here automatically if properly integrated.

### Widgets Folder

The `widgets/` folder is the main area for candidate contributions. Candidates should create a new Dart file for each widget, using the naming convention `widget_name_widget.dart`. All widgets should follow consistent naming and code organization to ensure easy integration and testing.

## Candidate Guide

This section is specifically for developers aiming to showcase their skills in the Flutter Realm.

### How to Get Started

1. **Fork the Repository**: Start by forking this repository to your own GitHub account.
2. **Clone Your Fork**: Clone the repository locally on your development machine.
   ```bash
   git clone https://github.com/xymbia/flutter_realm.git
   cd flutter_realm
   ```
3. **Create a New Branch**: Name your branch something descriptive.
   ```bash
   git checkout -b add-your-widget
   ```
4. **Build Your Widget**:
   - Navigate to `lib/widgets/` and create a new file for your widget.
   - Implement your widget by adhering to best practices and keeping the design intuitive.
   - Widgets should be self-contained and avoid excessive dependencies.
5. **Test Your Code**: Ensure that your code runs without errors, and test it using a simulator or physical device.
6. **Document Your Work**: In the new widget file, include inline comments to explain complex logic or design choices.
7. **Submit a Pull Request**: Push your branch to your forked repository and create a pull request back to the main `flutter_realm` repo.

### Coding Standards

- **Naming Conventions**: Use descriptive names for files, classes, and functions (e.g., `ProfileCardWidget`).
- **Avoid Duplicates**: Before adding dependencies, check the `pubspec.yaml` file to avoid duplicates.
- **Commenting**: Include comments for non-obvious logic.
- **Readability**: Write readable code with proper indentation and spacing.

### Widget Requirements

1. **Integration**: Each widget should be encapsulated and integrate with the app’s theme.
2. **Functionality**: Widgets should ideally be interactive and demonstrate specific functionality (e.g., form inputs, animations, etc.).
3. **Responsiveness**: Ensure widgets render well on both Android and iOS across various screen sizes.

### SOLID Principles

Each widget should follow the SOLID patterns as outlined in Wiki -> [Flutter Solid Principles for Widgets](https://github.com/xymbia/flutter_realm/wiki/SOLID-Principles)

## Evaluation Criteria

Each submission will be reviewed based on the following criteria:

1. **Code Quality**: Is the code readable, organized, and maintainable?
2. **Design and UX**: Does the widget offer a good user experience and align with Flutter’s design principles?
3. **Functionality**: Does the widget work as expected without bugs or crashes?
4. **Innovation**: Is there any creativity or unique approach demonstrated?

## Running the App Locally

To test the app and view your widget:

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
2. **Run the App**:
   ```bash
   flutter run
   ```
3. **Testing Your Widget**: Navigate to the “Widget Realm” screen in the app to view and interact with your widget.

## Troubleshooting

If you encounter any issues:

- Review your code for typos or syntax errors.
- Confirm you’ve added all necessary imports and dependencies.
- Refer to the [Flutter Documentation](https://flutter.dev/docs) for additional guidance.

## Contributing Beyond Widgets

If you would like to contribute to the core functionality of Flutter Realm, such as improving the app’s UI, adding screens, or enhancing navigation, please reach out with your ideas.

## License

This repository is licensed under the Apache 2.0 License. See `LICENSE` for more information.
