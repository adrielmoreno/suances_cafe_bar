import 'package:flutter/material.dart';

import '../../../../core/presentation/common/theme/constants/dimens.dart';

class AmountIconText extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;
  final String text;

  const AmountIconText({
    super.key,
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: backgroundColor,
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: Dimens.small),
          Text(text),
        ],
      ),
    );
  }
}
