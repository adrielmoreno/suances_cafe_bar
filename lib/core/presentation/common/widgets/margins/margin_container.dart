import 'package:flutter/material.dart';

import '../../theme/constants/dimens.dart';

class MarginContainer extends StatelessWidget {
  const MarginContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: Dimens.medium,
        vertical: Dimens.small,
      ),
      child: child,
    );
  }
}
