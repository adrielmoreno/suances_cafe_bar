import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/presentation/common/provider/search_provider.dart';
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

  @override
  void dispose() {
    _productSubscription?.cancel();
    super.dispose();
  }
}
