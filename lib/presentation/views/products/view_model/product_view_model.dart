import 'dart:async';

import '../../../../domain/entities/product.dart';
import '../../../../domain/repositories/product_repository.dart';
import '../../../common/interfaces/resource_state.dart';
import '../../../common/interfaces/view_model_interface.dart';

class ProductViewModel extends ViewModelInterface {
  final ProductRepository _productRepository;

  ProductViewModel(this._productRepository);

  StreamController<ResourceState> getAllState =
      StreamController<ResourceState>();
  StreamController<ResourceState> updateOneState =
      StreamController<ResourceState>();
  StreamController<ResourceState> saveOneState =
      StreamController<ResourceState>();

  Future<void> getAll() async {
    getAllState.add(ResourceState.loading());

    _productRepository
        .getAll()
        .listen((event) => getAllState.add(ResourceState.completed(event)));
  }

  Future<void> updateOne(String id, Product product) async {
    updateOneState.add(ResourceState.loading());

    _productRepository
        .updateOne(id, product)
        .then((event) => updateOneState.add(ResourceState.completed(null)));
  }

  Future<void> saveOne(Product product) async {
    saveOneState.add(ResourceState.loading());

    _productRepository
        .saveOne(product)
        .then((event) => saveOneState.add(ResourceState.completed(null)));
  }

  @override
  void close() {
    getAllState.close();
    updateOneState.close();
    saveOneState.close();
  }
}
