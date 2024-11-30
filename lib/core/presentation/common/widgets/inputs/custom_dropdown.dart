import 'package:flutter/material.dart';

import '../../theme/constants/dimens.dart';

class CustomDropDown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String labelText;
  final String Function(T) getItemLabel;
  final IconData Function(T)? getItemIcon;
  final ValueChanged<T?> onChanged;
  final bool enabled;

  const CustomDropDown({
    super.key,
    required this.value,
    required this.items,
    required this.labelText,
    required this.getItemLabel,
    this.getItemIcon,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return DropdownButtonFormField<T>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          enabled: enabled,
          child: Row(
            children: [
              if (getItemIcon != null)
                Padding(
                  padding: const EdgeInsets.all(Dimens.small),
                  child: Icon(
                    getItemIcon!(item),
                    size: Dimens.medium,
                    color: color.primary,
                  ),
                ),
              Text(getItemLabel(item)),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(labelText: labelText),
    );
  }
}
