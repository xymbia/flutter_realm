import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/custom_date_picker_widget.dart';

class DatePickerPage extends StatefulWidget {
  const DatePickerPage({Key? key}) : super(key: key);

  @override
  State<DatePickerPage> createState() => _DatePickerPageState();
}

class _DatePickerPageState extends State<DatePickerPage> {
  bool isSingleDateMode = true;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 848));

    return Scaffold(
      appBar: AppBar(
        title: const Text('DatePicker'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
                width: 0.4.sw,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Text(isSingleDateMode == true
                            ? 'Single Mode'
                            : 'Range Mode')),
                    const SizedBox(width: 4),
                    Switch(
                      value: isSingleDateMode,
                      onChanged: (value) {
                        setState(() {
                          isSingleDateMode = value;
                        });
                      },
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomDatePickerWidget(
                initialSingleMode: isSingleDateMode,
                onSingleDateSelected: (date) {
                  // Example: show selected date in a snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Selected: 	${date.toLocal()}')),
                  );
                },
                onRangeSelected: (start, end) {
                  // Example: show selected range in a snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Range: ${start?.toLocal()} - ${end?.toLocal()}')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
