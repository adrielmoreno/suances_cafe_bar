import 'dart:io';

import '../entities/expense.dart';

abstract interface class ExpenseRepository {
  Stream<List<Expense>> getAll();
  Future<Expense> saveOne(Expense expense, File? imageFile);
  Future<bool> updateOne(Expense expense);
}
