import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_realm/presentation/theme/app.dart';
import 'package:flutter_realm/presentation/theme/configs.dart';

class CustomDropDownWithDividers extends StatefulWidget {
  const CustomDropDownWithDividers({
    Key? key,
    this.width = 80,
    this.dividersAfter = const [],
    this.isEnabled = true,
    required String value,
    required List<String> items,
    required void Function(String) onChanged,
  })  : _value = value,
        _items = items,
        _onChanged = onChanged,
        super(key: key);

  final double width;
  final String _value;
  final bool isEnabled;
  final List<String> _items;
  final List<int> dividersAfter;
  final void Function(String) _onChanged;

  @override
  State<CustomDropDownWithDividers> createState() =>
      _CustomDropDownWithDividersState();
}

class _CustomDropDownWithDividersState
    extends State<CustomDropDownWithDividers> {
  late String _value;
  late int tempSelectedIndex;

  @override
  void initState() {
    super.initState();
    _value = widget._value;
    tempSelectedIndex = widget._items.indexOf(_value);
  }

  void _onChanged(int index) {
    setState(() {
      tempSelectedIndex = index;
      _value = widget._items[index];
    });
    widget._onChanged(_value);
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final colorScheme = Theme.of(context).colorScheme;

    return IgnorePointer(
      ignoring: !widget.isEnabled,
      child: Container(
        height: 36.h,
        width: widget.width,
        padding: Space.hf(11),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: colorScheme.outline),
          borderRadius: UIProps.radiusS,
        ),
        child: DropdownButton2(
          underline: SizedBox.shrink(),
          isExpanded: true,
          autofocus: false,
          value: _value,
          onChanged: (value) {
            int index = widget._items.indexWhere((element) => element == value);
            _onChanged(index);
          },
          menuItemStyleData: MenuItemStyleData(
            padding: EdgeInsets.zero,
          ),
          selectedItemBuilder: (context) {
            return widget._items.asMap().entries.map((entry) {
              return Center(
                child: Text(
                  entry.value,
                  style: AppText.labelLargeSemiBold.cl(colorScheme.primary),
                ),
              );
            }).toList();
          },
          items: _buildMenuItems(colorScheme),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildMenuItems(ColorScheme colorScheme) {
    List<DropdownMenuItem<String>> menuItems = [];

    for (int i = 0; i < widget._items.length; i++) {
      menuItems.add(
        DropdownMenuItem<String>(
          value: widget._items[i],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: Space.all(9, widget.dividersAfter.contains(i) ? 4 : 6),
                color: i == tempSelectedIndex
                    ? colorScheme.surfaceContainerHighest
                    : Colors.transparent,
                child: Text(
                  widget._items[i],
                  style: AppText.labelLargeSemiBold.cl(colorScheme.onSurface),
                ),
              ),
              if (widget.dividersAfter.contains(i))
                Divider(color: colorScheme.outline),
            ],
          ),
        ),
      );
    }

    return menuItems;
  }
}
