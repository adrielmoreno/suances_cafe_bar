import 'package:flutter/material.dart';

import '../../theme/constants/app_colors.dart';
import '../../theme/constants/dimens.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.iconData,
    this.onTap,
    this.size,
    this.color,
  });
  final IconData iconData;
  final void Function()? onTap;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        color: color ?? AppColors.shadowLight,
        iconData,
        size: size ?? Dimens.semiBig,
      ),
    );
  }
}
