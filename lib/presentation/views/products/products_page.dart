import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/product.dart';
import '../../../inject/inject.dart';
import '../../common/interfaces/resource_state.dart';
import '../../common/localization/localization_manager.dart';
import '../../common/theme/constants/dimens.dart';
import '../../common/widgets/buttons/custom_appbar.dart';
import '../../common/widgets/inputs/custom_searchbar.dart';
import '../../common/widgets/margins/margin_container.dart';
import '../suppliers/provider/supplier_provider.dart';
import '../suppliers/view_model/supplier_view_model.dart';
import 'pages/product_page.dart';
import 'provider/producto_provider.dart';
import 'view_model/product_view_model.dart';
import 'widgets/card_item_product.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({
    super.key,
  });

  static const route = '/products_page';

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _productViewModel = getIt<ProductViewModel>();
  final _productProvider = getIt<ProductProvider>();

  late FocusNode focusNode;
  final _supplierViewModel = getIt<SupplierViewModel>();
  final _supProvider = getIt<SupplierProvider>();

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
    setState(() {});
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
    return GestureDetector(
      onTap: () => focusNode.unfocus(),
      child: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: text.products,
              actions: [
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert_outlined),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () => context.goNamed(ProductPage.route),
                      child: Text(text.newProduct),
                    ),
                  ],
                ),
              ],
            ),
            MarginContainer(
              child: CustomSearchBar(
                  focusNode: focusNode,
                  controller: _productProvider.searchController,
                  hint: text.productName,
                  onChanged: (value) =>
                      _productProvider.search(value, (product) => product.name),
                  onClear: () {
                    focusNode.unfocus();
                    _productProvider.searchClean();
                  }),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: Dimens.medium,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _productProvider.filteredItems.length,
                  itemBuilder: (context, index) {
                    return CardItemProduct(
                      product: _productProvider.filteredItems[index],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
