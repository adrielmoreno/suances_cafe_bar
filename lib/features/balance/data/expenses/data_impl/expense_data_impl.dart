import 'dart:io';

import '../../../domain/entities/expense.dart';
import '../../../domain/repositories/expense_repository.dart';
import '../remote_impl/expense_remote_impl.dart';

class ExpenseDataImpl implements ExpenseRepository {
  final ExpenseRemoteImpl _remoteImpl;
  ExpenseDataImpl(this._remoteImpl);

  @override
  Stream<List<Expense>> getAll() => _remoteImpl.getAll();

  @override
  Future<Expense> saveOne(Expense expense, File? imageFile) =>
      _remoteImpl.saveOne(expense, imageFile);

  @override
  Future<bool> updateOne(Expense expense) => _remoteImpl.updateOne(expense);
}
