import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_realm/presentation/theme/app_typography.dart';

class TextFieldWithActionTile extends StatefulWidget {
  final int? maxLength;

  final String? errorText;
  final String hintText;
  final String? initialValue;

  final bool clearOnSubmit;

  final Future<void> Function(String) onCompleted;

  final Widget? leading;

  final IconData? icon;

  final FocusNode? focusNode;

  final TextInputType? keyboardType;

  const TextFieldWithActionTile({
    super.key,
    this.focusNode,
    required this.hintText,
    required this.onCompleted,
    this.clearOnSubmit = true,
    this.errorText,
    this.initialValue,
    this.icon,
    this.keyboardType,
    this.maxLength,
    this.leading,
  });

  @override
  TextFieldWithActionTileState createState() => TextFieldWithActionTileState();
}

class TextFieldWithActionTileState extends State<TextFieldWithActionTile> {
  late TextEditingController _controller;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _text = widget.initialValue ?? '';
    _controller = TextEditingController(text: _text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onSubmitted() async {
    try {
      await widget.onCompleted(_text);

      if (widget.clearOnSubmit) {
        _controller.clear();
        setState(() {
          _text = '';
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: widget.icon != null
          ? Padding(
              padding: EdgeInsets.only(bottom: 24.sp),
              child: Icon(
                widget.icon,
                color: theme.colorScheme.primary,
              ),
            )
          : widget.leading,
      title: TextField(
        buildCounter: (
          context, {
          required currentLength,
          required isFocused,
          required maxLength,
        }) {
          if (widget.maxLength == null) return null;

          return Align(
            alignment: Alignment.topLeft,
            child: Text(
              '$currentLength / $maxLength',
              style: TextStyle(
                fontSize: 12.sp,
                color: theme.colorScheme.onSurface,
              ),
            ),
          );
        },
        keyboardType: widget.keyboardType,
        maxLength: widget.maxLength,
        controller: _controller,
        focusNode: widget.focusNode,
        autofocus: true,
        decoration: InputDecoration.collapsed(
          hintStyle:
              AppText.titleMedium.copyWith(color: theme.colorScheme.outline),
          hintText: widget.hintText,
          border: InputBorder.none,
        ),
        style: AppText.titleMediumSemiBold
            .copyWith(color: theme.colorScheme.onSurface),
        onChanged: (value) {
          setState(() {
            _text = value.trim();
          });
        },
        onSubmitted: (value) {
          if (_text.isNotEmpty) {
            onSubmitted();
          }
        },
      ),
      subtitle: widget.errorText != null
          ? Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Text(
                widget.errorText!,
                style: AppText.labelSmallSemiBold.copyWith(
                    fontFamily: 'Roboto', color: theme.colorScheme.error),
              ),
            )
          : null,
      trailing: IconButton(
        icon: Icon(
          Icons.keyboard_return,
          color:
              theme.colorScheme.primary.withOpacity(_text.isNotEmpty ? 1 : 0.5),
        ),
        onPressed: _text.isNotEmpty ? onSubmitted : null,
      ),
    );
  }
}
