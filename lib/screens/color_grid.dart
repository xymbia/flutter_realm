import 'package:flutter/material.dart';
import 'package:flutter_realm/presentation/theme/app.dart';
import 'package:flutter_realm/widgets/color_grid.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColorGridPage extends StatefulWidget {
  const ColorGridPage({
    super.key,
  });

  @override
  State<ColorGridPage> createState() => _ColorGridPageState();
}

class _ColorGridPageState extends State<ColorGridPage> {
  int selectedColorIndex = 1;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    ScreenUtil.init(context, designSize: const Size(390, 848));

    return Scaffold(
      appBar: AppBar(
        title: Text('Color Grid'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorGridWidget(
              highlightedIndex: selectedColorIndex,
              onColorSelected: (index) {
                setState(() {
                  selectedColorIndex = index;
                });
              },
            ),
            Text(
              'Selected Color: $selectedColorIndex',
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
