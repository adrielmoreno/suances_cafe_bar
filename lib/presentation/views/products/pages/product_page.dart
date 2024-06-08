import 'package:flutter/material.dart';

import '../../../../data/db_services/firebase_db.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/supplier.dart';
import '../../../../inject/inject.dart';
import '../../../common/localization/localization_manager.dart';
import '../../../common/theme/constants/app_colors.dart';
import '../../../common/theme/constants/dimens.dart';
import '../../../common/widgets/buttons/custom_appbar.dart';
import '../../../common/widgets/margins/margin_container.dart';
import '../../suppliers/provider/supplier_provider.dart';
import '../provider/producto_provider.dart';
import '../view_model/product_view_model.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    super.key,
    this.product,
  });
  final Product? product;

  static const route = 'product_page';

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _productViewModel = getIt<ProductViewModel>();
  final _prodProvider = getIt<ProductProvider>();
  final _db = getIt<FirebaseDB>();

  final _supProvider = getIt<SupplierProvider>();

  @override
  void initState() {
    super.initState();

    _prodProvider.addListener(_onProviderStateChanged);

    setFormData();
  }

  setFormData() async {
    if (widget.product != null) {
      final currentProduct = widget.product!;
      _prodProvider.nameController.text = currentProduct.name;

      _prodProvider.packagingController.text =
          currentProduct.packaging.toString();

      _prodProvider.measureController.text = currentProduct.measure ?? '';

      _prodProvider.pricePackingController.text =
          currentProduct.pricePacking.toString();

      _prodProvider.priceUnitController.text =
          currentProduct.priceUnit.toString();

      _prodProvider.ivaController.text = currentProduct.iva.toString();

      _prodProvider.pricePlusIVA.text = currentProduct.pricePlusIVA.toString();

      _prodProvider.lastSupplier = currentProduct.lastSupplier != null
          ? _supProvider.allItems
              .where((element) =>
                  element.id == '${currentProduct.lastSupplier?.id}')
              .first
          : null;

      _prodProvider.isEnabled = false;
    } else {
      _prodProvider.resetForm();
      _prodProvider.isEnabled = true;
    }

    setState(() {});
  }

  @override
  void dispose() {
    _prodProvider.removeListener(_onProviderStateChanged);
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
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                title: text.product,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: MarginContainer(
                    child: Form(
                      key: _prodProvider.formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _prodProvider.nameController,
                            enabled: _prodProvider.isEnabled,
                            decoration: InputDecoration(labelText: text.name),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return text.errorName;
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
                                  enabled: _prodProvider.isEnabled,
                                  controller: _prodProvider.packagingController,
                                  decoration: InputDecoration(
                                      labelText: text.packaging),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return text.errorEmpty;
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setUniPrice();
                                    sePricePlusIVA();
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  enabled: _prodProvider.isEnabled,
                                  controller: _prodProvider.measureController,
                                  decoration:
                                      InputDecoration(labelText: text.measure),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return text.errorEmpty;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller:
                                      _prodProvider.pricePackingController,
                                  enabled: _prodProvider.isEnabled,
                                  decoration: InputDecoration(
                                      labelText: text.pricePacking),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  onChanged: (value) {
                                    setUniPrice();
                                    sePricePlusIVA();
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return text.errorEmpty;
                                    }
                                    return null;
                                  },
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
                                  enabled: _prodProvider.isEnabled,
                                  controller: _prodProvider.priceUnitController,
                                  decoration: InputDecoration(
                                      labelText: text.priceUnit),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  enabled: _prodProvider.isEnabled,
                                  controller: _prodProvider.ivaController,
                                  decoration:
                                      InputDecoration(labelText: text.iva),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _prodProvider.iva =
                                          double.tryParse(value) ?? 0.0;
                                    });
                                    sePricePlusIVA();
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  enabled: _prodProvider.isEnabled,
                                  controller: _prodProvider.pricePlusIVA,
                                  decoration: InputDecoration(
                                      labelText: text.lastPrice),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          DropdownButtonFormField<Supplier>(
                            isExpanded: true,
                            value: _prodProvider.lastSupplier,
                            hint: Text(text.lastSupplier),
                            items: _supProvider.allItems
                                .asMap()
                                .entries
                                .map((entry) {
                              final Supplier supplier = entry.value;
                              return DropdownMenuItem<Supplier>(
                                enabled: _prodProvider.isEnabled,
                                value: supplier,
                                child: SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        color: (_prodProvider.lastSupplier ==
                                                supplier)
                                            ? AppColors.secondaryContainerLight
                                            : null,
                                        child: Text(supplier.name),
                                      ),
                                      const Divider()
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _prodProvider.lastSupplier = value;
                              });
                            },
                          )
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
        onPressed: _prodProvider.isEnabled ? onSave : activeEdit,
        tooltip: _prodProvider.isEnabled ? text.save : text.edit,
        child: Icon(_prodProvider.isEnabled
            ? Icons.save_outlined
            : Icons.edit_note_outlined),
      ),
    );
  }

  activeEdit() {
    setState(() {
      _prodProvider.isEnabled = !_prodProvider.isEnabled;
    });
  }

  onSave() async {
    late Product product;
    if (_prodProvider.formKey.currentState!.validate()) {
      product = Product(
        name: _prodProvider.nameController.text,
        packaging: replaceComma(_prodProvider.packagingController.text),
        measure: _prodProvider.measureController.text,
        pricePacking: replaceComma(_prodProvider.pricePackingController.text),
        priceUnit: getUniPrice(
          pricePacking: replaceComma(_prodProvider.pricePackingController.text),
          packaging: replaceComma(_prodProvider.packagingController.text),
        ),
        iva: _prodProvider.iva,
        pricePlusIVA: getPricePlusIVA(
          pricePacking: replaceComma(_prodProvider.pricePackingController.text),
          packaging: replaceComma(_prodProvider.packagingController.text),
        ),
        lastSupplier: _prodProvider.lastSupplier != null
            ? await _db.getReference(
                _prodProvider.lastSupplier!.id!, FBCollection.suppliers)
            : null,
      );

      if (widget.product != null) {
        await _productViewModel.updateOne(widget.product!.id!, product);
        _prodProvider.isEnabled = !_prodProvider.isEnabled;
      } else {
        await _productViewModel.saveOne(product);
        _prodProvider.resetForm();
      }
    }
  }

  double getUniPrice({double pricePacking = 0, double packaging = 0}) {
    final total = pricePacking / packaging;
    return double.parse(total.toStringAsFixed(2));
  }

  double getPricePlusIVA({double pricePacking = 0, double packaging = 0}) {
    final unitPrice =
        getUniPrice(pricePacking: pricePacking, packaging: packaging);
    final taxes = unitPrice * _prodProvider.iva / 100;
    final total = unitPrice + taxes;

    return double.parse(total.toStringAsFixed(2));
  }

  double replaceComma(String value) {
    return double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
  }

  void setUniPrice() {
    if (_prodProvider.pricePackingController.text.isNotEmpty &&
        _prodProvider.packagingController.text.isNotEmpty) {
      _prodProvider.priceUnitController.text = getUniPrice(
        pricePacking: replaceComma(_prodProvider.pricePackingController.text),
        packaging: replaceComma(_prodProvider.packagingController.text),
      ).toStringAsFixed(2);
    } else {
      _prodProvider.priceUnitController.clear();
    }
    setState(() {});
  }

  void sePricePlusIVA() {
    if (_prodProvider.pricePackingController.text.isNotEmpty &&
        _prodProvider.packagingController.text.isNotEmpty) {
      _prodProvider.pricePlusIVA.text = getPricePlusIVA(
        pricePacking: replaceComma(_prodProvider.pricePackingController.text),
        packaging: replaceComma(_prodProvider.packagingController.text),
      ).toStringAsFixed(2);
    } else {
      _prodProvider.pricePlusIVA.clear();
    }
    setState(() {});
  }
}
