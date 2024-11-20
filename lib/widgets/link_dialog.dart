import 'package:flutter/material.dart';
import 'package:flutter_realm/models/task_link.dart';
import 'package:flutter_realm/presentation/theme/app_typography.dart';
import 'package:flutter_realm/presentation/theme/app_typography_ext.dart';
import 'package:flutter_realm/presentation/theme/space.dart';
import 'package:flutter_realm/utils/string_ext.dart';

class LinkDialog extends StatefulWidget {
  const LinkDialog({
    Key? key,
    required this.onSubmitted,
    this.title = 'Edit Link',
  }) : super(key: key);

  final String title;
  final Function(TaskLink) onSubmitted;

  @override
  State<LinkDialog> createState() => LinkDialogState();
}

class LinkDialogState extends State<LinkDialog> {
  TextEditingController _textController = TextEditingController();
  TextEditingController _urlController = TextEditingController();

  bool _isValid = true;

  void _validateUrl(String url) {
    _isValid = url.validateUrl(url);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: Space.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: AppText.headlineSmall,
            ),
            Space.yf(24),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                contentPadding: Space.hf(16),
                labelText: 'Text to display',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelStyle: AppText.bodyMedium.cl(colorScheme.primary),
              ),
            ),
            Space.yf(36),
            TextField(
              controller: _urlController,
              onChanged: _validateUrl,
              decoration: InputDecoration(
                contentPadding: Space.hf(16),
                labelText: 'Link',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelStyle: AppText.bodyMedium
                    .cl(_isValid ? colorScheme.primary : colorScheme.error),
                errorText: _isValid ? null : 'Invalid URL',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: _isValid ? colorScheme.primary : colorScheme.error,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: _isValid ? colorScheme.primary : colorScheme.error,
                  ),
                ),
              ),
            ),
            Space.yf(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text(
                    'Cancel',
                    style: AppText.labelLargeSemiBold.cl(colorScheme.primary),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Space.xf(8),
                TextButton(
                  child: Text(
                    'Save',
                    style: AppText.labelLargeSemiBold.cl(
                      _isValid && _urlController.text.isNotEmpty
                          ? colorScheme.primary
                          : colorScheme.onSurface.withOpacity(0.38),
                    ),
                  ),
                  onPressed: () {
                    String text = _textController.text.trim();
                    String url = _urlController.text.trim();
                    widget.onSubmitted(TaskLink(text: text, link: url));
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
