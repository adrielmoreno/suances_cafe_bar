import 'dart:developer';

import '../../../domain/entities/supplier.dart';
import '../../db_services/firebase_db.dart';
import '../../mappable/mappable.dart';

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
          .map((list) => getListFromSnapshot(list.docs, Supplier.fromMap));
    } catch (e) {
      log(e.toString());
      return const Stream.empty();
    }
  }

  Future<List<Supplier>?> getByIndex(int maxElement) async {
    try {
      final refs =
          await _db.suppliers.orderBy('name').limitToLast(maxElement).get();
      final docs = refs.docs;

      if (docs.isNotEmpty) {
        final suppliers = docs.map((e) {
          final map = e.data();
          map['id'] = e.id;
          return Supplier.fromMap(map);
        }).toList();
        return suppliers;
      }
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future<void> saveOne(Supplier supplier) async {
    try {
      final docRef = await _db.suppliers.add(supplier.toMap());
      supplier.id = docRef.id;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateOne(String id, Supplier supplier) async {
    try {
      await _db.suppliers.doc(id).update(supplier.toMap());
    } catch (e) {
      log(e.toString());
    }
  }
}
