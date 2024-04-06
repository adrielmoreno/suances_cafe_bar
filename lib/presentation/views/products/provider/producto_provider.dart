import 'package:flutter/material.dart';

import '../../../../domain/entities/supplier.dart';

class ProductProvider extends ChangeNotifier {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _packagingController = TextEditingController();
  final _measureController = TextEditingController();
  final _pricePackingController = TextEditingController();
  final _priceUnitController = TextEditingController();
  final _lastPriceController = TextEditingController();
  Supplier? _lastSupplier;

  bool _isEnabled = true;

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get nameController => _nameController;
  TextEditingController get packagingController => _packagingController;
  TextEditingController get measureController => _measureController;
  TextEditingController get pricePackingController => _pricePackingController;
  TextEditingController get priceUnitController => _priceUnitController;
  TextEditingController get lastPriceController => _lastPriceController;
  Supplier? get lastSupplier => _lastSupplier;
  bool get isEnabled => _isEnabled;

  set isEnabled(bool value) {
    _isEnabled = value;
    notifyListeners();
  }

  set lastSupplier(Supplier? value) {
    _lastSupplier = value;
    notifyListeners();
  }

  void resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _packagingController.clear();
    _measureController.clear();
    _pricePackingController.clear();
    _priceUnitController.clear();
    _lastPriceController.clear();
    _lastSupplier = null;
    notifyListeners();
  }
}
