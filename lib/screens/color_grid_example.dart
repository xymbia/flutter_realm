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
  String? selectedColor;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    ScreenUtil.init(context, designSize: const Size(390, 848));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Grid'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorGrid(
              value: selectedColor,
              onChanged: (value) {
                setState(() {
                  selectedColor = value;
                });
              },
            ),
            Text(
              'Selected Color: $selectedColor',
              style: const TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}


// ColorGrid ColorGrid({required String? value, required void Function(String) onChanged})