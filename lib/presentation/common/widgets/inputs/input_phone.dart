import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../localization/app_localizations.dart';

class InputPhone extends StatelessWidget {
  const InputPhone({
    super.key,
    required this.phoneController,
    this.onChanged,
    required this.enabled,
    required this.number,
  });

  final TextEditingController phoneController;
  final Function(PhoneNumber)? onChanged;
  final bool enabled;
  final PhoneNumber number;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return InternationalPhoneNumberInput(
      countries: const ['ES'],
      hintText: text.phone,
      errorMessage: text.errorPhone,
      initialValue: number,
      keyboardType: TextInputType.number,
      textFieldController: phoneController,
      isEnabled: enabled,
      onInputChanged: onChanged,
    );
  }
}
