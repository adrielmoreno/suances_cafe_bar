import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'Suances';

  @override
  String get contactName => 'Contact name';

  @override
  String get edit => 'Edit';

  @override
  String get errorEmpty => 'Cannot be empty';

  @override
  String get errorName => 'Enter a name';

  @override
  String get errorPhone => 'Invalid phone';

  @override
  String get lastPrice => '€ U+IVA';

  @override
  String get lastSupplier => 'Last supplier';

  @override
  String get measure => 'Measure';

  @override
  String get name => 'Name';

  @override
  String get newProduct => 'New product';

  @override
  String get newSupplier => 'New supplier';

  @override
  String get newTask => 'New task';

  @override
  String get packaging => 'Packaging';

  @override
  String get phone => 'Contact phone';

  @override
  String get pricePacking => '€ Price';

  @override
  String get priceUnit => '€ Unit';

  @override
  String get product => 'Product';

  @override
  String get productName => 'Product name';

  @override
  String get products => 'Products';

  @override
  String get save => 'Save';

  @override
  String get search => 'Search';

  @override
  String get supplier => 'Supplier';

  @override
  String get supplierName => 'Supplier name';

  @override
  String get suppliers => 'Suppliers';

  @override
  String get todos => 'ToDos';

  @override
  String get orders => 'Orders';

  @override
  String get type => 'Type';

  @override
  String get iva => '％ IVA';

  @override
  String get consumer => 'Consumable';

  @override
  String get food => 'Food';

  @override
  String get drink => 'Drink';

  @override
  String get taxes => 'Taxes';

  @override
  String get meats => 'Meats';

  @override
  String get ice_cream => 'Ice cream';

  @override
  String get utilities => 'Supplies';

  @override
  String get services => 'Services';

  @override
  String get no_supplier => 'No supplier';

  @override
  String get incomes => 'Incomes';

  @override
  String get expenses => 'Expenses';

  @override
  String get transaction => 'Transactions';

  @override
  String month_format(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMM(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get new_income => 'New income';

  @override
  String get new_expense => 'New expense';

  @override
  String get label_cash => 'Cash';

  @override
  String get label_card => 'Card';

  @override
  String get label_total => 'Total';

  @override
  String get label_date => 'Date';

  @override
  String get no_image => 'No image selected.';

  @override
  String get income_saved => 'Income saved successfully';

  @override
  String get maintenance => 'Maintenance';

  @override
  String get rent => 'Rent';

  @override
  String get salaries => 'Salaries';

  @override
  String get marketing => 'Marketing';

  @override
  String get transfer => 'Transfer';

  @override
  String get expense_saved => 'Expense saved successfully';

  @override
  String get category => 'Category';

  @override
  String get payment_method => 'Payment method';

  @override
  String get description => 'Description';

  @override
  String get income_trend => 'Income Trend';

  @override
  String get income_and_expenses_by_month => 'Income and Expenses by Month';

  @override
  String get expenses_by_category => 'Expenses by Category';

  @override
  String get payment_methods_expenses => 'Payment Methods - Expenses';

  @override
  String formattedAmount(double amount) {
    final intl.NumberFormat amountNumberFormat = intl.NumberFormat.currency(
      locale: localeName,
      decimalDigits: 2,
      name: 'USD',
      symbol: '\$',
      customPattern: '¤#,##0.00'
    );
    final String amountString = amountNumberFormat.format(amount);

    return '$amountString';
  }

  @override
  String formattedAmountChart(double amount) {
    final intl.NumberFormat amountNumberFormat = intl.NumberFormat.currency(
      locale: localeName,
      decimalDigits: 0,
      name: 'USD',
      symbol: '\$',
      customPattern: '¤#,##0'
    );
    final String amountString = amountNumberFormat.format(amount);

    return '$amountString';
  }

  @override
  String get average_daily_income_expenses => 'Average Daily Income and Expenses';
}
