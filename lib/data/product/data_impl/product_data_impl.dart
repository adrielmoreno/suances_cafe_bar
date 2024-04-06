import '../../../domain/entities/product.dart';
import '../../../domain/repositories/product_repository.dart';
import '../remote_impl/product_remote_impl.dart';

class ProductDataImpl implements ProductRepository {
  final ProductRemoteImpl _remoteImpl;
  ProductDataImpl(this._remoteImpl);

  @override
  Future<bool> deleteOne(String id) => _remoteImpl.deleteOne(id);

  @override
  Future<List<Product>> getAll() => _remoteImpl.getAll();

  @override
  Future<List<Product>?> getByIndex(int maxElement) =>
      _remoteImpl.getByIndex(maxElement);

  @override
  Future<Product> saveOne(Product product) => _remoteImpl.saveOne(product);

  @override
  Future<bool> updateOne(String id, Product product) =>
      _remoteImpl.updateOne(id, product);
}
