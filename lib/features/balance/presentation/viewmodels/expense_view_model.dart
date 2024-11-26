import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/presentation/common/enums/payment_method.dart';
import '../../../../core/presentation/common/localization/localization_manager.dart';
import '../../../../core/presentation/common/provider/search_provider.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/montly_expense.dart';
import '../../domain/repositories/expense_repository.dart';

class ExpenseViewModel extends SearchProvider<Expense> {
  final ExpenseRepository _expenseRepository;

  ExpenseViewModel(this._expenseRepository);

  String? errorMessage;

  Future<void> getAll() async {
    try {
      _expenseRepository.getAll().listen((event) => allItems = event);
      errorMessage = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching expenses: ${e.toString()}');
    }
  }

  Future<void> saveOne(Expense expense, File? imageFile) async {
    try {
      await _expenseRepository.saveOne(expense, imageFile);
    } catch (e) {
      errorMessage = 'Error saving expense: ${e.toString()}';
    }
  }

  Map<String, MonthlyExpense> groupExpensesByMonth() {
    return allItems.fold({},
        (Map<String, MonthlyExpense> groupedExpenses, expense) {
      String monthKey = text.month_format(expense.createdAt.toDate());
      if (!groupedExpenses.containsKey(monthKey)) {
        groupedExpenses[monthKey] = MonthlyExpense(
          id: monthKey,
          total: 0,
          cash: 0,
          card: 0,
          transfer: 0,
        );
      }

      groupedExpenses[monthKey]!.total += expense.total;

      switch (expense.paymentMethod) {
        case PaymentMethod.cash:
          groupedExpenses[monthKey]!.cash += expense.total;
          break;
        case PaymentMethod.card:
          groupedExpenses[monthKey]!.card += expense.total;
          break;
        case PaymentMethod.bankTransfer:
          groupedExpenses[monthKey]!.transfer += expense.total;
          break;
      }

      return groupedExpenses;
    });
  }

  Map<String, double> get monthlyExpenses => {
        for (var entry in groupExpensesByMonth().entries)
          entry.key: entry.value.total
      };

  Map<String, Map<String, double>> get expensesByPaymentMethod => {
        for (var entry in groupExpensesByMonth().entries)
          entry.key: {
            text.label_cash: entry.value.cash,
            text.label_card: entry.value.card,
            text.transfer: entry.value.transfer,
          }
      };

  Map<String, double> get expensesByCategory {
    final Map<String, double> result = {};
    for (var expense in allItems) {
      final category = expense.category.getName;
      result[category] = (result[category] ?? 0) + expense.total;
    }
    return result;
  }
}
