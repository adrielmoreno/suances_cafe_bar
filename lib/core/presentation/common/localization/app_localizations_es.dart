import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app_title => 'Suances';

  @override
  String get contactName => 'Nombre de contacto';

  @override
  String get edit => 'Editar';

  @override
  String get errorEmpty => 'No puede estar vacío';

  @override
  String get errorName => 'Ingrese un nombre';

  @override
  String get errorPhone => 'Teléfono inválido';

  @override
  String get lastPrice => '€ U+IVA';

  @override
  String get lastSupplier => 'Último proveedor';

  @override
  String get measure => 'Medida';

  @override
  String get name => 'Nombre';

  @override
  String get newProduct => 'Nuevo producto';

  @override
  String get newSupplier => 'Nuevo suplidor';

  @override
  String get newTask => 'Nueva tarea';

  @override
  String get packaging => 'Empaque';

  @override
  String get phone => 'Teléfono de contacto';

  @override
  String get pricePacking => '€ Precio';

  @override
  String get priceUnit => '€ Unidad';

  @override
  String get product => 'Producto';

  @override
  String get productName => 'Nombre del producto';

  @override
  String get products => 'Productos';

  @override
  String get save => 'Guardar';

  @override
  String get search => 'Buscar';

  @override
  String get supplier => 'Suplidor';

  @override
  String get supplierName => 'Nombre del suplidor';

  @override
  String get suppliers => 'Suplidores';

  @override
  String get todos => 'Tareas';

  @override
  String get orders => 'Pedidos';

  @override
  String get type => 'Tipo';

  @override
  String get iva => '％ IVA';

  @override
  String get consumer => 'Consumible';

  @override
  String get food => 'Comida';

  @override
  String get drink => 'Bebida';

  @override
  String get taxes => 'Impuestos';

  @override
  String get meats => 'Carnes';

  @override
  String get ice_cream => 'Helados';

  @override
  String get utilities => 'Suministros';

  @override
  String get services => 'Servicios';

  @override
  String get no_supplier => 'Ningún suplidor';

  @override
  String get incomes => 'Ingresos';

  @override
  String get expenses => 'Gastos';

  @override
  String get transaction => 'Transacciones';

  @override
  String month_format(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMM(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String date_format(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get new_income => 'Nuevo ingreso';

  @override
  String get new_expense => 'Nuevo gasto';

  @override
  String get label_cash => 'Efectivo';

  @override
  String get label_card => 'Tarjeta';

  @override
  String get label_total => 'Total';

  @override
  String get label_date => 'Fecha';

  @override
  String get no_image => 'No se ha seleccionado una imagen.';

  @override
  String get income_saved => 'Ingreso guardado correctamente';

  @override
  String get maintenance => 'Mantenimiento';

  @override
  String get rent => 'Alquiler';

  @override
  String get salaries => 'Salarios';

  @override
  String get marketing => 'Marketing';

  @override
  String get transfer => 'Transferencia';

  @override
  String get expense_saved => 'Gasto guardado correctamente';

  @override
  String get category => 'Categoría';

  @override
  String get payment_method => 'Método de pago';

  @override
  String get description => 'Descripción';

  @override
  String get income_trend => 'Tendencia de Ingresos';

  @override
  String get income_and_expenses_by_month => 'Ingresos y Gastos por Mes';

  @override
  String get expenses_by_category => 'Gastos por Categoría';

  @override
  String get payment_methods_expenses => 'Métodos de Pago - Gastos';

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
  String get average_daily_income_expenses => 'Promedio Diario de Ingresos y Gastos';

  @override
  String get table_expenses => 'Tabla de Gastos';

  @override
  String get column_date => 'Fecha';

  @override
  String get column_total => 'Total';

  @override
  String get column_category => 'Categoría';

  @override
  String get column_payment_method => 'Método de Pago';

  @override
  String get column_ticket => 'Ticket';

  @override
  String get column_supplier => 'Proveedor';

  @override
  String get column_actions => 'Acciones';

  @override
  String get table_incomes => 'Tabla de Ingresos';

  @override
  String get column_card => 'Tarjeta';

  @override
  String get column_cash => 'Efectivo';

  @override
  String get day_monday_short => 'L';

  @override
  String get day_tuesday_short => 'M';

  @override
  String get day_wednesday_short => 'X';

  @override
  String get day_thursday_short => 'J';

  @override
  String get day_friday_short => 'V';

  @override
  String get day_saturday_short => 'S';

  @override
  String get day_sunday_short => 'D';

  @override
  String get income_list => 'Listado de ingresos';

  @override
  String get expense_list => 'Listado de gastos';
}
