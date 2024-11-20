import 'package:flutter/material.dart';

import '../../localization/localization_manager.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String hintText;
  final bool readOnly;
  final bool enabled;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;

  final Function()? onTap;
  final Widget? prefixIcon;

  const CustomTextFormField({
    super.key,
    this.controller,
    required this.labelText,
    this.hintText = "",
    this.readOnly = false,
    this.enabled = true,
    this.keyboardType,
    this.onChanged,
    this.onTap,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return text.errorEmpty;
        }

        return null;
      },
      onTap: onTap,
    );
  }
}
