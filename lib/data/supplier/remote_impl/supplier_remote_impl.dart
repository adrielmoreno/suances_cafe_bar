import 'dart:developer';

import '../../../domain/entities/supplier.dart';
import '../../DBServices/firebase_db.dart';

class SupplierRemoteImpl {
  final FirebaseDB _db = FirebaseDB();

  SupplierRemoteImpl();

  Future<bool> deleteOne(String id) async {
    try {
      await _db.suppliers.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Supplier>> getAll() async {
    try {
      final refs = await _db.suppliers.orderBy('name').get();
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

  Future<Supplier> saveOne(Supplier supplier) async {
    try {
      final docRef = await _db.suppliers.add(supplier.toMap());
      supplier.id = docRef.id;
      return supplier;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> updateOne(String id, Supplier supplier) async {
    try {
      await _db.suppliers.doc(id).update(supplier.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }
}
