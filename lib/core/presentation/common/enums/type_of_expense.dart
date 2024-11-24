import 'package:flutter/material.dart';

import '../localization/localization_manager.dart';

enum TypeOfExpense {
  food,
  beverages,
  utilities,
  maintenance,
  rent,
  salaries,
  marketing,
  supplies,
  taxes;

  IconData get getIconData => switch (this) {
        food => Icons.fastfood_outlined,
        beverages => Icons.local_drink_outlined,
        utilities => Icons.lightbulb_outline,
        maintenance => Icons.build_outlined,
        rent => Icons.house_outlined,
        salaries => Icons.person_outline,
        marketing => Icons.campaign_outlined,
        supplies => Icons.inventory_outlined,
        taxes => Icons.attach_money_outlined,
      };

  String get getName => switch (this) {
        food => text.food,
        beverages => text.drink,
        utilities => text.utilities,
        maintenance => text.maintenance,
        rent => text.rent,
        salaries => text.salaries,
        marketing => text.marketing,
        supplies => text.suppliers,
        taxes => text.taxes,
      };
}
