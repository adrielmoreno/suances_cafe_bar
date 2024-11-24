import 'package:flutter/material.dart';

import '../localization/localization_manager.dart';

enum PaymentMethod {
  cash,
  card,
  bankTransfer;

  IconData get getIconData => switch (this) {
        cash => Icons.money_outlined,
        card => Icons.credit_card_outlined,
        bankTransfer => Icons.account_balance_outlined,
      };

  String get getName => switch (this) {
        cash => text.label_cash,
        card => text.label_card,
        bankTransfer => text.transfer,
      };
}
