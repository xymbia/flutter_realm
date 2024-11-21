import 'package:flutter/material.dart';
import 'package:flutter_realm/presentation/theme/app.dart';
import 'package:flutter_realm/widgets/docked_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DockerdCalendarPage extends StatefulWidget {
  const DockerdCalendarPage({
    super.key,
  });

  @override
  State<DockerdCalendarPage> createState() => _DockerdCalendarPageState();
}

class _DockerdCalendarPageState extends State<DockerdCalendarPage> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    await showDockedDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      onChanged: (date) {
        setState(() {
          _selectedDate = date;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    ScreenUtil.init(context, designSize: const Size(390, 848));
    return Scaffold(
      appBar: AppBar(
        title: Text('Dockerd Calendar'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedDate == null
                  ? 'No date selected'
                  : 'Selected Date: ${DateFormat('MMMM d, yyyy').format(_selectedDate!)}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select Date'),
            ),
          ],
        ),
      ),
    );
  }
}
