import 'package:flutter/material.dart';

import '../../extensions/widget_extensions.dart';
import '../../theme/constants/app_colors.dart';
import '../../theme/constants/dimens.dart';

class ItemDrawerButton extends StatefulWidget {
  final IconData iconData;
  final VoidCallback onTap;
  final Color? color;
  final String text;

  const ItemDrawerButton({
    super.key,
    required this.iconData,
    required this.onTap,
    this.color,
    required this.text,
  });

  @override
  State<ItemDrawerButton> createState() => _ItemDrawerButtonState();
}

class _ItemDrawerButtonState extends State<ItemDrawerButton> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Container(
        color: isHovered ? widget.color?.withOpacity(0.2) : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(left: Dimens.medium),
          child: ListTile(
            leading: Icon(widget.iconData,
                color: widget.color ?? AppColors.onPrimaryLight),
            title: Text(
              widget.text.capitalize(),
              style: TextStyle(color: widget.color ?? AppColors.onPrimaryLight),
            ),
            onTap: widget.onTap,
          ),
        ),
      ),
    );
  }
}
