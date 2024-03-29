import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/supplier.dart';
import '../../common/theme/constants/dimens.dart';
import '../../common/widgets/buttons/custom_appbar.dart';
import '../../common/widgets/inputs/custom_searchbar.dart';
import '../../common/widgets/margins/margin_container.dart';
import 'pages/supplier_page.dart';

class SuppliersPage extends StatefulWidget {
  const SuppliersPage({
    super.key,
  });

  static const route = '/suppliers_page';

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  late FocusNode focusNode;
  List<Supplier> products = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      focusNode = FocusNode();
    });

    setState(() {
      generateSuppliers(20);
    });
  }

  List<void> generateSuppliers(int count) {
    for (int i = 0; i < count; i++) {
      products.add(
        Supplier(
          id: faker.guid.guid(),
          name: faker.company.name(),
          cif: faker.randomGenerator.boolean()
              ? faker.randomGenerator
                  .fromCharSet('ABCDEFGHIJKLMONPQESTUVWXYZ', 8)
              : null,
          tel: faker.phoneNumber.us(),
          contactName: faker.person.name(),
          phone: faker.phoneNumber.us(),
          type: TypeOfSupplier.values[
              faker.randomGenerator.integer(TypeOfSupplier.values.length)],
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
                title: 'Suplidores',
                actions: [
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert_outlined),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () => context.goNamed(SupplierPage.route),
                        child: const Text('Nuevo suplidor'),
                      ),
                    ],
                  ),
                ],
              ),
              MarginContainer(
                child: CustomSearchBar(
                  focusNode: focusNode,
                  hint: 'Nombre del supplidor',
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
                              return CardItemSuplier(
                                supplier: products[index],
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

class CardItemSuplier extends StatelessWidget {
  const CardItemSuplier({
    super.key,
    required this.supplier,
  });
  final Supplier supplier;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
          child: ListTile(
        onTap: () => context.goNamed(SupplierPage.route),
        // leading: Container(
        //   decoration: BoxDecoration(
        //     color: AppColors.inversePrimaryLight,
        //     borderRadius: BorderRadius.circular(Dimens.semiBig),
        //   ),
        //   child: Padding(
        //     padding: const EdgeInsets.all(Dimens.small),
        //     child: Text(
        //         '${LocalDates.getCurrency()} ${supplier.priceUnit!.toStringAsFixed(2)}'),
        //   ),
        // ),
        title: Text(supplier.name),
        subtitle: Text(
          supplier.contactName ?? '',
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
