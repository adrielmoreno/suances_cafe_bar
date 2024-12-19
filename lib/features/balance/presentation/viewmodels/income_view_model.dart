import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/presentation/common/extensions/widget_extensions.dart';
import '../../../../core/presentation/common/localization/localization_manager.dart';
import '../../../../core/presentation/common/provider/search_provider.dart';
import '../../domain/entities/income.dart';
import '../../domain/entities/montly_income.dart';
import '../../domain/repositories/income_repository.dart';

class IncomeViewModel extends SearchProvider<Income> {
  final IncomeRepository _incomeRepository;

  IncomeViewModel(this._incomeRepository);

  StreamSubscription<List<Income>>? _incomesSubscription;

  Future<void> getAll() async {
    try {
      _incomesSubscription = _incomeRepository.getAll().listen((event) {
        allItems = event;
        filteredItems = event;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Error fetching incomes: ${e.toString()}');
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
      debugPrint('Error saving income: ${e.toString()}');
    }
  }

  Map<DateTime, MonthlyIcome> groupIncomesByMonth() {
    return filteredItems.fold({},
        (Map<DateTime, MonthlyIcome> groupedIncomes, income) {
      DateTime monthKey = DateTime(
          income.createdAt.toDate().year, income.createdAt.toDate().month);

      if (!groupedIncomes.containsKey(monthKey)) {
        groupedIncomes[monthKey] = MonthlyIcome(
          id: text.month_format(monthKey).capitalize(),
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

  Map<String, double> get monthlyIncomes {
    final grouped = groupIncomesByMonth();
    final sortedKeys = grouped.keys.toList()..sort();

    return {
      for (var date in sortedKeys)
        text.month_day_format(date): grouped[date]!.total
    };
  }

  Map<String, double> get averageIncomesByDay => calculateAverageByDay(
      (income) => income.createdAt.toDate(), (income) => income.total);

  @override
  void dispose() {
    _incomesSubscription?.cancel();
    super.dispose();
  }
}
