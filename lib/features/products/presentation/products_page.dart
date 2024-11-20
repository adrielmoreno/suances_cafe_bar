import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/inject.dart';
import '../../../presentation/common/localization/localization_manager.dart';
import '../../../presentation/common/theme/constants/dimens.dart';
import '../../../presentation/common/widgets/buttons/custom_appbar.dart';
import '../../../presentation/common/widgets/inputs/custom_searchbar.dart';
import '../../../presentation/common/widgets/margins/margin_container.dart';
import '../pages/product_page.dart';
import 'view_model/product_view_model.dart';
import 'widgets/card_item_product.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({
    super.key,
  });

  static const route = '/products-page';

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _productViewModel = getIt<ProductViewModel>();

  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    _productViewModel.addListener(_onUpdate);

    _productViewModel.getAll();

    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    _productViewModel.resetForm();
    _productViewModel.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
    if (mounted) {
      setState(() {});
    }
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
                  controller: _productViewModel.searchController,
                  hint: text.productName,
                  onChanged: (value) => _productViewModel.search(
                      value, (product) => product.name),
                  onClear: () {
                    focusNode.unfocus();
                    _productViewModel.searchClean();
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
                  itemCount: _productViewModel.filteredItems.length,
                  itemBuilder: (context, index) {
                    return CardItemProduct(
                      product: _productViewModel.filteredItems[index],
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
