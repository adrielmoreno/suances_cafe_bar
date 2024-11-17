import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/income.dart';
import '../../db_services/firebase_db.dart';
import '../../mappable/mappable.dart';

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
          .orderBy('date', descending: true)
          .snapshots()
          .map((list) => getListFromSnapshot(list.docs, Income.fromMap));
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
        income.urlImgTicket = imageUrl ?? '';
      }

      final docRef = await _db.incomes.add(income.toMap());
      income.id = docRef.id;
      return income;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> updateOne(String id, Income income) async {
    try {
      await _db.incomes.doc(id).update(income.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> _uploadImageToStorage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imagesRef = storageRef.child(
          'images/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}');
      final uploadTask = imagesRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
