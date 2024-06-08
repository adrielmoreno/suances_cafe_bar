import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../domain/entities/orden.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/supplier.dart';
import '../../../../inject/inject.dart';
import '../../../common/interfaces/resource_state.dart';
import '../../../common/localization/localization_manager.dart';
import '../../../common/theme/constants/app_colors.dart';
import '../../../common/theme/constants/dimens.dart';
import '../../../common/widgets/inputs/custom_searchbar.dart';
import '../../products/provider/producto_provider.dart';
import '../../products/view_model/product_view_model.dart';
import '../../suppliers/provider/supplier_provider.dart';
import '../../suppliers/view_model/supplier_view_model.dart';
import '../provider/order_provider.dart';
import 'item_to_order.dart';

class OrderPanel extends StatefulWidget {
  const OrderPanel({
    super.key,
  });

  @override
  State<OrderPanel> createState() => _OrderPanelState();
}

class _OrderPanelState extends State<OrderPanel> {
  final _productViewModel = getIt<ProductViewModel>();
  final _productProvider = getIt<ProductProvider>();

  late FocusNode focusNode;
  final _supplierViewModel = getIt<SupplierViewModel>();
  final _supProvider = getIt<SupplierProvider>();

  final _orderProvider = getIt<OrderProvider>();

  @override
  void initState() {
    super.initState();

    _productViewModel.getAllState.stream.listen((event) {
      switch (event.state) {
        case Status.LOADING:
          // TODO: Implement loading...
          log('Cargando...');
          break;
        case Status.COMPLETED:
          _onProductsChanged(event.data);
          break;
        // TODO: Implement error...
        default:
      }
    });

    _productViewModel.getAll();

    focusNode = FocusNode();

    _productProvider.addListener(_onProviderStateChanged);

    _supplierViewModel.getAllState.stream.listen((event) {
      switch (event.state) {
        case Status.COMPLETED:
          setState(() {
            _supProvider.allItems = event.data;
            _supProvider.filteredItems = event.data;
          });
          break;

        default:
      }
    });

    if (_supProvider.allItems.isEmpty) {
      _supplierViewModel.getAll();
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    _productViewModel.close();
    _productProvider.removeListener(_onProviderStateChanged);
    super.dispose();
  }

  void _onProductsChanged(List<Product> list) {
    _productProvider.allItems = list;
    _productProvider.filteredItems = list;
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
            controller: _productProvider.searchController,
            hint: text.productName,
            onChanged: (value) =>
                _productProvider.search(value, (product) => product.name),
            onClear: () {
              focusNode.unfocus();
              _productProvider.searchClean();
              setFilter(null);
            }),
        // ---- Supplier
        productFilteredBySupplier(),

        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: _productProvider.filteredItems.length,
            itemBuilder: (context, index) {
              final order =
                  Order(product: _productProvider.filteredItems[index]);
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
          child: Container(
            color: Theme.of(context).colorScheme.inversePrimary,
            child: const Text('Ningún suplidor'),
          ),
        ),
        ..._supProvider.allItems.map((supplier) {
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
                            Icons.cancel_outlined,
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
        _productProvider.searchClean();
      } else {
        _productProvider.filteredItems = _productProvider.allItems
            .where((product) =>
                product.lastSupplier!.id == _orderProvider.selectedSupplier!.id)
            .toList();
      }
    });
  }
}
