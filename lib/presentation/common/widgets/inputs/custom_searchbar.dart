import 'package:flutter/material.dart';

import '../../theme/constants/app_colors.dart';
import '../../theme/constants/dimens.dart';
import '../buttons/custom_icon_button.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required this.focusNode,
    this.hint,
  });

  final FocusNode focusNode;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      focusNode: focusNode,
      hintText: hint ?? 'Buscar',
      leading: CustomIconButton(
        iconData: Icons.cancel_outlined,
        onTap: () {},
      ),
      trailing: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(Dimens.semiBig),
          ),
          child: CustomIconButton(
            iconData: Icons.search_outlined,
            size: Dimens.semiBig,
            color: AppColors.onPrimaryLight,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
