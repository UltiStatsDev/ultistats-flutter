import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';

class FormTile extends StatelessWidget {
  const FormTile({
    super.key,
    required this.controller,
    required this.title,
    required this.hint,
  });

  final TextEditingController controller;
  final String title;
  final String hint;

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
            decoration: InputDecoration(hintText: hint),
          ),
        ),
      ],
    );
  }
}
