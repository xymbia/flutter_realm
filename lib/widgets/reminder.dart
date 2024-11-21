import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_realm/models/task_reminder.dart';
import 'package:flutter_realm/widgets/shared/custom_dropdown_with_dividers.dart';
import 'package:flutter_realm/widgets/shared/text_checkbox_tile.dart';
import 'package:flutter_realm/widgets/shared/custom_bordered_textfield.dart';
import 'package:flutter_realm/presentation/theme/app_typography.dart';
import 'package:flutter_realm/presentation/theme/app_typography_ext.dart';
import 'package:flutter_realm/presentation/theme/space.dart';
import 'package:flutter_realm/utils/repeat_util.dart';

class ReminderModelContent extends StatefulWidget {
  final TaskReminder reminder;
  final void Function(TaskReminder?) onChanged;
  const ReminderModelContent({
    super.key,
    required this.reminder,
    required this.onChanged,
  });

  @override
  State<ReminderModelContent> createState() => _ReminderModelContentState();
}

class _ReminderModelContentState extends State<ReminderModelContent> {
  late TaskReminder _reminder;

  @override
  void initState() {
    super.initState();
    _reminder = widget.reminder;
    _intervalController =
        TextEditingController(text: _reminder.interval?.toString() ?? '10');

    _intervalController.addListener(() {
      setState(() {
        _reminder.interval = int.parse(_intervalController.text);
      });
      widget.onChanged(_reminder);
    });
  }

  late TextEditingController _intervalController;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomBorderedTextField(
                controller: _intervalController,
                isEnabled: true,
                onChanged: (value) {},
              ),
              Space.xf(16),
              CustomDropDownWithDividers(
                width: 100.w,
                items: RepeatUtils.duration,
                value: _reminder.duration ?? RepeatUtils.duration[0],
                onChanged: (value) {
                  setState(() {
                    _reminder.duration = value;
                  });
                  widget.onChanged(_reminder);
                },
              ),
              Space.xf(16),
              Text(
                'before',
                style: AppText.bodyLarge.cl(colorScheme.onSurface),
              ),
            ],
          ),
          Space.yf(24),
          TextCheckboxWidget(
            text: 'As notification',
            isChecked:
                _reminder.reminderType?.contains('NOTIFICATION') ?? false,
            onChanged: (value) {
              if (value ?? false) {
                if (!(_reminder.reminderType?.contains('NOTIFICATION') ??
                    false)) {
                  setState(() {
                    _reminder.reminderType != null
                        ? _reminder.reminderType!.add('NOTIFICATION')
                        : _reminder.reminderType = ['NOTIFICATION'];
                  });
                }
              } else {
                setState(() {
                  _reminder.reminderType?.remove('NOTIFICATION');
                });
              }
              widget.onChanged(_reminder);
            },
          ),
          TextCheckboxWidget(
            text: 'As email',
            isChecked: _reminder.reminderType?.contains('EMAIL') ?? false,
            onChanged: (value) {
              if (value ?? false) {
                if (!(_reminder.reminderType?.contains('EMAIL') ?? false)) {
                  setState(() {
                    _reminder.reminderType != null
                        ? _reminder.reminderType!.add('EMAIL')
                        : _reminder.reminderType = ['EMAIL'];
                  });
                }
              } else {
                setState(() {
                  _reminder.reminderType?.remove('EMAIL');
                });
              }
              widget.onChanged(_reminder);
            },
          ),
        ],
      ),
    );
  }
}
