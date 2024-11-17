import 'dart:io';

import '../entities/income.dart';

abstract interface class IncomeRepository {
  Stream<List<Income>> getAll();
  Future<Income> saveOne(Income income, File? imageFile);
  Future<bool> updateOne(String id, Income income);
}
