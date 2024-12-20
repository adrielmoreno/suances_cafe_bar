import '../../domain/entities/supplier.dart';
import '../../domain/repositories/supplier_repository.dart';
import '../remote_impl/supplier_remote_impl.dart';

class SupplierDataImpl implements SupplierRepository {
  final SupplierRemoteImpl _remoteImpl;
  SupplierDataImpl(this._remoteImpl);

  @override
  Future<bool> deleteOne(String id) => _remoteImpl.deleteOne(id);

  @override
  Stream<List<Supplier>> getAll() => _remoteImpl.getAll();

  @override
  Future<List<Supplier>?> getByIndex(int maxElement) =>
      _remoteImpl.getByIndex(maxElement);

  @override
  Future<void> saveOne(Supplier supplier) => _remoteImpl.saveOne(supplier);

  @override
  Future<void> updateOne(Supplier supplier) => _remoteImpl.updateOne(supplier);
}
