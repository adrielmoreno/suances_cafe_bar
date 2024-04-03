import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class LocalDates {
  static String getCurrency() {
    final country = PlatformDispatcher.instance.locale;
    final currency =
        NumberFormat.simpleCurrency(locale: '$country').currencySymbol;
    return currency;
  }
}
