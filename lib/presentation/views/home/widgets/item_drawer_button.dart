import 'package:flutter/material.dart';

class ItemDrawerButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onTap;
  final Color? color;

  const ItemDrawerButton({
    super.key,
    required this.iconData,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(iconData, color: color ?? Colors.black),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
