import 'package:flutter/material.dart';

import '../localization/localization_manager.dart';

enum TypeOfSupplier {
  consumer,
  food,
  drink,
  taxes,
  meats,
  ice_cream,
  utilities,
  services;

  IconData get getIconData => switch (this) {
        consumer => Icons.miscellaneous_services_outlined,
        food => Icons.fastfood_outlined,
        drink => Icons.liquor_outlined,
        taxes => Icons.attach_money,
        meats => Icons.food_bank_outlined,
        ice_cream => Icons.icecream_outlined,
        utilities => Icons.lightbulb_outline,
        services => Icons.room_service_outlined,
      };

  String get getName => switch (this) {
        consumer => text.consumer,
        food => text.food,
        drink => text.drink,
        taxes => text.taxes,
        meats => text.meats,
        ice_cream => text.ice_cream,
        utilities => text.utilities,
        services => text.services,
      };
}
