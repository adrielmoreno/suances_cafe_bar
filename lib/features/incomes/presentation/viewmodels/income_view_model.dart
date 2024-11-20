import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../presentation/common/localization/localization_manager.dart';
import '../../../../presentation/common/provider/search_provider.dart';
import '../../../../presentation/common/utils/local_dates.dart';
import '../../domain/entities/income.dart';
import '../../domain/entities/montly_income.dart';
import '../../domain/repositories/income_repository.dart';

enum TypeToDo { errand, order }

class IncomeViewModel extends SearchProvider<Income> {
  final IncomeRepository _incomeRepository;

  IncomeViewModel(this._incomeRepository);

  bool isLoading = false;
  String? errorMessage;

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> getAll() async {
    _setLoading(true);
    try {
      _incomeRepository.getAll().listen((event) => allItems = event);
      errorMessage = null;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Error fetching incomes: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // Future<void> updateOne(String id, Income income) async {
  //   _incomeRepository
  //       .updateOne(id, income)
  //       .then((event) => updateOneState.add(ResourceState.completed(null)));
  // }

  Future<void> saveOne(Income income, File? imageFile) async {
    try {
      await _incomeRepository.saveOne(income, imageFile);
    } catch (e) {
      errorMessage = 'Error saving income: ${e.toString()}';
    }
  }

  Map<String, MonthlyIcome> groupIncomesByMonth() {
    return allItems.fold({},
        (Map<String, MonthlyIcome> groupedIncomes, income) {
      String monthKey = text.month_format(income.createdAt.toDate());
      if (!groupedIncomes.containsKey(monthKey)) {
        groupedIncomes[monthKey] = MonthlyIcome(
          id: monthKey,
          cash: 0,
          card: 0,
          total: 0,
        );
      }

      groupedIncomes[monthKey]!.cash += income.cash;
      groupedIncomes[monthKey]!.card += income.card;
      groupedIncomes[monthKey]!.total += income.total;

      return groupedIncomes;
    });
  }

  // ------ form -------
  final _formKey = GlobalKey<FormState>();

  final _cashController = TextEditingController();
  final _cardController = TextEditingController();
  final _totalController = TextEditingController();
  final _dateController = TextEditingController();

  File? _imageFile;
  DateTime _selectedDate = DateTime.now();
  double? _cash;
  double? _card;
  double? _total;

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get cashController => _cashController;
  TextEditingController get cardController => _cardController;
  TextEditingController get totalController => _totalController;
  TextEditingController get dateController => _dateController;

  double? get cash => _cash;
  double? get card => _card;
  double? get total => _total;

  File? get imageFile => _imageFile;
  DateTime get selectedDate => _selectedDate;

  set selectedDate(DateTime value) {
    _selectedDate = value;
    _dateController.text = LocalDates.dateFormated(_selectedDate);
    notifyListeners();
  }

  set imageFile(File? file) {
    _imageFile = file;
    notifyListeners();
  }

  set cash(double? value) {
    _cash = value;
    notifyListeners();
  }

  set card(double? value) {
    _card = value;
    notifyListeners();
  }

  void setTotal() {
    _total = (_card ?? 0.0) + (_cash ?? 0.0);
    _totalController.text = '$_total';
    notifyListeners();
  }

  void resetForm() {
    _formKey.currentState?.reset();
    _cashController.clear();
    _totalController.clear();
    _cardController.clear();
    _dateController.clear();
    _card = null;
    _cash = null;
    _imageFile = null;
    notifyListeners();
  }
}
