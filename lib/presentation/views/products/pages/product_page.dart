import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../data/DBServices/firebase_db.dart';
import '../../../../data/mappable/mappable.dart';
import '../../../../data/product/data_impl/product_data_impl.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/supplier.dart';
import '../../../../inject/inject.dart';
import '../../../common/interfaces/resource_state.dart';
import '../../../common/localization/app_localizations.dart';
import '../../../common/theme/constants/dimens.dart';
import '../../../common/widgets/buttons/custom_appbar.dart';
import '../../../common/widgets/margins/margin_container.dart';
import '../../suppliers/provider/supplier_provider.dart';
import '../../suppliers/view_model/supplier_view_model.dart';
import '../provider/producto_provider.dart';

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
  final _productRep = getIt<ProductDataImpl>();
  final _prodProvider = getIt<ProductProvider>();

  final _supProvider = getIt<SupplierProvider>();
  final _supplierViewModel = getIt<SupplierViewModel>();

  @override
  void initState() {
    super.initState();

    _supplierViewModel.getAllState.stream.listen((event) {
      switch (event.state) {
        case Status.LOADING:
          // TODO: Implement loading...
          log('Cargando...');
          break;
        case Status.COMPLETED:
          setState(() {
            _supProvider.supplierSearchProvider(event.data);
          });
          break;
        // TODO: Implement error...
        default:
      }
    });

    if (_supProvider.allSuppliers.isEmpty) {
      _supplierViewModel.getAll();
    }

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
      _prodProvider.lastSupplier = currentProduct.lastSupplier != null
          ? await getObjectFromRef(
              currentProduct.lastSupplier!, Supplier.fromMap)
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
    _supplierViewModel.close();
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
    final text = AppLocalizations.of(context)!;
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
                    child: SizedBox(
                      width: Dimens.maxwidth,
                      child: Form(
                        key: _prodProvider.formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _prodProvider.nameController,
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
                                    controller:
                                        _prodProvider.packagingController,
                                    decoration: InputDecoration(
                                        labelText: text.packaging),
                                    keyboardType: TextInputType.number,
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
                                    controller: _prodProvider.measureController,
                                    decoration: InputDecoration(
                                        labelText: text.measure),
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
                                    decoration: InputDecoration(
                                        labelText: text.pricePacking),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    onChanged: (value) {
                                      if (value.isNotEmpty &&
                                          _prodProvider.packagingController.text
                                              .isNotEmpty) {
                                        setUniPrice();
                                      } else {
                                        _prodProvider.priceUnitController
                                            .clear();
                                      }
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
                                    controller:
                                        _prodProvider.priceUnitController,
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
                                    readOnly: true,
                                    controller:
                                        _prodProvider.lastPriceController,
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
                              items: _supProvider.allSuppliers
                                  .map((e) => DropdownMenuItem(
                                      value: e, child: Text(e.name)))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _prodProvider.lastSupplier = value;
                                });
                              },
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
    _prodProvider.isEnabled = !_prodProvider.isEnabled;
    setState(() {});
  }

  onSave() async {
    late Product product;
    if (_prodProvider.formKey.currentState!.validate()) {
      product = Product(
        name: _prodProvider.nameController.text,
        packaging: replaceComma(_prodProvider.packagingController.text),
        measure: _prodProvider.measureController.text,
        pricePacking: double.parse(_prodProvider.pricePackingController.text),
        priceUnit: getUniPrice(
          pricePacking: replaceComma(_prodProvider.pricePackingController.text),
          packaging: replaceComma(_prodProvider.packagingController.text),
        ),
        lastSupplier: _prodProvider.lastSupplier != null
            ? await FirebaseDB.getReference(
                _prodProvider.lastSupplier!.id!, FBCollection.products)
            : null,
      );
      if (widget.product != null) {
        await _productRep.updateOne(widget.product!.id!, product);
        _prodProvider.isEnabled = !_prodProvider.isEnabled;
      } else {
        await _productRep.saveOne(product);
        _prodProvider.resetForm();
      }
    }
  }

  double getUniPrice({double pricePacking = 0, double packaging = 0}) {
    final total = pricePacking / packaging;
    return total;
  }

  double replaceComma(String value) {
    return double.parse(
      value.replaceAll(',', '.'),
    );
  }

  void setUniPrice() {
    _prodProvider.priceUnitController.text = getUniPrice(
      pricePacking: replaceComma(_prodProvider.pricePackingController.text),
      packaging: replaceComma(_prodProvider.packagingController.text),
    ).toStringAsFixed(2);
  }
}
