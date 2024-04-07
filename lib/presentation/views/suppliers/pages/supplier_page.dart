import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../../domain/entities/supplier.dart';
import '../../../../inject/inject.dart';
import '../../../common/localization/app_localizations.dart';
import '../../../common/theme/constants/dimens.dart';
import '../../../common/widgets/buttons/custom_appbar.dart';
import '../../../common/widgets/inputs/input_phone.dart';
import '../../../common/widgets/margins/margin_container.dart';
import '../provider/supplier_provider.dart';
import '../view_model/supplier_view_model.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({
    super.key,
    this.supplier,
  });
  final Supplier? supplier;
  static const route = 'supplier_page';

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  final _supplierViewModel = getIt<SupplierViewModel>();
  final _supProvider = getIt<SupplierProvider>();

  @override
  void initState() {
    super.initState();

    _supProvider.addListener(_onProviderStateChanged);

    setFormData();
  }

  setFormData() {
    if (widget.supplier != null) {
      final currentSupplier = widget.supplier!;
      _supProvider.nameController.text = currentSupplier.name;
      _supProvider.cifController.text = currentSupplier.cif ?? '';
      _supProvider.type = currentSupplier.type;
      _supProvider.telController.text =
          clearPhoneEmpty(currentSupplier.tel ?? '');
      _supProvider.localPhone =
          PhoneNumber(isoCode: 'ES', phoneNumber: currentSupplier.tel ?? '');
      _supProvider.contactNameController.text =
          currentSupplier.contactName ?? '';
      _supProvider.phoneController.text =
          clearPhoneEmpty(currentSupplier.phone ?? '');
      _supProvider.contactPhone =
          PhoneNumber(isoCode: 'ES', phoneNumber: currentSupplier.phone ?? '');
      _supProvider.isEnabled = false;
    } else {
      _supProvider.resetForm();
      _supProvider.isEnabled = true;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _supProvider.removeListener(_onProviderStateChanged);
    super.dispose();
  }

  void _onProviderStateChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                title: text.supplier,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: MarginContainer(
                    child: SizedBox(
                      width: Dimens.maxwidth,
                      child: Column(
                        children: [
                          Form(
                            key: _supProvider.formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _supProvider.nameController,
                                  enabled: _supProvider.isEnabled,
                                  decoration:
                                      InputDecoration(labelText: text.name),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return text.errorName;
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _supProvider.cifController,
                                  enabled: _supProvider.isEnabled,
                                  decoration:
                                      const InputDecoration(labelText: 'CIF'),
                                ),
                              ),
                              Expanded(
                                child: DropdownButtonFormField<TypeOfSupplier>(
                                  value: _supProvider.type,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value != null) {
                                        _supProvider.type = value;
                                      }
                                    });
                                  },
                                  items: TypeOfSupplier.values.map((type) {
                                    return DropdownMenuItem<TypeOfSupplier>(
                                      enabled: _supProvider.isEnabled,
                                      value: type,
                                      child:
                                          Text(type.toString().split('.').last),
                                    );
                                  }).toList(),
                                  decoration:
                                      InputDecoration(labelText: text.type),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Dimens.extraHuge,
                            child: InputPhone(
                              phoneController: _supProvider.telController,
                              enabled: _supProvider.isEnabled,
                              number: _supProvider.localPhone,
                              onChanged: (phone) {
                                _supProvider.localPhone = phone;
                              },
                            ),
                          ),
                          TextFormField(
                            controller: _supProvider.contactNameController,
                            enabled: _supProvider.isEnabled,
                            decoration:
                                InputDecoration(labelText: text.contactName),
                          ),
                          SizedBox(
                            height: Dimens.extraHuge,
                            child: InputPhone(
                              phoneController: _supProvider.phoneController,
                              enabled: _supProvider.isEnabled,
                              number: _supProvider.contactPhone,
                              onChanged: (phone) {
                                _supProvider.contactPhone = phone;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.big)),
        onPressed: _supProvider.isEnabled ? onSave : activeEdit,
        tooltip: _supProvider.isEnabled ? text.save : text.edit,
        child: Icon(_supProvider.isEnabled
            ? Icons.save_outlined
            : Icons.edit_note_outlined),
      ),
    );
  }

  activeEdit() {
    _supProvider.isEnabled = !_supProvider.isEnabled;
    setState(() {});
  }

  onSave() async {
    late Supplier supplier;
    if (_supProvider.formKey.currentState!.validate()) {
      supplier = Supplier(
          name: _supProvider.nameController.text,
          type: _supProvider.type,
          cif: _supProvider.cifController.text,
          tel: clearPhoneEmpty(_supProvider.localPhone.phoneNumber),
          contactName: _supProvider.contactNameController.text,
          phone: clearPhoneEmpty(_supProvider.contactPhone.phoneNumber));

      // update
      if (widget.supplier != null) {
        await _supplierViewModel.updateOne(widget.supplier!.id!, supplier);
        _supProvider.isEnabled = !_supProvider.isEnabled;
        setState(() {});
      } else {
        // save
        await _supplierViewModel.saveOne(supplier);
        _supProvider.resetForm();
      }
    }
  }

  String clearPhoneEmpty(String? phone) {
    if (phone != null && phone.length > 3) {
      return phone.toString().replaceAll(RegExp(r'\s+'), '');
    }

    return '';
  }
}
