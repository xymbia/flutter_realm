import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_realm/presentation/theme/app.dart';
import 'package:flutter_realm/presentation/theme/configs.dart';

class CustomBorderedTextField extends StatelessWidget {
  const CustomBorderedTextField({
    super.key,
    required TextEditingController controller,
    required Function(String) onChanged,
    FocusNode? focusNode,
    bool isEnabled = true,
  })  : _controller = controller,
        _focusNode = focusNode,
        _isEnabled = isEnabled,
        _onChanged = onChanged;

  final TextEditingController _controller;
  final FocusNode? _focusNode;

  final bool _isEnabled;

  final Function(String) _onChanged;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 60.w,
      height: 36.h,
      padding: Space.all(16, 6),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline),
        borderRadius: UIProps.radiusS,
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: _isEnabled,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        textAlign: TextAlign.center,
        style: AppText.labelLargeSemiBold.cl(colorScheme.onSurface),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3),
        ],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          isDense: true,
          border: InputBorder.none,
          hintText: '3',
          hintStyle: AppText.labelLargeSemiBold.cl(colorScheme.onSurface),
        ),
        onChanged: _onChanged,
      ),
    );
  }
}
