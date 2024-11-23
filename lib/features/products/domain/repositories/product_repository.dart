import '../entities/product.dart';

abstract interface class ProductRepository {
  Stream<List<Product>> getAll();
  Future<List<Product>?> getByIndex(int maxElement);
  Future<Product> saveOne(Product product);
  Future<bool> updateOne(Product product);
  Future<bool> deleteOne(String id);
}
