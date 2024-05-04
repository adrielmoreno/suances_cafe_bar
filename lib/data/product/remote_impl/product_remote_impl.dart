import 'dart:developer';

import '../../../domain/entities/product.dart';
import '../../../inject/inject.dart';
import '../../db_services/firebase_db.dart';
import '../../mappable/mappable.dart';

class ProductRemoteImpl {
  final _db = getIt<FirebaseDB>();

  ProductRemoteImpl();

  Future<bool> deleteOne(String id) async {
    try {
      await _db.products.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<Product>> getAll() {
    try {
      return _db.products
          .orderBy('name')
          .snapshots()
          .map((list) => getListFromSnapshot(list.docs, Product.fromMap));
    } catch (e) {
      log(e.toString());
      return const Stream.empty();
    }
  }

  Future<List<Product>?> getByIndex(int maxElement) async {
    try {
      final refs =
          await _db.products.orderBy('name').limitToLast(maxElement).get();
      final docs = refs.docs;

      if (docs.isNotEmpty) {
        final products = docs.map((e) {
          final map = e.data();
          map['id'] = e.id;
          return Product.fromMap(map);
        }).toList();
        return products;
      }
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future<Product> saveOne(Product product) async {
    try {
      final docRef = await _db.products.add(product.toMap());
      product.id = docRef.id;
      return product;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> updateOne(String id, Product product) async {
    try {
      await _db.products.doc(id).update(product.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }
}
