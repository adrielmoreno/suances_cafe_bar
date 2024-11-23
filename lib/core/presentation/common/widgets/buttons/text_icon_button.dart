import 'package:flutter/material.dart';

import '../../theme/constants/dimens.dart';

class TextIconButton extends StatelessWidget {
  const TextIconButton({
    super.key,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.onPressed,
    required this.iconData,
    required this.label,
  });

  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final void Function()? onPressed;
  final IconData iconData;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        iconData,
        weight: Dimens.medium,
      ),
      label: Text(
        label,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: Dimens.medium),
      ),
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor ?? color.primary,
        iconColor: iconColor ?? color.onSecondary,
        foregroundColor: textColor ?? color.onSecondary,
      ),
    );
  }
}
