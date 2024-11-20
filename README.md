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

### Solid Principles

Each widget should follow patterns and architectural decisions outlined by the SOLID principles. We will go through each principle and show good and
bad widget implementations based on that principle.
For the purpose of demonstration, we will consider following widget for showcasing all principles.

```
   class CustomFAB extends StatelessWidget {
   final VoidCallback onPressed;
   final IconData? icon;
   final bool isReturnFAB;

   CustomFAB({
      required this.onPressed,
      this.icon,
      this.isReturnFAB = false,
   });

   @override
   Widget build(BuildContext context) {
      final colorScheme = Theme.of(context).colorScheme;
      return FloatingActionButton(
         onPressed: onPressed,
         child: Icon(
         isReturnFAB ? Icons.keyboard_return : icon ?? Icons.add_outlined,
         size: 24.sp,
         ),
         heroTag: new Object(),
         elevation: 0.0,
         highlightElevation: 0.0,
         backgroundColor: colorScheme.secondaryContainer,
      );
   }
   }
```

## Single Responsibility

The widget should have one and only one reason to change, meaning it should focus on a single functionality.

# WRONG IMPLEMENTATION

```
   class CustomFAB extends StatelessWidget {
   final VoidCallback onPressed;
   final IconData? icon;
   final bool isReturnFAB;

   CustomFAB({
      required this.onPressed,
      this.icon,
      this.isReturnFAB = false,
   });

   @override
   Widget build(BuildContext context) {
      final colorScheme = Theme.of(context).colorScheme;
      return FloatingActionButton(
         onPressed: onPressed,
         child: Icon(
         isReturnFAB ? Icons.keyboard_return : icon ?? Icons.add_outlined,
         size: 24.sp,
         ),
         heroTag: new Object(),
         elevation: 0.0,
         highlightElevation: 0.0,
         backgroundColor: colorScheme.secondaryContainer,
      );
   }
   }
```

Problems with above widget:

1. Decides what icon to display (isReturnFAB vs icon logic).
2. Relies on external logic (isReturnFAB) tightly coupled with UI.
3. Manages the visual appearance, including the theme and styling.

# CORRECT IMPLEMENTATION

Step 1: Create a FAB Icon Selector

```
   class FABIcon extends StatelessWidget {
   final IconData? icon;
   final bool isReturnFAB;

   FABIcon({this.icon, this.isReturnFAB = false});

   @override
   Widget build(BuildContext context) {
      return Icon(
         isReturnFAB ? Icons.keyboard_return : icon ?? Icons.add_outlined,
         size: 24.0,
      );
   }
   }
```

Step 2: Create a FAB Styling Wrapper

```
   class FABStyler extends StatelessWidget {
   final Widget child;
   final VoidCallback onPressed;

   FABStyler({required this.child, required this.onPressed});

   @override
   Widget build(BuildContext context) {
      final colorScheme = Theme.of(context).colorScheme;
      return FloatingActionButton(
         onPressed: onPressed,
         child: child,
         heroTag: Object(),
         elevation: 0.0,
         highlightElevation: 0.0,
         backgroundColor: colorScheme.secondaryContainer,
      );
   }
   }
```

Step 3: Combine Components in the CustomFAB

```
   class CustomFAB extends StatelessWidget {
   final VoidCallback onPressed;
   final IconData? icon;
   final bool isReturnFAB;

   CustomFAB({
      required this.onPressed,
      this.icon,
      this.isReturnFAB = false,
   });

   @override
   Widget build(BuildContext context) {
      return FABStyler(
         onPressed: onPressed,
         child: FABIcon(
         icon: icon,
         isReturnFAB: isReturnFAB,
         ),
      );
   }
   }
```

## Open/Closed Principle

A class/module should be open for extension but closed for modification

# WRONG IMPLEMENTATION

```
   class CustomFAB extends StatelessWidget {
   final VoidCallback onPressed;
   final IconData? icon;
   final bool isReturnFAB;
   final bool isCancelFAB;

   CustomFAB({
      required this.onPressed,
      this.icon,
      this.isReturnFAB = false,
      this.isCancelFAB = false,
   });

   @override
   Widget build(BuildContext context) {
      final colorScheme = Theme.of(context).colorScheme;
      return FloatingActionButton(
         onPressed: onPressed,
         child: Icon(
         isReturnFAB
               ? Icons.keyboard_return
               : isCancelFAB
                  ? Icons.cancel
                  : icon ?? Icons.add_outlined,
         size: 24.0,
         ),
         heroTag: Object(),
         elevation: 0.0,
         highlightElevation: 0.0,
         backgroundColor: colorScheme.secondaryContainer,
      );
   }
   }
```

Problems with above widget:

1. Adding a new FAB type requires modifying this class by introducing another boolean or condition.
2. The conditions for different types of FABs become more complex as new types are added.
3. The widget becomes a block of code that handles multiple responsibilities.

# CORRECT IMPLEMENTATION

Step 1: Define an Interface for FAB Icon Selection

```
   abstract class FABIconStrategy {
   Icon buildIcon();
   }
```

Step 2: Implement Different Icon Strategies

```
   class ReturnFABIconStrategy implements FABIconStrategy {
   @override
   Icon buildIcon() {
      return Icon(Icons.keyboard_return, size: 24.0);
   }
   }

   class CancelFABIconStrategy implements FABIconStrategy {
   @override
   Icon buildIcon() {
      return Icon(Icons.cancel, size: 24.0);
   }
   }

   class DefaultFABIconStrategy implements FABIconStrategy {
   @override
   Icon buildIcon() {
      return Icon(Icons.add_outlined, size: 24.0);
   }
   }
```

Step 3: Update the CustomFAB

```
   class CustomFAB extends StatelessWidget {
   final VoidCallback onPressed;
   final FABIconStrategy iconStrategy;

   CustomFAB({
      required this.onPressed,
      required this.iconStrategy,
   });

   @override
   Widget build(BuildContext context) {
      final colorScheme = Theme.of(context).colorScheme;
      return FloatingActionButton(
         onPressed: onPressed,
         child: iconStrategy.buildIcon(),
         heroTag: Object(),
         elevation: 0.0,
         highlightElevation: 0.0,
         backgroundColor: colorScheme.secondaryContainer,
      );
   }
   }
```

Step 4: Use the CustomFAB with Different Strategies

```
   class MyScreen extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
      return Scaffold(
         floatingActionButton: Column(
         mainAxisSize: MainAxisSize.min,
         children: [
            CustomFAB(
               onPressed: () => print("Return FAB pressed"),
               iconStrategy: ReturnFABIconStrategy(),
            ),
            SizedBox(height: 16),
            CustomFAB(
               onPressed: () => print("Cancel FAB pressed"),
               iconStrategy: CancelFABIconStrategy(),
            ),
            SizedBox(height: 16),
            CustomFAB(
               onPressed: () => print("Default FAB pressed"),
               iconStrategy: DefaultFABIconStrategy(),
            ),
         ],
         ),
      );
   }
   }
```

## Liskov Substitution Principle

Objects of a superclass should be replaceable with objects of a subclass without changing the required properties of the program

# WRONG IMPLEMENTATION

```
   class CustomFAB extends StatelessWidget {
   final VoidCallback onPressed;
   final FABIconStrategy iconStrategy;

   CustomFAB({
      required this.onPressed,
      required this.iconStrategy,
   });

   @override
   Widget build(BuildContext context) {
      final colorScheme = Theme.of(context).colorScheme;
      return FloatingActionButton(
         onPressed: onPressed,
         child: iconStrategy.buildIcon(),
         heroTag: Object(),
         elevation: 0.0,
         highlightElevation: 0.0,
         backgroundColor: colorScheme.secondaryContainer,
      );
   }
   }

   // Violating LSP: Modifies behavior in an unexpected way
   class DisabledFAB extends CustomFAB {
   DisabledFAB() : super(onPressed: () {}, iconStrategy: DefaultFABIconStrategy());

   @override
   Widget build(BuildContext context) {
      // Overriding behavior to disable FAB
      return FloatingActionButton(
         onPressed: null, // Disabled FAB
         child: iconStrategy.buildIcon(),
         backgroundColor: Colors.grey, // Changes color unexpectedly
      );
   }
   }
```

Problems with above widget:

1. Replacing CustomFAB with DisabledFAB breaks the expected behavior because onPressed is unexpectedly disabled.
2. CustomFAB guarantees an active onPressed function, but DisabledFAB nullifies it, violating the principle.
3. Anywhere CustomFAB is used, substituting DisabledFAB will lead to unexpected results.

# CORRECT IMPLEMENTATION

```
class CustomFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final FABIconStrategy iconStrategy;

  CustomFAB({
    required this.onPressed,
    required this.iconStrategy,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return FloatingActionButton(
      onPressed: onPressed,
      child: iconStrategy.buildIcon(),
      heroTag: Object(),
      elevation: 0.0,
      highlightElevation: 0.0,
      backgroundColor: colorScheme.secondaryContainer,
    );
  }
}

// Extends behavior while maintaining substitutability
class ThemedFAB extends CustomFAB {
  final Color backgroundColor;

  ThemedFAB({
    required VoidCallback onPressed,
    required FABIconStrategy iconStrategy,
    required this.backgroundColor,
  }) : super(onPressed: onPressed, iconStrategy: iconStrategy);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: iconStrategy.buildIcon(),
      backgroundColor: backgroundColor, // Uses the specified background color
      heroTag: Object(),
      elevation: 0.0,
      highlightElevation: 0.0,
    );
  }
}
```

The ThemedFAB can substitute CustomFAB without breaking the expected behavior.

```
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Using CustomFAB
          CustomFAB(
            onPressed: () => print("Default FAB pressed"),
            iconStrategy: DefaultFABIconStrategy(),
          ),
          SizedBox(height: 16),
          // Substituting ThemedFAB for CustomFAB
          ThemedFAB(
            onPressed: () => print("Themed FAB pressed"),
            iconStrategy: ReturnFABIconStrategy(),
            backgroundColor: Colors.blue, // Custom theme
          ),
        ],
      ),
    );
  }
}
```

## Interface Segregation Principle

A class should not be forced to implement interfaces it does not use

# WRONG IMPLEMENTATION

```
class CustomFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isThemed;
  final Color? customBackgroundColor;
  final bool showLabel;
  final String? label;

  CustomFAB({
    required this.onPressed,
    this.icon,
    this.isThemed = false,
    this.customBackgroundColor,
    this.showLabel = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return FloatingActionButton.extended(
      onPressed: onPressed,
      label: showLabel ? Text(label ?? '') : null,
      icon: Icon(icon ?? Icons.add_outlined),
      backgroundColor:
          isThemed ? customBackgroundColor ?? colorScheme.secondaryContainer : colorScheme.primaryContainer,
    );
  }
}
```

Problems with above widget:

1. Not all FABs require a label or theming. However, every instance of CustomFAB must deal with these properties, even when they are irrelevant.
2. Combining multiple responsibilities (handling labels, themes, and icons).
3. Clients have to interact with properties that are not relevant to their specific use case.

# CORRECT IMPLEMENTATION

Step 1: Create Focused Base Widgets

```
class BaseFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final Color backgroundColor;

  BaseFAB({
    required this.onPressed,
    required this.icon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: icon,
      backgroundColor: backgroundColor,
    );
  }
}
```

Step 2: Add Extended Widgets for Specific Use Cases

Themed FAB:

```
class ThemedFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;

  ThemedFAB({
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BaseFAB(
      onPressed: onPressed,
      icon: icon,
      backgroundColor: colorScheme.secondaryContainer,
    );
  }
}
```

Labeled FAB:

```
class LabeledFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final String label;
  final Color backgroundColor;

  LabeledFAB({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: icon,
      label: Text(label),
      backgroundColor: backgroundColor,
    );
  }
}
```

Step 3: Use Widgets Based on Specific Needs

```
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Basic FAB
          BaseFAB(
            onPressed: () => print("Base FAB pressed"),
            icon: Icon(Icons.add_outlined),
            backgroundColor: Colors.blue,
          ),
          SizedBox(height: 16),
          // Themed FAB
          ThemedFAB(
            onPressed: () => print("Themed FAB pressed"),
            icon: Icon(Icons.keyboard_return),
          ),
          SizedBox(height: 16),
          // Labeled FAB
          LabeledFAB(
            onPressed: () => print("Labeled FAB pressed"),
            icon: Icon(Icons.save),
            label: "Save",
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
```

## Dependency Inversion Principle

High-level modules should not depend on low-level modules instead, both should depend on abstractions.

# WRONG IMPLEMENTATION

```
class CustomFAB extends StatelessWidget {
  final VoidCallback onPressed;

  CustomFAB({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FloatingActionButton(
      onPressed: onPressed,
      child: Icon(Icons.add),
      backgroundColor: colorScheme.secondaryContainer, // Direct dependency
    );
  }
}
```

Problems with above widget:

1. CustomFAB directly depends on Theme.of(context).colorScheme, making it difficult to replace or customize the color scheme logic.
2. The widget tightly couples its functionality with specific design details, making it harder to extend or test.
3. There’s no abstraction to allow for flexible behavior or appearance changes.

# CORRECT IMPLEMENTATION

Step 1: Create Abstractions
Define abstractions for styles and icons to decouple CustomFAB from their implementations.

```
abstract class FABStyle {
  Color getBackgroundColor(BuildContext context);
}

class DefaultFABStyle implements FABStyle {
  @override
  Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).colorScheme.secondaryContainer;
  }
}
```

For icons:

```
abstract class FABIconStrategy {
  Icon buildIcon();
}

class AddFABIconStrategy implements FABIconStrategy {
  @override
  Icon buildIcon() => Icon(Icons.add);
}

class ReturnFABIconStrategy implements FABIconStrategy {
  @override
  Icon buildIcon() => Icon(Icons.keyboard_return);
}
```

Step 2: Modify the CustomFAB Widget
Inject dependencies through the constructor, allowing the widget to work with abstractions.

```
class CustomFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final FABStyle style;
  final FABIconStrategy iconStrategy;

  CustomFAB({
    required this.onPressed,
    required this.style,
    required this.iconStrategy,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: iconStrategy.buildIcon(),
      backgroundColor: style.getBackgroundColor(context),
    );
  }
}
```

Step 3: Use CustomFAB with Abstractions
Now, CustomFAB can work with any implementation of FABStyle or FABIconStrategy.

```
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Default FAB
          CustomFAB(
            onPressed: () => print("Default FAB pressed"),
            style: DefaultFABStyle(),
            iconStrategy: AddFABIconStrategy(),
          ),
          SizedBox(height: 16),
          // Themed FAB with custom icon strategy
          CustomFAB(
            onPressed: () => print("Return FAB pressed"),
            style: DefaultFABStyle(),
            iconStrategy: ReturnFABIconStrategy(),
          ),
        ],
      ),
    );
  }
}
```

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
