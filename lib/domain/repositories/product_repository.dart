import '../entities/product.dart';

abstract interface class ProductRepository {
  Future<List<Product>> getAll();
  Future<List<Product>?> getByIndex(int maxElement);
  Future<Product> saveOne(Product supplier);
  Future<bool> updateOne(String id, Product supplier);
  Future<bool> deleteOne(String id);
}
