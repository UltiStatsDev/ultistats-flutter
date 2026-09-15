import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultistats/core/themes/app_themes.dart';

class PlayerNumberDialog extends StatefulWidget {
  const PlayerNumberDialog({
    super.key,
    required this.firstName,
    required this.lastName,
  });

  final String firstName;
  final String lastName;

  @override
  State<PlayerNumberDialog> createState() => _PlayerNumberDialogState();

  static Future<int?> show({
    required BuildContext context,
    required String firstName,
    required String lastName,
  }) {
    return showDialog<int?>(
      context: context,
      builder: (context) =>
          PlayerNumberDialog(firstName: firstName, lastName: lastName),
    );
  }
}

class _PlayerNumberDialogState extends State<PlayerNumberDialog> {
  final _numberController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _numberController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    final text = _numberController.text.trim();
    setState(() {
      _isButtonEnabled = text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _numberController.removeListener(_updateButtonState);
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.cardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Игровой номер", style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              "Введите номер для игрока ${widget.firstName} ${widget.lastName}",
              style: theme.textTheme.labelMedium,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: theme.textFieldHeight,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.1,
                ),
                borderRadius: BorderRadius.circular(
                  theme.textFieldBorderRadius,
                ),
                border: Border.all(
                  color: theme.primaryColor.withValues(alpha: 0.2),
                ),
              ),
              child: TextField(
                controller: _numberController,
                keyboardType: TextInputType.number,
                autofocus: true,
                style: theme.textFieldStyleText,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                decoration: const InputDecoration(
                  hintText: "7",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Отмена",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: _isButtonEnabled
                      ? () {
                          final value = int.tryParse(_numberController.text);
                          if (value != null) {
                            Navigator.of(context).pop(value);
                          }
                        }
                      : null,
                  child: const Text("Добавить"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
