import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/di/inject.dart';
import '../../../../core/data/db_services/firebase_db.dart';
import '../../../../core/presentation/common/enums/payment_method.dart';
import '../../../../core/presentation/common/enums/type_of_expense.dart';
import '../../../../core/presentation/common/utils/local_dates.dart';
import '../../../suppliers/domain/entities/supplier.dart';
import '../../domain/entities/expense.dart';
import '../viewmodels/expense_view_model.dart';

class ExpenseForm extends ChangeNotifier {
  // ------ form -------
  final _formKey = GlobalKey<FormState>();

  final _totalController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();

  File? _imageFile;
  DateTime _selectedDate = DateTime.now();
  double? _total;
  Supplier? _supplier;

  bool _isEnabled = true;

  TypeOfExpense _category = TypeOfExpense.food;
  PaymentMethod _paymentMethod = PaymentMethod.card;

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get totalController => _totalController;
  TextEditingController get descriptionController => _descriptionController;
  TextEditingController get dateController => _dateController;

  File? get imageFile => _imageFile;
  DateTime get selectedDate => _selectedDate;
  double? get total => _total;
  Supplier? get supplier => _supplier;
  bool get isEnabled => _isEnabled;

  TypeOfExpense get category => _category;
  PaymentMethod get paymentMethod => _paymentMethod;

  set selectedDate(DateTime value) {
    _selectedDate = value;
    _dateController.text = LocalDates.dateFormated(_selectedDate);
    notifyListeners();
  }

  set imageFile(File? file) {
    _imageFile = file;
    notifyListeners();
  }

  set total(double? value) {
    _total = value;
    notifyListeners();
  }

  set category(TypeOfExpense value) {
    _category = value;
    notifyListeners();
  }

  set paymentMethod(PaymentMethod value) {
    _paymentMethod = value;
    notifyListeners();
  }

  set supplier(Supplier? value) {
    _supplier = value;
    notifyListeners();
  }

  set isEnabled(bool value) {
    _isEnabled = value;
    notifyListeners();
  }

  void resetForm() {
    _formKey.currentState?.reset();
    _totalController.clear();
    _descriptionController.clear();
    _dateController.clear();
    _imageFile = null;
    _total = null;
    _category = TypeOfExpense.food;
    _paymentMethod = PaymentMethod.cash;
    _supplier = null;

    notifyListeners();
  }

  Future<void> saveExpense() async {
    if (formKey.currentState!.validate()) {
      // Set correct time
      final dateWithCorrectTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        DateTime.now().hour,
        DateTime.now().minute,
        DateTime.now().second,
      );

      final newExpense = Expense(
        id: const Uuid().v4(),
        createdAt: Timestamp.fromDate(dateWithCorrectTime),
        total: total ?? 0.0,
        urlImgTicket: imageFile?.path ?? "",
        category: category,
        paymentMethod: paymentMethod,
        description: descriptionController.text.isNotEmpty
            ? descriptionController.text
            : null,
        supplier: _supplier != null
            ? getIt<FirebaseDB>().suppliers.doc(_supplier!.id)
            : null,
      );

      await getIt<ExpenseViewModel>().saveOne(newExpense, imageFile);
      resetForm();
    }
  }
}
