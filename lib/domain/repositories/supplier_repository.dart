import '../entities/supplier.dart';

abstract interface class SupplierRepository {
  Stream<List<Supplier>> getAll();
  Future<List<Supplier>?> getByIndex(int maxElement);
  Future<void> saveOne(Supplier supplier);
  Future<void> updateOne(String id, Supplier supplier);
  Future<bool> deleteOne(String id);
}
