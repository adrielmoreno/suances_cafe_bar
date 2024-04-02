import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class InputPhone extends StatelessWidget {
  const InputPhone({
    super.key,
    required this.phoneController,
    this.onChanged,
    required this.enabled,
  });

  final TextEditingController phoneController;
  final Function(PhoneNumber)? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      countries: const ['ES'],
      hintText: 'Teléfono de contacto',
      errorMessage: 'Teléfono inválido',
      keyboardType: TextInputType.number,
      textFieldController: phoneController,
      isEnabled: enabled,
      onInputChanged: onChanged,
    );
  }
}
