import 'package:flutter/material.dart';
import 'package:flutter_realm/models/task_link.dart';
import 'package:flutter_realm/presentation/theme/app.dart';
import 'package:flutter_realm/widgets/link_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LinkPage extends StatefulWidget {
  const LinkPage({
    super.key,
  });

  @override
  State<LinkPage> createState() => _LinkPageState();
}

class _LinkPageState extends State<LinkPage> {
  TaskLink newLink = TaskLink();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    ScreenUtil.init(context, designSize: const Size(390, 848));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Link Dialog'),
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
                      return LinkDialog(
                        onSubmitted: (link) {
                          setState(() {
                            newLink = link;
                          });
                        },
                      );
                    });
              },
              child: const Text('Create Link'),
            ),
            Text(
              'Current Link: $newLink',
              style: const TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
