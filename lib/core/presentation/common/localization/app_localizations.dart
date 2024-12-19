import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'Suances'**
  String get app_title;

  /// No description provided for @contactName.
  ///
  /// In en, this message translates to:
  /// **'Contact name'**
  String get contactName;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @errorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Cannot be empty'**
  String get errorEmpty;

  /// No description provided for @errorName.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get errorName;

  /// No description provided for @errorPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone'**
  String get errorPhone;

  /// No description provided for @lastPrice.
  ///
  /// In en, this message translates to:
  /// **'€ U+IVA'**
  String get lastPrice;

  /// No description provided for @lastSupplier.
  ///
  /// In en, this message translates to:
  /// **'Last supplier'**
  String get lastSupplier;

  /// No description provided for @measure.
  ///
  /// In en, this message translates to:
  /// **'Measure'**
  String get measure;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @newProduct.
  ///
  /// In en, this message translates to:
  /// **'New product'**
  String get newProduct;

  /// No description provided for @newSupplier.
  ///
  /// In en, this message translates to:
  /// **'New supplier'**
  String get newSupplier;

  /// No description provided for @newTask.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get newTask;

  /// No description provided for @packaging.
  ///
  /// In en, this message translates to:
  /// **'Packaging'**
  String get packaging;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Contact phone'**
  String get phone;

  /// No description provided for @pricePacking.
  ///
  /// In en, this message translates to:
  /// **'€ Price'**
  String get pricePacking;

  /// No description provided for @priceUnit.
  ///
  /// In en, this message translates to:
  /// **'€ Unit'**
  String get priceUnit;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get productName;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @supplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get supplier;

  /// No description provided for @supplierName.
  ///
  /// In en, this message translates to:
  /// **'Supplier name'**
  String get supplierName;

  /// No description provided for @suppliers.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get suppliers;

  /// No description provided for @todos.
  ///
  /// In en, this message translates to:
  /// **'ToDos'**
  String get todos;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @iva.
  ///
  /// In en, this message translates to:
  /// **'％ IVA'**
  String get iva;

  /// No description provided for @consumer.
  ///
  /// In en, this message translates to:
  /// **'Consumable'**
  String get consumer;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @drink.
  ///
  /// In en, this message translates to:
  /// **'Drink'**
  String get drink;

  /// No description provided for @taxes.
  ///
  /// In en, this message translates to:
  /// **'Taxes'**
  String get taxes;

  /// No description provided for @meats.
  ///
  /// In en, this message translates to:
  /// **'Meats'**
  String get meats;

  /// No description provided for @ice_cream.
  ///
  /// In en, this message translates to:
  /// **'Ice cream'**
  String get ice_cream;

  /// No description provided for @utilities.
  ///
  /// In en, this message translates to:
  /// **'Supplies'**
  String get utilities;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @no_supplier.
  ///
  /// In en, this message translates to:
  /// **'No supplier'**
  String get no_supplier;

  /// No description provided for @incomes.
  ///
  /// In en, this message translates to:
  /// **'Incomes'**
  String get incomes;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @transaction.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transaction;

  /// No description provided for @month_format.
  ///
  /// In en, this message translates to:
  /// **'{date}'**
  String month_format(DateTime date);

  /// No description provided for @month_day_format.
  ///
  /// In en, this message translates to:
  /// **'{date}'**
  String month_day_format(DateTime date);

  /// No description provided for @date_format.
  ///
  /// In en, this message translates to:
  /// **'{date}'**
  String date_format(DateTime date);

  /// No description provided for @new_income.
  ///
  /// In en, this message translates to:
  /// **'New income'**
  String get new_income;

  /// No description provided for @new_expense.
  ///
  /// In en, this message translates to:
  /// **'New expense'**
  String get new_expense;

  /// No description provided for @label_cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get label_cash;

  /// No description provided for @label_card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get label_card;

  /// No description provided for @label_total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get label_total;

  /// No description provided for @label_date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get label_date;

  /// No description provided for @no_image.
  ///
  /// In en, this message translates to:
  /// **'No image selected.'**
  String get no_image;

  /// No description provided for @income_saved.
  ///
  /// In en, this message translates to:
  /// **'Income saved successfully'**
  String get income_saved;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// No description provided for @salaries.
  ///
  /// In en, this message translates to:
  /// **'Salaries'**
  String get salaries;

  /// No description provided for @marketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get marketing;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @expense_saved.
  ///
  /// In en, this message translates to:
  /// **'Expense saved successfully'**
  String get expense_saved;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @payment_method.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get payment_method;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @income_trend.
  ///
  /// In en, this message translates to:
  /// **'Income Trend'**
  String get income_trend;

  /// No description provided for @income_and_expenses_by_month.
  ///
  /// In en, this message translates to:
  /// **'Income and Expenses by Month'**
  String get income_and_expenses_by_month;

  /// No description provided for @expenses_by_category.
  ///
  /// In en, this message translates to:
  /// **'Expenses by Category'**
  String get expenses_by_category;

  /// No description provided for @payment_methods_expenses.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods - Expenses'**
  String get payment_methods_expenses;

  /// No description provided for @formattedAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount}'**
  String formattedAmount(double amount);

  /// No description provided for @formattedAmountChart.
  ///
  /// In en, this message translates to:
  /// **'{amount}'**
  String formattedAmountChart(double amount);

  /// No description provided for @average_daily_income_expenses.
  ///
  /// In en, this message translates to:
  /// **'Average Daily Income and Expenses'**
  String get average_daily_income_expenses;

  /// No description provided for @table_expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses Table'**
  String get table_expenses;

  /// No description provided for @column_date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get column_date;

  /// No description provided for @column_total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get column_total;

  /// No description provided for @column_category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get column_category;

  /// No description provided for @column_payment_method.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get column_payment_method;

  /// No description provided for @column_ticket.
  ///
  /// In en, this message translates to:
  /// **'Ticket'**
  String get column_ticket;

  /// No description provided for @column_supplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get column_supplier;

  /// No description provided for @column_actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get column_actions;

  /// No description provided for @table_incomes.
  ///
  /// In en, this message translates to:
  /// **'Income Table'**
  String get table_incomes;

  /// No description provided for @column_card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get column_card;

  /// No description provided for @column_cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get column_cash;

  /// No description provided for @day_monday_short.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get day_monday_short;

  /// No description provided for @day_tuesday_short.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get day_tuesday_short;

  /// No description provided for @day_wednesday_short.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get day_wednesday_short;

  /// No description provided for @day_thursday_short.
  ///
  /// In en, this message translates to:
  /// **'Th'**
  String get day_thursday_short;

  /// No description provided for @day_friday_short.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get day_friday_short;

  /// No description provided for @day_saturday_short.
  ///
  /// In en, this message translates to:
  /// **'Sa'**
  String get day_saturday_short;

  /// No description provided for @day_sunday_short.
  ///
  /// In en, this message translates to:
  /// **'Su'**
  String get day_sunday_short;

  /// No description provided for @income_list.
  ///
  /// In en, this message translates to:
  /// **'Income List'**
  String get income_list;

  /// No description provided for @expense_list.
  ///
  /// In en, this message translates to:
  /// **'Expense List'**
  String get expense_list;

  /// No description provided for @crop_image_title.
  ///
  /// In en, this message translates to:
  /// **'Crop Image'**
  String get crop_image_title;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
