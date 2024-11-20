import 'package:flutter/material.dart';
import 'package:flutter_realm/screens/calendar_viewer_example.dart';
import 'package:flutter_realm/screens/color_grid_example.dart';
import 'package:flutter_realm/screens/docked_calendar_example.dart';
import 'package:flutter_realm/screens/link_example.dart';
import 'package:flutter_realm/screens/switch_tile_example.dart';
import 'package:flutter_realm/screens/reminder_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Widget Library'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.touch_app),
              title: const Text('Docked Calendar'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DockerdCalendarPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.touch_app),
              title: const Text('Calendar Viewer'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CalendarViewerPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.touch_app),
              title: const Text('Color Grid'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ColorGridPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.touch_app),
              title: const Text('Reminder Dialog'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReminderPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.touch_app),
              title: const Text('Link Dialog'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LinkPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.touch_app),
              title: const Text('Switch Tile'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SwitchTilePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
