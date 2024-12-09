import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

import '../localization/localization_manager.dart';
import '../utils/local_dates.dart';

class SearchProvider<T> with ChangeNotifier {
  List<T> _allItems = [];
  List<T> _filteredItems = [];

  void search(String query, String Function(T) filter) {
    _filteredItems = _allItems.where((item) {
      return removeDiacritics(filter(item).toLowerCase())
          .contains(removeDiacritics(query.toLowerCase()));
    }).toList();

    notifyListeners();
  }

  List<T> get filteredItems => _filteredItems;
  List<T> get allItems => _allItems;

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  void searchClean() {
    _searchController.clear();
    search('', (item) => '');
  }

  set allItems(List<T> values) {
    _allItems = values;
    notifyListeners();
  }

  set filteredItems(List<T> values) {
    _filteredItems = values;
    notifyListeners();
  }

  Map<String, double> calculateAverageByDay(
      DateTime Function(T) getCreatedAt, double Function(T) getTotal) {
    final Map<String, List<double>> valuesByDay = {
      text.day_monday_short: [],
      text.day_tuesday_short: [],
      text.day_wednesday_short: [],
      text.day_thursday_short: [],
      text.day_friday_short: [],
      text.day_saturday_short: [],
      text.day_sunday_short: [],
    };

    for (var item in allItems) {
      final dayOfWeek = getCreatedAt(item).weekday;
      final dayKey = LocalDates.dayKeyFromWeekday(dayOfWeek);

      valuesByDay[dayKey]?.add(getTotal(item));
    }

    final Map<String, double> averageByDay = {};
    for (var entry in valuesByDay.entries) {
      final day = entry.key;
      final totals = entry.value;

      averageByDay[day] = totals.isNotEmpty
          ? totals.reduce((a, b) => a + b) / totals.length
          : 0.0;
    }

    return averageByDay;
  }
}
