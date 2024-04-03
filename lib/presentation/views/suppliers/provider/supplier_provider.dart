import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../../domain/entities/supplier.dart';

class SupplierProvider with ChangeNotifier {
  // ---- Search -----
  List<Supplier> _allSuppliers = [];
  List<Supplier> _filteredSuppliers = [];

  supplierSearchProvider(List<Supplier> suppliers) {
    _allSuppliers = suppliers;
    _filteredSuppliers = suppliers;
  }

  void search(String query) {
    _filteredSuppliers = _allSuppliers.where((supplier) {
      return removeDiacritics(supplier.name.toLowerCase())
          .contains(removeDiacritics(query.toLowerCase()));
    }).toList();
    notifyListeners();
  }

  List<Supplier> get filteredSuppliers => _filteredSuppliers;

  final TextEditingController _searchController =
      TextEditingController(); // Controlador de búsqueda
  TextEditingController get searchController => _searchController;

  void searchClean() {
    _searchController.clear();
    search('');
    notifyListeners();
  }

  // ---- End search -----

  // ---- form -----
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cifController = TextEditingController();
  final _telController = TextEditingController();
  PhoneNumber localPhone = PhoneNumber(isoCode: 'ES');
  final _contactNameController = TextEditingController();
  final _phoneController = TextEditingController();
  PhoneNumber contactPhone = PhoneNumber(isoCode: 'ES');

  TypeOfSupplier _type = TypeOfSupplier.food;

  bool _isEnabled = true;

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get nameController => _nameController;
  TextEditingController get cifController => _cifController;
  TextEditingController get telController => _telController;
  TextEditingController get contactNameController => _contactNameController;
  TextEditingController get phoneController => _phoneController;
  TypeOfSupplier get type => _type;
  bool get isEnabled => _isEnabled;

  set type(TypeOfSupplier value) {
    _type = value;
    notifyListeners();
  }

  set isEnabled(bool value) {
    _isEnabled = value;
    notifyListeners();
  }

  void resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _cifController.clear();
    _telController.clear();
    localPhone = PhoneNumber(isoCode: 'ES');
    _contactNameController.clear();
    _phoneController.clear();
    contactPhone = PhoneNumber(isoCode: 'ES');
    _type = TypeOfSupplier.food;
    notifyListeners();
  }
  // ---- End form -----
}
