import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/presentation/common/provider/search_provider.dart';
import '../../domain/entities/supplier.dart';
import '../../domain/repositories/supplier_repository.dart';

class SupplierViewModel extends SearchProvider<Supplier> {
  final SupplierRepository _supplierRepository;

  SupplierViewModel(this._supplierRepository);

  StreamSubscription<List<Supplier>>? _supplierSubscription;

  Future<void> getAll() async {
    try {
      _supplierRepository.getAll().listen((event) {
        allItems = event;
        filteredItems = event;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Error fetching suppliers: ${e.toString()}');
    }
  }

  Future<void> updateOne(Supplier supplier) async {
    try {
      await _supplierRepository.updateOne(supplier);
    } catch (e) {
      debugPrint('Error update a supplier: ${e.toString()}');
    }
  }

  Future<void> saveOne(Supplier supplier) async {
    try {
      _supplierRepository.saveOne(supplier);
    } catch (e) {
      debugPrint('Error save a supplier: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    _supplierSubscription?.cancel();
    super.dispose();
  }
}
