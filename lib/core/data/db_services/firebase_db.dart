import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../features/balance/domain/entities/expense.dart';
import '../../../features/balance/domain/entities/income.dart';
import '../../../features/products/domain/entities/product.dart';
import '../../../features/suppliers/domain/entities/supplier.dart';

enum FBCollection {
  suppliers,
  products,
  incomes,
  expenses,
}

class FirebaseDB {
  static final _firestore = FirebaseFirestore.instance;
  static const String _debugPrefix = "debug_";
  static const String _prodPrefix = "prod_";

  FirebaseDB() {
    initializeSettings();
  }

  Future<void> initializeSettings() async {
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  String getCollectionName(FBCollection collection) {
    const envPrefix = kDebugMode ? _debugPrefix : _prodPrefix;
    return "$envPrefix${collection.name}";
  }

  CollectionReference<T> getCollectionWithConverter<T>({
    required FBCollection collection,
    required T Function(Map<String, dynamic>) fromMap,
    required Map<String, dynamic> Function(T) toMap,
  }) {
    return _firestore
        .collection(getCollectionName(collection))
        .withConverter<T>(
          fromFirestore: (snapshot, _) => snapshot.data() != null
              ? fromMap(snapshot.data()!)
              : throw Exception("No data found"),
          toFirestore: (item, _) => toMap(item),
        );
  }

  CollectionReference<Supplier> get suppliers => getCollectionWithConverter(
        collection: FBCollection.suppliers,
        fromMap: (data) => Supplier.fromMap(data),
        toMap: (supplier) => supplier.toMap(),
      );

  CollectionReference<Product> get products => getCollectionWithConverter(
        collection: FBCollection.products,
        fromMap: (data) => Product.fromMap(data),
        toMap: (product) => product.toMap(),
      );

  CollectionReference<Income> get incomes => getCollectionWithConverter(
        collection: FBCollection.incomes,
        fromMap: (data) => Income.fromMap(data),
        toMap: (income) => income.toMap(),
      );

  CollectionReference<Expense> get expenses => getCollectionWithConverter(
        collection: FBCollection.expenses,
        fromMap: (data) => Expense.fromMap(data),
        toMap: (expense) => expense.toMap(),
      );
}
