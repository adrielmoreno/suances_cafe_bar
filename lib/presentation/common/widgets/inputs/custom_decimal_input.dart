import 'package:flutter/material.dart';

import '../../localization/localization_manager.dart';

class CustomDecimalInput extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String hintText;
  final bool readOnly;

  final Function(String)? onChanged;

  final Function()? onTap;
  final Widget? prefixIcon;

  const CustomDecimalInput({
    super.key,
    this.controller,
    required this.labelText,
    this.hintText = "",
    this.readOnly = false,
    this.onChanged,
    this.onTap,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
      ),
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return text.errorEmpty;
        }
        if (double.tryParse(value) == null) {
          return 'Por favor, introduce un número válido';
        }
        return null;
      },
      onTap: onTap,
    );
  }
}
