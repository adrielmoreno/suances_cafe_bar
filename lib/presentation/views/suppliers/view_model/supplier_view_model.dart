import 'dart:async';

import '../../../../domain/repositories/supplier_repository.dart';
import '../../../common/interfaces/resource_state.dart';
import '../../../common/interfaces/view_model_interface.dart';

class SupplierViewModel extends ViewModelInterface {
  final SupplierRepository _supplierRepository;

  SupplierViewModel(this._supplierRepository);

  StreamController<ResourceState> getAllState =
      StreamController<ResourceState>();

  Future<void> getAll() async {
    getAllState.add(ResourceState.loading());

    _supplierRepository
        .getAll()
        .listen((event) => getAllState.add(ResourceState.completed(event)));
  }

  @override
  void close() {
    getAllState.close();
  }
}
