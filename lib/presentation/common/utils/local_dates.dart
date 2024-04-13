import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

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
}
