import 'package:flutter/material.dart';

import '../../../../app/di/inject.dart';
import '../../../../core/presentation/common/localization/localization_manager.dart';
import '../../../../core/presentation/common/theme/constants/app_colors.dart';
import '../../../../core/presentation/common/theme/constants/dimens.dart';
import '../../../../core/presentation/common/widgets/inputs/custom_searchbar.dart';
import '../../../products/presentation/view_model/product_view_model.dart';
import '../../../suppliers/domain/entities/supplier.dart';
import '../../../suppliers/presentation/view_model/supplier_view_model.dart';
import '../../domain/entities/orden.dart';
import '../providers/order_provider.dart';
import '../widgets/item_to_order.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({
    super.key,
  });

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final _productViewModel = getIt<ProductViewModel>();

  late FocusNode focusNode;
  final _supplierViewModel = getIt<SupplierViewModel>();

  final _orderProvider = getIt<OrderProvider>();

  @override
  void initState() {
    super.initState();

    _productViewModel.addListener(_onProviderStateChanged);

    _productViewModel.getAll();

    focusNode = FocusNode();

    if (_supplierViewModel.allItems.isEmpty) {
      _supplierViewModel.getAll();
    }
  }

  @override
  void dispose() {
    focusNode.dispose();

    _productViewModel.removeListener(_onProviderStateChanged);
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
    return Column(
      children: [
        CustomSearchBar(
            focusNode: focusNode,
            controller: _productViewModel.searchController,
            hint: text.productName,
            onChanged: (value) =>
                _productViewModel.search(value, (product) => product.name),
            onClear: () {
              focusNode.unfocus();
              _productViewModel.searchClean();
              setFilter(null);
            }),
        // ---- Supplier
        productFilteredBySupplier(),

        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: _productViewModel.filteredItems.length,
            itemBuilder: (context, index) {
              final order =
                  Order(product: _productViewModel.filteredItems[index]);
              return ItemToOrder(
                order: order,
              );
            },
          ),
        ),
      ],
    );
  }

  DropdownButtonFormField<Supplier> productFilteredBySupplier() {
    return DropdownButtonFormField<Supplier>(
      isExpanded: true,
      value: _orderProvider.selectedSupplier,
      items: [
        // ---- Suppliers ----
        DropdownMenuItem<Supplier>(
          value: null,
          child: SizedBox(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => setFilter(null),
                  child: const Icon(
                    color: AppColors.shadowLight,
                    Icons.restart_alt_outlined,
                    size: Dimens.semiBig,
                  ),
                ),
                const SizedBox(
                  width: Dimens.medium,
                ),
                Text(
                  text.no_supplier,
                  selectionColor: Colors.red,
                ),
              ],
            ),
          ),
        ),
        ..._supplierViewModel.allItems.map((supplier) {
          return DropdownMenuItem<Supplier>(
            value: supplier,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_orderProvider.selectedSupplier == supplier)
                        InkWell(
                          onTap: () => setFilter(null),
                          child: const Icon(
                            color: AppColors.shadowLight,
                            Icons.restart_alt_outlined,
                            size: Dimens.semiBig,
                          ),
                        ),
                      const SizedBox(
                        width: Dimens.medium,
                      ),
                      Expanded(
                        child: Text(
                          supplier.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Divider()
                ],
              ),
            ),
          );
        }),
      ],
      onChanged: setFilter,
    );
  }

  void setFilter(Supplier? value) {
    setState(() {
      _orderProvider.selectedSupplier = value;
      if (_orderProvider.selectedSupplier == null) {
        _productViewModel.searchClean();
      } else {
        _productViewModel.filteredItems = _productViewModel.allItems
            .where((product) =>
                product.lastSupplier!.id == _orderProvider.selectedSupplier!.id)
            .toList();
      }
    });
  }
}
