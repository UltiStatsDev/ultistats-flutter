import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';

class FormTile extends StatelessWidget {
  const FormTile({
    super.key,
    required this.controller,
    required this.title,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onSubmitted,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String title;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: theme.textTheme.displayMedium),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: theme.textFieldHeight,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(theme.textFieldBorderRadius),
          ),
          child: TextField(
            controller: controller,
            style: theme.textFieldStyleText,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            autofillHints: autofillHints,
            onSubmitted: onSubmitted,
            enabled: enabled,
            autocorrect: !obscureText,
            enableSuggestions: !obscureText,
            decoration: InputDecoration(hintText: hint),
          ),
        ),
      ],
    );
  }
}
