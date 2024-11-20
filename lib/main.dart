import 'package:flutter/material.dart';
import 'package:flutter_realm/screens/calendar_viewer.dart';
import 'package:flutter_realm/screens/docked_calendar.dart';

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
          ],
        ),
      ),
    );
  }
}
