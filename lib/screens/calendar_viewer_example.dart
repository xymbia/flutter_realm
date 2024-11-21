import 'package:flutter/material.dart';
import 'package:flutter_realm/presentation/theme/app.dart';
import 'package:flutter_realm/widgets/calendar_viewer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarViewerPage extends StatelessWidget {
  const CalendarViewerPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    App.init(context);
    ScreenUtil.init(context, designSize: const Size(390, 848));

    final List<DateTime> dateList = List.generate(
      10,
      (index) => DateTime.now().add(Duration(days: index)),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar Viewer'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                showCalendarViewer(context, DateTime.now(), dateList);
              },
              child: Text('View Calendar'),
            ),
          ],
        ),
      ),
    );
  }
}
