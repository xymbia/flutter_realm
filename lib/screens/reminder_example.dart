import 'package:flutter/material.dart';
import 'package:flutter_realm/models/task_reminder.dart';
import 'package:flutter_realm/presentation/theme/app.dart';
import 'package:flutter_realm/widgets/reminder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({
    super.key,
  });

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  TaskReminder newReminder = TaskReminder();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    ScreenUtil.init(context, designSize: const Size(390, 848));

    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder Dialog'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: ReminderModelContent(
                          reminder: newReminder,
                          onChanged: (value) {
                            setState(() {
                              newReminder = value!;
                            });
                          },
                        ),
                      );
                    });
              },
              child: Text('Create Reminder'),
            ),
            Text(
              'Current Reminder: $newReminder',
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
