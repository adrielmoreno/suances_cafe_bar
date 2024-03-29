import 'package:intl/intl.dart';

class LocalDates {
  static String getCurrency() {
    // final country = PlatformDispatcher.instance.locale.countryCode;

    final currency = NumberFormat.simpleCurrency(locale: 'ES').currencySymbol;
    return currency;
  }
}
