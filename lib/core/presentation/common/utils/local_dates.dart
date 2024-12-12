import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../localization/localization_manager.dart';

class LocalDates {
  static final locale = PlatformDispatcher.instance.locale;

  static String getCurrency() {
    final currency =
        NumberFormat.simpleCurrency(locale: '$locale').currencySymbol;
    return currency;
  }

  static String dateFormated(DateTime date) {
    final dateFormat = DateFormat('dd/MM', '$locale').format(date);
    return dateFormat;
  }

  static String dayKeyFromWeekday(int weekday) {
    final days = [
      text.day_monday_short,
      text.day_tuesday_short,
      text.day_wednesday_short,
      text.day_thursday_short,
      text.day_friday_short,
      text.day_saturday_short,
      text.day_sunday_short,
    ];

    if (weekday < 1 || weekday > 7) {
      throw ArgumentError("Invalid weekday: $weekday");
    }
    return days[weekday - 1];
  }

  static DateTime parseFromString(String dateString) {
    try {
      return DateFormat('dd/MM/yyyy').parseStrict(dateString);
    } catch (_) {
      return DateFormat('dd-MM-yyyy').parseStrict(dateString);
    }
  }
}
