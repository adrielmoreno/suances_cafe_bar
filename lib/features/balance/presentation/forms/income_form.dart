import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/di/inject.dart';
import '../../../../core/presentation/common/utils/local_dates.dart';
import '../../data/services/recognition_service.dart';
import '../../domain/entities/income.dart';
import '../viewmodels/income_view_model.dart';

class IncomeForm extends ChangeNotifier {
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
    _totalController.text = _total!.toStringAsFixed(2);
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

  Future<bool> saveIncome() async {
    if (formKey.currentState!.validate()) {
      // correct time

      final dateWithCorrectTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        DateTime.now().hour,
        DateTime.now().minute,
        DateTime.now().second,
      );

      final newIncome = Income(
        createdAt: Timestamp.fromDate(dateWithCorrectTime),
        cash: cash ?? 0.0,
        card: card ?? 0.0,
        total: (cash ?? 0.0) + (card ?? 0.0),
        urlImgTicket: imageFile?.path ?? "",
        id: const Uuid().v4(),
      );

      try {
        await getIt<IncomeViewModel>().saveOne(newIncome, imageFile);
        resetForm();
        return true;
      } catch (e) {
        log(e.toString());
      }
    }
    return false;
  }

  // Recognition
  final _textRecognitionService = RecognitionService();

  Future<void> processTicketImage(File imageFile) async {
    try {
      final results =
          await _textRecognitionService.processIncomeImage(imageFile);

      if (results['cash'] != null) {
        _cash = double.tryParse(results['cash']) ?? 0.0;
        _cashController.text = _cash.toString();
      }

      if (results['card'] != null) {
        _card = double.tryParse(results['card']) ?? 0.0;
        _cardController.text = _card.toString();
      }

      if (results['date'] != null) {
        _selectedDate = LocalDates.parseFromString(results['date']!);
        _dateController.text = LocalDates.dateFormated(_selectedDate);
      }

      setTotal();
      _imageFile = imageFile;
      notifyListeners();
    } catch (e) {
      log("Error processing ticket image: $e");
    }
  }
}
