import 'package:flutter/material.dart';

class ColorGridWidget extends StatefulWidget {
  final int highlightedIndex;
  final ValueChanged<int> onColorSelected;

  ColorGridWidget(
      {required this.highlightedIndex, required this.onColorSelected});

  @override
  _ColorGridState createState() => _ColorGridState();
}

class _ColorGridState extends State<ColorGridWidget> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        childAspectRatio: 1.0,
      ),
      itemCount: colorHexes.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            widget.onColorSelected(index);
          },
          child: Container(
            height: 32,
            width: 32,
            margin: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Color(
                  int.parse(colorHexes[index].substring(1, 7), radix: 16) +
                      0xFF000000),
              border: Border.all(
                color: widget.highlightedIndex == index
                    ? Color(0xFFB3C2E5)
                    : Colors.transparent,
                width: 5.0,
              ),
            ),
          ),
        );
      },
    );
  }
}

List<String> colorHexes = [
  '#3366CC',
  '#3333CC',
  '#33B2CC',
  '#33CC9F',
  '#33CCBA',
  '#80CC33',
  '#5BCC33',
  '#C9CC33',
  '#CCBC33',
  '#CCA633',
  '#CC8E33',
  '#CC7533',
  '#CC5833',
  '#CC3333',
  '#CC3380',
  '#A233CC'
];