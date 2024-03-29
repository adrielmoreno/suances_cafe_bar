import 'package:flutter/material.dart';

import '../../../common/theme/constants/dimens.dart';
import '../../../common/widgets/buttons/custom_appbar.dart';
import '../../../common/widgets/margins/margin_container.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    super.key,
  });

  static const route = 'product_page';

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _packagingController = TextEditingController();
  final _measureController = TextEditingController();
  final _pricePackingController = TextEditingController();
  final _priceUnitController = TextEditingController();
  final _lastPriceController = TextEditingController();
  final _lastSupplierController = TextEditingController();

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
                title: 'Producto',
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
                                  return 'Por favor, ingrese un nombre.';
                                }
                                return null;
                              },
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _packagingController,
                                    decoration: const InputDecoration(
                                        labelText: 'Empaque'),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: _measureController,
                                    decoration: const InputDecoration(
                                        labelText: 'medida'),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: _pricePackingController,
                                    decoration: const InputDecoration(
                                        labelText: 'Precio empaque'),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: _priceUnitController,
                                    decoration: const InputDecoration(
                                        labelText: 'Precio por unidad'),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: _lastPriceController,
                                    decoration: const InputDecoration(
                                        labelText: 'Último precio'),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TextFormField(
                              controller: _lastSupplierController,
                              decoration: const InputDecoration(
                                  labelText: 'Último proveedor'),
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
