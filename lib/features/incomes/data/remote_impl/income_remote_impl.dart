import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../../../core/data/db_services/firebase_db.dart';
import '../../domain/entities/income.dart';

class IncomeRemoteImpl {
  final FirebaseDB _db;

  IncomeRemoteImpl(this._db);

  Future<bool> deleteOne(String id) async {
    try {
      await _db.incomes.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<Income>> getAll() {
    try {
      return _db.incomes
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((list) => list.docs.map((e) => e.data()).toList());
    } catch (e) {
      log(e.toString());
      return const Stream.empty();
    }
  }

  Future<Income> saveOne(Income income, File? imageFile) async {
    try {
      String? imageUrl;

      if (imageFile != null) {
        imageUrl = await _uploadImageToStorage(imageFile);
        income = income.copyWith(urlImgTicket: imageUrl ?? '');
      }

      await _db.incomes.doc(income.id).set(income);

      return income;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> updateOne(Income income) async {
    try {
      await _db.incomes.doc(income.id).update(income.toMap());
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
          'images/${_db.getCollectionName(FBCollection.incomes)}/$fileName');

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
