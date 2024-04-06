import 'package:cloud_firestore/cloud_firestore.dart';

enum FBCollection { suppliers, products }

class FirebaseDB {
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
      _firestore.collection(FBCollection.suppliers.name);

  CollectionReference<Map<String, dynamic>> get products =>
      _firestore.collection(FBCollection.products.name);

  static Future<DocumentReference> getReference(
      String documentId, FBCollection collection) async {
    return _firestore.collection(collection.name).doc(documentId);
  }
}
