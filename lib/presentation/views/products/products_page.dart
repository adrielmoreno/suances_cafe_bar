import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/product.dart';
import '../../common/localization/app_localizations.dart';
import '../../common/theme/constants/dimens.dart';
import '../../common/widgets/buttons/custom_appbar.dart';
import '../../common/widgets/inputs/custom_searchbar.dart';
import '../../common/widgets/margins/margin_container.dart';
import 'pages/product_page.dart';
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
  late FocusNode focusNode;
  List<Product> products = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      focusNode = FocusNode();
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Scaffold(
      body: GestureDetector(
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
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: MarginContainer(
                    child: Column(
                      children: [
                        SizedBox(
                          width: Dimens.maxwidth,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return CardItemProduct(
                                product: products[index],
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 70,
                        )
                      ],
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
