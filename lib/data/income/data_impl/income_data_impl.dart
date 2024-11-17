import 'dart:io';

import '../../../domain/entities/income.dart';
import '../../../domain/repositories/income_repository.dart';
import '../remote_impl/income_remote_impl.dart';

class IncomeDataImpl implements IncomeRepository {
  final IncomeRemoteImpl _remoteImpl;
  IncomeDataImpl(this._remoteImpl);

  @override
  Stream<List<Income>> getAll() => _remoteImpl.getAll();

  @override
  Future<Income> saveOne(Income product, File? imageFile) =>
      _remoteImpl.saveOne(product, imageFile);

  @override
  Future<bool> updateOne(String id, Income product) =>
      _remoteImpl.updateOne(id, product);
}
