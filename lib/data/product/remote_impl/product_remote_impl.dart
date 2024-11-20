import 'dart:developer';

import '../../../core/data/db_services/firebase_db.dart';
import '../../../domain/entities/product.dart';

class ProductRemoteImpl {
  final FirebaseDB _db;

  ProductRemoteImpl(this._db);

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
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
    } catch (e) {
      log(e.toString());
      return const Stream.empty();
    }
  }

  Future<List<Product>?> getByIndex(int maxElement) async {
    try {
      final data =
          await _db.products.orderBy('name').limitToLast(maxElement).get();

      data.docs.map((e) => e.data()).toList();
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future<Product> saveOne(Product product) async {
    try {
      await _db.products.add(product);

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
