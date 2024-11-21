import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/di/inject.dart';
import '../../../../core/data/db_services/firebase_db.dart';
import '../../../../domain/entities/supplier.dart';
import '../../../../presentation/common/provider/search_provider.dart';
import '../../../../presentation/common/utils/format_helper.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductViewModel extends SearchProvider<Product> {
  final ProductRepository _productRepository;

  ProductViewModel(this._productRepository);

  StreamSubscription<List<Product>>? _productSubscription;

  Future<void> getAll() async {
    try {
      _productSubscription?.cancel();

      _productSubscription = _productRepository.getAll().listen((event) {
        allItems = event;
        filteredItems = event;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Error fetching products: ${e.toString()}');
    }
  }

  Future<void> updateOne(Product product) async {
    try {
      await _productRepository.updateOne(product);
    } catch (e) {
      debugPrint('Error update a product: ${e.toString()}');
    }
  }

  Future<void> saveOne(Product product) async {
    try {
      await _productRepository.saveOne(product);
    } catch (e) {
      debugPrint('Error save a product: ${e.toString()}');
    }
  }

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
      await saveOne(newProduct);
      resetForm();
    } else {
      await updateOne(newProduct);
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

  @override
  void dispose() {
    _productSubscription?.cancel();
    super.dispose();
  }
}
