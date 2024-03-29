import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/product.dart';
import '../../common/theme/constants/app_colors.dart';
import '../../common/theme/constants/dimens.dart';
import '../../common/utils/local_dates.dart';
import '../../common/widgets/buttons/custom_appbar.dart';
import '../../common/widgets/inputs/custom_searchbar.dart';
import '../../common/widgets/margins/margin_container.dart';
import 'pages/product_page.dart';

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

    setState(() {
      generateProducts(20);
    });
  }

  List<void> generateProducts(int count) {
    for (int i = 0; i < count; i++) {
      products.add(
        Product(
          name: faker.food.dish(),
          packaging: faker.randomGenerator.integer(10),
          measure: faker.randomGenerator.element(["kg", "g", "L", "ml"]),
          pricePacking: faker.randomGenerator.decimal(),
          priceUnit: faker.randomGenerator.decimal(),
          lastSupplier: faker.company.name(),
        ),
      );
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => focusNode.unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                title: 'Productos',
                actions: [
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert_outlined),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () => context.goNamed(ProductPage.route),
                        child: const Text('Nuevo producto'),
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

class CardItemProduct extends StatelessWidget {
  const CardItemProduct({
    super.key,
    required this.product,
  });
  final Product product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
          child: ListTile(
        onTap: () => context.goNamed(ProductPage.route),
        leading: Container(
          decoration: BoxDecoration(
            color: AppColors.inversePrimaryLight,
            borderRadius: BorderRadius.circular(Dimens.semiBig),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimens.small),
            child: Text(
                '${LocalDates.getCurrency()} ${product.priceUnit!.toStringAsFixed(2)}'),
          ),
        ),
        title: Text(product.name),
        subtitle: Text(
          product.lastSupplier!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_outlined,
          size: Dimens.semiBig,
        ),
      )),
    );
  }
}
