import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_realm/presentation/theme/app_typography.dart';
import 'package:flutter_realm/presentation/theme/app_typography_ext.dart';
import 'package:flutter_realm/presentation/theme/space.dart';

class SwitchTile extends StatefulWidget {
  const SwitchTile({
    required this.value,
    required this.title,
    this.subtitle,
    required this.leadingIcon,
    required this.onChanged,
    this.onTap,
  });

  final bool value;

  final String title;

  final String? subtitle;

  final IconData leadingIcon;

  final void Function(bool) onChanged;

  final VoidCallback? onTap;

  @override
  State<SwitchTile> createState() => _SwitchTileState();
}

class _SwitchTileState extends State<SwitchTile> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      visualDensity: VisualDensity(horizontal: 2, vertical: 1),
      contentPadding: Space.hf(18),
      onTap: widget.onTap,
      leading: Icon(
        widget.leadingIcon,
        size: 24.sp,
        color: colorScheme.onSurfaceVariant,
      ),
      title: Text(
        widget.title,
        style: AppText.bodyLarge.cl(colorScheme.onSurface),
      ),
      subtitle: widget.subtitle != null
          ? Text(
              widget.subtitle!,
              style: AppText.bodyMedium.cl(colorScheme.onSurfaceVariant),
            )
          : null,
      trailing: Switch(
          value: _value,
          onChanged: (value) {
            setState(() {
              _value = value;
            });
            widget.onChanged(value);
          }),
    );
  }
}
