import 'package:flutter/material.dart';

enum TypeTransaction { income, expense }

class TransactionProvider extends ChangeNotifier {
  TypeTransaction _transactionView = TypeTransaction.income;
  TypeTransaction get transactionView => _transactionView;

  set transactionView(TypeTransaction value) {
    _transactionView = value;
    notifyListeners();
  }
}
