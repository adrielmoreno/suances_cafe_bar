import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

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
  String get new_income => 'Nuevo ingreso';

  @override
  String get new_expense => 'Nuevo gasto';

  @override
  String get label_cash => '€ Efectivo';

  @override
  String get label_card => '€ Tarjeta';

  @override
  String get label_total => '€ Total';

  @override
  String get label_date => 'Fecha';

  @override
  String get no_image => 'No se ha seleccionado una imagen.';

  @override
  String get income_saved => 'Ingreso guardado correctamente';
}
