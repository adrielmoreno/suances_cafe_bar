import 'package:flutter/material.dart';

import '../../../../app/di/inject.dart';
import '../../../../core/presentation/common/enums/type_of_supplier.dart';
import '../../../../core/presentation/common/localization/localization_manager.dart';
import '../../../../core/presentation/common/theme/constants/dimens.dart';
import '../../../../core/presentation/common/widgets/buttons/custom_appbar.dart';
import '../../../../core/presentation/common/widgets/buttons/text_icon_button.dart';
import '../../../../core/presentation/common/widgets/inputs/custom_dropdown.dart';
import '../../../../core/presentation/common/widgets/inputs/custom_text_form_field.dart';
import '../../../../core/presentation/common/widgets/inputs/input_phone.dart';
import '../../../../core/presentation/common/widgets/margins/margin_container.dart';
import '../../domain/entities/supplier.dart';
import '../forms/supplier_form.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({
    super.key,
    this.supplier,
  });
  final Supplier? supplier;

  static const route = 'supplier-page';

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  final _supplierForm = getIt<SupplierForm>();

  @override
  void initState() {
    super.initState();

    _supplierForm.addListener(_onUpdate);

    _initializeFormData();
  }

  void _initializeFormData() async {
    if (widget.supplier != null) {
      _supplierForm.loadSupplierData(widget.supplier!);
    } else {
      _supplierForm.resetForm();
    }
    _onUpdate();
  }

  @override
  void dispose() {
    _supplierForm.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  activeEdit() {
    setState(() {
      _supplierForm.isEnabled = !_supplierForm.isEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Column(
                      children: [
                        Form(
                          key: _supplierForm.formKey,
                          child: Column(
                            children: [
                              CustomTextFormField(
                                controller: _supplierForm.nameController,
                                enabled: _supplierForm.isEnabled,
                                labelText: text.name,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextFormField(
                                      controller: _supplierForm.cifController,
                                      enabled: _supplierForm.isEnabled,
                                      labelText: 'CIF',
                                      validator: (value) {
                                        final RegExp dniNieCifRegExp = RegExp(
                                            r'^(?:[XYZ]\d{7}[A-Z]|[A-HJ-NP-SUVW]\d{7}[A-Z0-9]|\d{8}[A-Z])$');

                                        if (value != null &&
                                            value.isNotEmpty &&
                                            !dniNieCifRegExp.hasMatch(value)) {
                                          return 'Formato no válido';
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: Dimens.medium,
                                  ),
                                  Expanded(
                                    child: CustomDropDown<TypeOfSupplier>(
                                      value: _supplierForm.type,
                                      items: TypeOfSupplier.values,
                                      labelText: text.type,
                                      getItemLabel: (supplier) =>
                                          supplier.getName,
                                      getItemIcon: (supplier) =>
                                          supplier.getIconData,
                                      onChanged: (value) {
                                        if (value != null) {
                                          _supplierForm.type = value;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: Dimens.extraHuge,
                          child: InputPhone(
                            phoneController: _supplierForm.telController,
                            enabled: _supplierForm.isEnabled,
                            number: _supplierForm.localPhone,
                            onChanged: (phone) {
                              _supplierForm.localPhone = phone;
                            },
                          ),
                        ),
                        TextFormField(
                          controller: _supplierForm.contactNameController,
                          enabled: _supplierForm.isEnabled,
                          decoration:
                              InputDecoration(labelText: text.contactName),
                        ),
                        SizedBox(
                          height: Dimens.extraHuge,
                          child: InputPhone(
                            phoneController: _supplierForm.phoneController,
                            enabled: _supplierForm.isEnabled,
                            number: _supplierForm.contactPhone,
                            onChanged: (phone) {
                              _supplierForm.contactPhone = phone;
                            },
                          ),
                        ),
                        // BUTTON
                        const SizedBox(height: Dimens.semiBig),
                        SizedBox(
                          width: double.infinity,
                          child: TextIconButton(
                            onPressed: () => _supplierForm.isEnabled
                                ? _supplierForm
                                    .saveOrUpdateSupplier(widget.supplier)
                                : activeEdit(),
                            label:
                                _supplierForm.isEnabled ? text.save : text.edit,
                            iconData: _supplierForm.isEnabled
                                ? Icons.save_outlined
                                : Icons.edit_note_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
