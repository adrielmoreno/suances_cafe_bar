import 'dart:developer';

import '../../../../core/data/db_services/firebase_db.dart';
import '../../domain/entities/supplier.dart';

class SupplierRemoteImpl {
  final FirebaseDB _db;

  SupplierRemoteImpl(this._db);

  Future<bool> deleteOne(String id) async {
    try {
      await _db.suppliers.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<Supplier>> getAll() {
    try {
      return _db.suppliers
          .orderBy('name')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((e) => e.data()).toList());
    } catch (e) {
      log(e.toString());
      return const Stream.empty();
    }
  }

  Future<List<Supplier>?> getByIndex(int maxElement) async {
    try {
      final data =
          await _db.suppliers.orderBy('name').limitToLast(maxElement).get();

      return data.docs.map((e) => e.data()).toList();
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future<void> saveOne(Supplier supplier) async {
    try {
      await _db.suppliers.doc(supplier.id).set(supplier);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateOne(Supplier supplier) async {
    try {
      await _db.suppliers.doc(supplier.id).update(supplier.toMap());
    } catch (e) {
      log(e.toString());
    }
  }
}
