import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/di/inject.dart';
import '../../../../core/presentation/common/enums/type_of_supplier.dart';
import '../../domain/entities/supplier.dart';
import '../view_model/supplier_view_model.dart';

class SupplierForm extends ChangeNotifier {
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
    // Active inputs
    isEnabled = true;
    notifyListeners();
  }

  Future<void> saveOrUpdateSupplier(Supplier? supplier) async {
    if (!formKey.currentState!.validate()) return;

    final newSupplier = Supplier(
        id: supplier?.id ?? const Uuid().v4(),
        name: nameController.text,
        type: type,
        cif: cifController.text,
        tel: clearPhoneEmpty(localPhone.phoneNumber),
        contactName: contactNameController.text,
        phone: clearPhoneEmpty(contactPhone.phoneNumber));

    // update
    if (supplier != null) {
      await getIt<SupplierViewModel>().updateOne(newSupplier);
      isEnabled = false;
    } else {
      // save
      await getIt<SupplierViewModel>().saveOne(newSupplier);
      resetForm();
    }
  }

  loadSupplierData(Supplier supplier) {
    nameController.text = supplier.name;
    cifController.text = supplier.cif ?? '';
    type = supplier.type;
    telController.text = clearPhoneEmpty(supplier.tel ?? '');
    localPhone = PhoneNumber(isoCode: 'ES', phoneNumber: supplier.tel ?? '');
    contactNameController.text = supplier.contactName ?? '';
    phoneController.text = clearPhoneEmpty(supplier.phone ?? '');
    contactPhone =
        PhoneNumber(isoCode: 'ES', phoneNumber: supplier.phone ?? '');
    // active inputs
    isEnabled = false;
  }

  String clearPhoneEmpty(String? phone) {
    if (phone != null && phone.length > 3) {
      return phone.toString().replaceAll(RegExp(r'\s+'), '');
    }

    return '';
  }
}
