import 'dart:async';

import '../../../../domain/entities/supplier.dart';
import '../../../../domain/repositories/supplier_repository.dart';
import '../../../common/interfaces/resource_state.dart';
import '../../../common/interfaces/view_model_interface.dart';

class SupplierViewModel extends ViewModelInterface {
  final SupplierRepository _supplierRepository;

  SupplierViewModel(this._supplierRepository);

  StreamController<ResourceState> getAllState =
      StreamController<ResourceState>();
  StreamController<ResourceState> updateOneState =
      StreamController<ResourceState>();
  StreamController<ResourceState> saveOneState =
      StreamController<ResourceState>();

  Future<void> getAll() async {
    getAllState.add(ResourceState.loading());

    _supplierRepository
        .getAll()
        .listen((event) => getAllState.add(ResourceState.completed(event)));
  }

  Future<void> updateOne(String id, Supplier supplier) async {
    updateOneState.add(ResourceState.loading());

    _supplierRepository
        .updateOne(id, supplier)
        .then((event) => updateOneState.add(ResourceState.completed(null)));
  }

  Future<void> saveOne(Supplier supplier) async {
    saveOneState.add(ResourceState.loading());

    _supplierRepository
        .saveOne(supplier)
        .then((event) => saveOneState.add(ResourceState.completed(null)));
  }

  @override
  void close() {
    getAllState.close();
    updateOneState.close();
    saveOneState.close();
  }
}
