import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/presentation/common/localization/localization_manager.dart';
import '../../../../core/presentation/common/provider/search_provider.dart';
import '../../domain/entities/income.dart';
import '../../domain/entities/montly_income.dart';
import '../../domain/repositories/income_repository.dart';

class IncomeViewModel extends SearchProvider<Income> {
  final IncomeRepository _incomeRepository;

  IncomeViewModel(this._incomeRepository);

  Future<void> getAll() async {
    try {
      _incomeRepository.getAll().listen((event) => allItems = event);

      notifyListeners();
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

  Map<String, double> get monthlyIncomes => {
        for (var entry in groupIncomesByMonth().entries)
          entry.key: entry.value.total
      };

  Map<String, double> get averageIncomesByDay {
    final Map<String, List<double>> incomesByDay = {
      "L": [],
      "M": [],
      "X": [],
      "J": [],
      "V": [],
      "S": [],
      "D": [],
    };

    for (var income in allItems) {
      final dayOfWeek = income.createdAt.toDate().weekday;
      final dayKey = _dayKeyFromWeekday(dayOfWeek);

      if (incomesByDay.containsKey(dayKey)) {
        incomesByDay[dayKey]!.add(income.total);
      }
    }

    final Map<String, double> averageByDay = {};
    for (var entry in incomesByDay.entries) {
      final day = entry.key;
      final totals = entry.value;

      averageByDay[day] = totals.isNotEmpty
          ? totals.reduce((a, b) => a + b) / totals.length
          : 0.0;
    }

    return averageByDay;
  }

  String _dayKeyFromWeekday(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return "L";
      case DateTime.tuesday:
        return "M";
      case DateTime.wednesday:
        return "X";
      case DateTime.thursday:
        return "J";
      case DateTime.friday:
        return "V";
      case DateTime.saturday:
        return "S";
      case DateTime.sunday:
        return "D";
      default:
        throw ArgumentError("Invalid weekday: $weekday");
    }
  }
}
