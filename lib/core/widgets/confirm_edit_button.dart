import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/app_ink_well.dart';

class ConfirmEditButton extends StatelessWidget {
  const ConfirmEditButton({super.key, required this.confirmButtonText, required this.onTap});

  final String confirmButtonText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppInkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(theme.cardBorderRadius),
      child: Ink(
        height: theme.textFieldHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            theme.textFieldBorderRadius,
          ),
          color: theme.colorScheme.primaryContainer,
        ),
        child: Center(
          child: Text(
            confirmButtonText,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
