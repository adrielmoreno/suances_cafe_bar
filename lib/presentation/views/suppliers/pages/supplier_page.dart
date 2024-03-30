import 'package:flutter/material.dart';

import '../../../../domain/entities/supplier.dart';
import '../../../common/theme/constants/dimens.dart';
import '../../../common/widgets/buttons/custom_appbar.dart';
import '../../../common/widgets/inputs/input_phone.dart';
import '../../../common/widgets/margins/margin_container.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({
    super.key,
  });

  static const route = 'supplier_page';

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _cifController = TextEditingController();
  final _telController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _phoneController = TextEditingController();
  TypeOfSupplier? _type = TypeOfSupplier.food;

  final bool _isEdited = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(
                title: 'Suplidor',
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: MarginContainer(
                    child: SizedBox(
                      width: Dimens.maxwidth,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration:
                                  const InputDecoration(labelText: 'Nombre'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Este campo no puede estar vacío';
                                }
                                return null;
                              },
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _cifController,
                                    decoration:
                                        const InputDecoration(labelText: 'CIF'),
                                  ),
                                ),
                                Expanded(
                                  child:
                                      DropdownButtonFormField<TypeOfSupplier>(
                                    value: _type,
                                    onChanged: (value) {
                                      setState(() {
                                        _type = value;
                                      });
                                    },
                                    items: TypeOfSupplier.values.map((type) {
                                      return DropdownMenuItem<TypeOfSupplier>(
                                        value: type,
                                        child: Text(
                                            type.toString().split('.').last),
                                      );
                                    }).toList(),
                                    decoration: const InputDecoration(
                                        labelText: 'Tipo'),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Dimens.extraHuge,
                              child: InputPhone(
                                phoneController: _telController,
                                onChanged: (phone) {
                                  _telController.text = phone.phoneNumber
                                      .toString()
                                      .replaceAll(RegExp(r'\s+'), '');
                                },
                              ),
                            ),
                            TextFormField(
                              controller: _contactNameController,
                              decoration: const InputDecoration(
                                  labelText: 'Nombre de contacto'),
                            ),
                            SizedBox(
                              height: Dimens.extraHuge,
                              child: InputPhone(
                                phoneController: _phoneController,
                                onChanged: (phone) {
                                  _phoneController.text = phone.phoneNumber
                                      .toString()
                                      .replaceAll(RegExp(r'\s+'), '');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
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
