import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

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
}
