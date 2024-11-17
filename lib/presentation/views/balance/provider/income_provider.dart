import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../domain/entities/income.dart';
import '../../../common/localization/localization_manager.dart';
import '../../../common/provider/search_provider.dart';
import '../../../common/utils/local_dates.dart';

enum TypeToDo { errand, order }

class IncomeProvider extends SearchProvider<Income> {
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

  Map<String, Income> groupIncomesByMonth() {
    return allItems.fold({}, (Map<String, Income> groupedIncomes, income) {
      String monthKey = text.month_format(income.date.toDate());
      log(monthKey);
      if (!groupedIncomes.containsKey(monthKey)) {
        groupedIncomes[monthKey] =
            Income(cash: 0, card: 0, total: 0, date: income.date);
      }

      groupedIncomes[monthKey]!.cash += income.cash;
      groupedIncomes[monthKey]!.card += income.card;
      groupedIncomes[monthKey]!.total += income.total;

      return groupedIncomes;
    });
  }
}
