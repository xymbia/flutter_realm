import 'package:flutter/material.dart';
import 'package:flutter_realm/presentation/theme/app.dart';
import 'package:flutter_realm/widgets/switch_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwitchTilePage extends StatefulWidget {
  const SwitchTilePage({
    super.key,
  });

  @override
  State<SwitchTilePage> createState() => _SwitchTilePageState();
}

class _SwitchTilePageState extends State<SwitchTilePage> {
  bool switchValue = true;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    ScreenUtil.init(context, designSize: const Size(390, 848));

    return Scaffold(
      appBar: AppBar(
        title: const Text('SwitchTile'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchTile(
              leadingIcon: Icons.notification_add,
              value: switchValue,
              onChanged: (value) {
                setState(() {
                  switchValue = value;
                });
              },
              title: 'In-App',
            ),
            Text(
              'Current Switch value: $switchValue',
              style: const TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
