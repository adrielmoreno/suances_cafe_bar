import 'dart:async';
import 'dart:io';

import '../../../../domain/entities/income.dart';
import '../../../../domain/repositories/income_repository.dart';
import '../../../common/interfaces/resource_state.dart';
import '../../../common/interfaces/view_model_interface.dart';

class IncomeViewModel extends ViewModelInterface {
  final IncomeRepository _incomeRepository;

  IncomeViewModel(this._incomeRepository);

  StreamController<ResourceState> getAllState =
      StreamController<ResourceState>();
  StreamController<ResourceState> updateOneState =
      StreamController<ResourceState>();
  StreamController<ResourceState> saveOneState =
      StreamController<ResourceState>();

  Future<void> getAll() async {
    getAllState.add(ResourceState.loading());

    _incomeRepository
        .getAll()
        .listen((event) => getAllState.add(ResourceState.completed(event)));
  }

  Future<void> updateOne(String id, Income income) async {
    updateOneState.add(ResourceState.loading());

    _incomeRepository
        .updateOne(id, income)
        .then((event) => updateOneState.add(ResourceState.completed(null)));
  }

  Future<void> saveOne(Income income, File? imageFile) async {
    saveOneState.add(ResourceState.loading());

    _incomeRepository
        .saveOne(income, imageFile)
        .then((event) => saveOneState.add(ResourceState.completed(null)));
  }

  @override
  void close() {
    getAllState.close();
    updateOneState.close();
    saveOneState.close();
  }
}
