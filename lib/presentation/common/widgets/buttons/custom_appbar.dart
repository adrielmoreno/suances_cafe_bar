import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.showBack = false,
    this.actions,
  });
  final String? title;
  final bool? showBack;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 50,
      leading: showBack! ? const BackButton() : null,
      title: Text(title ?? ''),
      actions: actions,
      centerTitle: true,
    );
  }
}
