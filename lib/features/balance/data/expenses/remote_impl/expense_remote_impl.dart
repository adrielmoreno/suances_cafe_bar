import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../../../../core/data/db_services/firebase_db.dart';
import '../../../domain/entities/expense.dart';

class ExpenseRemoteImpl {
  final FirebaseDB _db;

  ExpenseRemoteImpl(this._db);

  Future<bool> deleteOne(String id) async {
    try {
      await _db.expenses.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<Expense>> getAll() {
    try {
      return _db.expenses
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((list) => list.docs.map((e) => e.data()).toList());
    } catch (e) {
      log(e.toString());
      return const Stream.empty();
    }
  }

  Future<Expense> saveOne(Expense expense, File? imageFile) async {
    try {
      String? imageUrl;

      if (imageFile != null) {
        imageUrl = await _uploadImageToStorage(imageFile);
        expense = expense.copyWith(urlImgTicket: imageUrl);
      }

      await _db.expenses.doc(expense.id).set(expense);

      return expense;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> updateOne(Expense expense) async {
    try {
      await _db.expenses.doc(expense.id).update(expense.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> _uploadImageToStorage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      final imagesRef = storageRef.child(
          'images/${_db.getCollectionName(FBCollection.expenses)}/$fileName');

      final snapshot = await imagesRef.putFile(imageFile);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e, stackTrace) {
      debugPrint('Error uploading image: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }
}
