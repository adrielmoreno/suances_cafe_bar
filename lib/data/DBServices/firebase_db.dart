import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDB {
  static const String _suppliers = 'suppliers';
  static const String _products = 'products';

  static final _firestore = FirebaseFirestore.instance;

  FirebaseDB() {
    initializeSettings();
  }

  Future<void> initializeSettings() async {
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  CollectionReference<Map<String, dynamic>> get suppliers =>
      _firestore.collection(_suppliers);

  CollectionReference<Map<String, dynamic>> get products =>
      _firestore.collection(_products);
}
