import 'package:flutter/material.dart';

import '../../localization/app_localizations.dart';
import '../../theme/constants/dimens.dart';
import '../buttons/custom_icon_button.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required this.focusNode,
    this.hint,
    this.onClear,
    this.onSearch,
    this.onChanged,
    this.controller,
  });

  final FocusNode focusNode;
  final String? hint;
  final void Function()? onClear;
  final void Function()? onSearch;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme;
    final text = AppLocalizations.of(context)!;
    return SearchBar(
      controller: controller,
      focusNode: focusNode,
      hintText: hint ?? text.search,
      onChanged: onChanged,
      leading: CustomIconButton(
        iconData: Icons.cancel_outlined,
        onTap: onClear,
      ),
      trailing: [
        Container(
          decoration: BoxDecoration(
            color: themeColor.primary,
            borderRadius: BorderRadius.circular(Dimens.semiBig),
          ),
          child: CustomIconButton(
            iconData: Icons.search_outlined,
            size: Dimens.semiBig,
            color: themeColor.onSecondary,
            onTap: onSearch,
          ),
        ),
      ],
    );
  }
}
