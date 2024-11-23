import 'package:flutter/material.dart';

import '../../../../app/di/inject.dart';
import '../../../../core/data/db_services/firebase_db.dart';
import '../../../../core/presentation/common/localization/localization_manager.dart';
import '../../../../core/presentation/common/theme/constants/app_colors.dart';
import '../../../../core/presentation/common/theme/constants/dimens.dart';
import '../../../../core/presentation/common/utils/format_helper.dart';
import '../../../../core/presentation/common/widgets/buttons/custom_appbar.dart';
import '../../../../core/presentation/common/widgets/buttons/text_icon_button.dart';
import '../../../../core/presentation/common/widgets/inputs/custom_decimal_input.dart';
import '../../../../core/presentation/common/widgets/inputs/custom_text_form_field.dart';
import '../../../../core/presentation/common/widgets/margins/margin_container.dart';
import '../../../suppliers/domain/entities/supplier.dart';
import '../../domain/entities/product.dart';
import '../forms/product_form.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    super.key,
    this.product,
  });
  final Product? product;

  static const route = 'product-page';

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _productForm = getIt<ProductForm>();

  @override
  void initState() {
    super.initState();

    _productForm.addListener(_onUpdate);

    _initializeFormData();
  }

  void _initializeFormData() async {
    if (widget.product != null) {
      _productForm.loadProductData(widget.product!);
    } else {
      _productForm.resetForm();
    }
    _onUpdate();
  }

  @override
  void dispose() {
    _productForm.removeListener(_onUpdate);
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
      _productForm.isEnabled = !_productForm.isEnabled;
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
                      key: _productForm.formKey,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            controller: _productForm.nameController,
                            enabled: _productForm.isEnabled,
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
                              onPressed: () => _productForm.isEnabled
                                  ? _productForm
                                      .saveOrUpdateProduct(widget.product)
                                  : activeEdit(),
                              label: _productForm.isEnabled
                                  ? text.save
                                  : text.edit,
                              iconData: _productForm.isEnabled
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

  Widget _buildPackagingRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: CustomDecimalInput(
            enabled: _productForm.isEnabled,
            controller: _productForm.packagingController,
            labelText: text.packaging,
            onChanged: (_) => _productForm.updatePrices(),
          ),
        ),
        const SizedBox(
          width: Dimens.medium,
        ),
        Expanded(
          child: CustomTextFormField(
              enabled: _productForm.isEnabled,
              controller: _productForm.measureController,
              labelText: text.measure),
        ),
        const SizedBox(
          width: Dimens.medium,
        ),
        Expanded(
          child: CustomDecimalInput(
              controller: _productForm.pricePackingController,
              enabled: _productForm.isEnabled,
              labelText: text.pricePacking,
              onChanged: (value) {
                _productForm.updatePrices();
              }),
        ),
      ],
    );
  }

  Widget _buildPriceRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: CustomDecimalInput(
            readOnly: true,
            enabled: _productForm.isEnabled,
            controller: _productForm.priceUnitController,
            labelText: text.priceUnit,
          ),
        ),
        const SizedBox(
          width: Dimens.medium,
        ),
        Expanded(
          child: CustomDecimalInput(
            enabled: _productForm.isEnabled,
            controller: _productForm.ivaController,
            labelText: text.iva,
            onChanged: (value) {
              _productForm.iva = FormatHelper.parseInput(value);

              _productForm.updatePrices();
            },
          ),
        ),
        const SizedBox(
          width: Dimens.medium,
        ),
        Expanded(
          child: CustomDecimalInput(
            readOnly: true,
            enabled: _productForm.isEnabled,
            controller: _productForm.pricePlusIVA,
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
          value: _productForm.lastSupplier,
          hint: Text(text.lastSupplier),
          items: suppliers?.map((supplier) {
            return DropdownMenuItem<Supplier>(
              enabled: _productForm.isEnabled,
              value: supplier,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: (_productForm.lastSupplier == supplier)
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
            _productForm.lastSupplier = value;
          },
        );
      },
    );
  }
}
