import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/di/inject.dart';
import '../../../../core/data/db_services/firebase_db.dart';
import '../../../../core/presentation/common/utils/format_helper.dart';
import '../../../suppliers/domain/entities/supplier.dart';
import '../../domain/entities/product.dart';
import '../view_model/product_view_model.dart';

class ProductForm extends ChangeNotifier {
// ------ form -------
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _packagingController = TextEditingController();
  final _measureController = TextEditingController();
  final _pricePackingController = TextEditingController();
  final _priceUnitController = TextEditingController();
  final _ivaController = TextEditingController();
  final _pricePlusIVA = TextEditingController();
  Supplier? _lastSupplier;
  double _iva = 0.0;
  bool _isEnabled = true;

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get nameController => _nameController;
  TextEditingController get packagingController => _packagingController;
  TextEditingController get measureController => _measureController;
  TextEditingController get pricePackingController => _pricePackingController;
  TextEditingController get priceUnitController => _priceUnitController;
  TextEditingController get ivaController => _ivaController;
  TextEditingController get pricePlusIVA => _pricePlusIVA;
  Supplier? get lastSupplier => _lastSupplier;
  double get iva => _iva;
  bool get isEnabled => _isEnabled;

  set isEnabled(bool value) {
    _isEnabled = value;
    notifyListeners();
  }

  set lastSupplier(Supplier? value) {
    _lastSupplier = value;
    notifyListeners();
  }

  set iva(double value) {
    _iva = value;
    notifyListeners();
  }

  void resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _packagingController.clear();
    _measureController.clear();
    _pricePackingController.clear();
    _priceUnitController.clear();
    _pricePlusIVA.clear();
    _iva = 0.0;
    _ivaController.clear();
    _lastSupplier = null;

    isEnabled = true;
    notifyListeners();
  }

  void updatePrices() {
    if (_pricePackingController.text.isNotEmpty &&
        _packagingController.text.isNotEmpty) {
      final pricePacking =
          FormatHelper.parseInput(_pricePackingController.text);
      final packaging = FormatHelper.parseInput(_packagingController.text);

      final unitPrice = _calculateUnitPrice(pricePacking, packaging);
      final priceWithIVA = _calculatePriceWithIVA(unitPrice, _iva);

      _priceUnitController.text = unitPrice.toStringAsFixed(2);
      _pricePlusIVA.text = priceWithIVA.toStringAsFixed(2);
    } else {
      _priceUnitController.clear();
      _pricePlusIVA.clear();
    }
    notifyListeners();
  }

  Future<void> saveOrUpdateProduct(Product? product) async {
    if (!_formKey.currentState!.validate()) return;

    final newProduct = Product(
      id: product?.id ?? const Uuid().v4(),
      name: _nameController.text,
      packaging: FormatHelper.parseInput(_packagingController.text),
      measure: _measureController.text,
      pricePacking: FormatHelper.parseInput(_pricePackingController.text),
      priceUnit: FormatHelper.parseInput(_priceUnitController.text),
      iva: _iva,
      pricePlusIVA: FormatHelper.parseInput(_pricePlusIVA.text),
      lastSupplier: _lastSupplier != null
          ? getIt<FirebaseDB>().suppliers.doc(_lastSupplier!.id)
          : null,
      createdAt: product?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (product == null) {
      await getIt<ProductViewModel>().saveOne(newProduct);
      resetForm();
    } else {
      await getIt<ProductViewModel>().updateOne(newProduct);
      isEnabled = false;
    }
  }

  double _calculateUnitPrice(double pricePacking, double packaging) {
    return packaging > 0 ? pricePacking / packaging : 0.0;
  }

  double _calculatePriceWithIVA(double unitPrice, double iva) {
    final taxes = unitPrice * iva / 100;
    return unitPrice + taxes;
  }

  loadProductData(Product product) async {
    nameController.text = product.name;
    packagingController.text = product.packaging.toString();
    measureController.text = product.measure;
    pricePackingController.text = product.pricePacking.toString();
    priceUnitController.text = product.priceUnit.toString();
    ivaController.text = product.iva.toString();
    pricePlusIVA.text = product.pricePlusIVA.toString();
    lastSupplier = product.lastSupplier != null
        ? (await product.lastSupplier?.get())?.data()
        : null;

    isEnabled = false;
  }
}
