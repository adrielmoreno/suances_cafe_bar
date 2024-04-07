import 'package:flutter/material.dart';

import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/supplier.dart';
import '../../../common/provider/search_provider.dart';

class ProductProvider extends SearchProvider<Product> {
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
    notifyListeners();
  }
}
