import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../domain/entities/supplier.dart';

class SupplierProvider with ChangeNotifier {
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
}
