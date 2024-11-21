import 'package:flutter/material.dart';

import '../../../../app/di/inject.dart';
import '../../../../core/data/db_services/firebase_db.dart';
import '../../../../domain/entities/supplier.dart';
import '../../../../presentation/common/localization/localization_manager.dart';
import '../../../../presentation/common/theme/constants/app_colors.dart';
import '../../../../presentation/common/theme/constants/dimens.dart';
import '../../../../presentation/common/utils/format_helper.dart';
import '../../../../presentation/common/widgets/buttons/custom_appbar.dart';
import '../../../../presentation/common/widgets/buttons/text_icon_button.dart';
import '../../../../presentation/common/widgets/inputs/custom_decimal_input.dart';
import '../../../../presentation/common/widgets/inputs/custom_text_form_field.dart';
import '../../../../presentation/common/widgets/margins/margin_container.dart';
import '../../domain/entities/product.dart';
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

  @override
  void initState() {
    super.initState();

    _productViewModel.addListener(_onUpdate);

    _initializeFormData();
  }

  void _initializeFormData() async {
    if (widget.product != null) {
      _loadProductData(widget.product!);
      _productViewModel.isEnabled = false;
    } else {
      _productViewModel.resetForm();
      _productViewModel.isEnabled = true;
    }
    _onUpdate();
  }

  _loadProductData(Product product) async {
    _productViewModel.nameController.text = product.name;
    _productViewModel.packagingController.text = product.packaging.toString();
    _productViewModel.measureController.text = product.measure;
    _productViewModel.pricePackingController.text =
        product.pricePacking.toString();
    _productViewModel.priceUnitController.text = product.priceUnit.toString();
    _productViewModel.ivaController.text = product.iva.toString();
    _productViewModel.pricePlusIVA.text = product.pricePlusIVA.toString();
    _productViewModel.lastSupplier = product.lastSupplier != null
        ? (await product.lastSupplier?.get())?.data()
        : null;
  }

  @override
  void dispose() {
    _productViewModel.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
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
                      key: _productViewModel.formKey,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            controller: _productViewModel.nameController,
                            enabled: _productViewModel.isEnabled,
                            labelText: text.name,
                          ),
                          const SizedBox(height: Dimens.medium),
                          _buildPackagingRow(),
                          const SizedBox(height: Dimens.medium),
                          _buildPriceRow(),
                          const SizedBox(height: Dimens.medium),
                          _buildSupplierDropdown(),
                          const SizedBox(height: Dimens.semiBig),
                          SizedBox(
                            width: double.infinity,
                            child: TextIconButton(
                              onPressed: () => _productViewModel.isEnabled
                                  ? _productViewModel
                                      .saveOrUpdateProduct(widget.product)
                                  : activeEdit(),
                              label: _productViewModel.isEnabled
                                  ? text.save
                                  : text.edit,
                              iconData: _productViewModel.isEnabled
                                  ? Icons.save_outlined
                                  : Icons.edit_note_outlined,
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
    );
  }

  activeEdit() {
    setState(() {
      _productViewModel.isEnabled = !_productViewModel.isEnabled;
    });
  }

  Row _buildPackagingRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: CustomDecimalInput(
            enabled: _productViewModel.isEnabled,
            controller: _productViewModel.packagingController,
            labelText: text.packaging,
            onChanged: (_) => _productViewModel.updatePrices(),
          ),
        ),
        const SizedBox(
          width: Dimens.medium,
        ),
        Expanded(
          child: CustomTextFormField(
              enabled: _productViewModel.isEnabled,
              controller: _productViewModel.measureController,
              labelText: text.measure),
        ),
        const SizedBox(
          width: Dimens.medium,
        ),
        Expanded(
          child: CustomDecimalInput(
              controller: _productViewModel.pricePackingController,
              enabled: _productViewModel.isEnabled,
              labelText: text.pricePacking,
              onChanged: (value) {
                _productViewModel.updatePrices();
              }),
        ),
      ],
    );
  }

  Row _buildPriceRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: CustomDecimalInput(
            readOnly: true,
            enabled: _productViewModel.isEnabled,
            controller: _productViewModel.priceUnitController,
            labelText: text.priceUnit,
          ),
        ),
        const SizedBox(
          width: Dimens.medium,
        ),
        Expanded(
          child: CustomDecimalInput(
            enabled: _productViewModel.isEnabled,
            controller: _productViewModel.ivaController,
            labelText: text.iva,
            onChanged: (value) {
              _productViewModel.iva = FormatHelper.parseInput(value);

              _productViewModel.updatePrices();
            },
          ),
        ),
        const SizedBox(
          width: Dimens.medium,
        ),
        Expanded(
          child: CustomDecimalInput(
            readOnly: true,
            enabled: _productViewModel.isEnabled,
            controller: _productViewModel.pricePlusIVA,
            labelText: text.lastPrice,
          ),
        ),
      ],
    );
  }

  Widget _buildSupplierDropdown() {
    return FutureBuilder(
      future: getIt<FirebaseDB>().suppliers.get(),
      builder: (context, snap) {
        final suppliers = snap.data?.docs.map((doc) => doc.data()).toList();
        return DropdownButtonFormField<Supplier>(
          isExpanded: true,
          value: _productViewModel.lastSupplier,
          hint: Text(text.lastSupplier),
          items: suppliers?.map((supplier) {
            return DropdownMenuItem<Supplier>(
              enabled: _productViewModel.isEnabled,
              value: supplier,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: (_productViewModel.lastSupplier == supplier)
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
            _productViewModel.lastSupplier = value;
          },
        );
      },
    );
  }
}
