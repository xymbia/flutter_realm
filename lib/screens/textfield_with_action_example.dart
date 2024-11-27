import 'package:flutter/material.dart';
import 'package:flutter_realm/presentation/theme/app.dart';
import 'package:flutter_realm/widgets/textfield_with_action.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFieldPage extends StatefulWidget {
  const TextFieldPage({
    super.key,
  });

  @override
  State<TextFieldPage> createState() => _TextFieldPageState();
}

class _TextFieldPageState extends State<TextFieldPage> {
  String? textFieldValue;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    ScreenUtil.init(context, designSize: const Size(390, 848));

    return Scaffold(
      appBar: AppBar(
        title: const Text('TextField With Button'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFieldWithActionTile(
                initialValue: textFieldValue,
                hintText: 'Enter Task name',
                keyboardType: TextInputType.text,
                onCompleted: (value) async {
                  setState(() {
                    textFieldValue = value;
                  });
                }),
            Text(
              'Current text field value: $textFieldValue',
              style: const TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
