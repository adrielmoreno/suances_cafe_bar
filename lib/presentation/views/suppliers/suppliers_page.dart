import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/supplier/data_impl/supplier_data_impl.dart';
import '../../../inject/inject.dart';
import '../../common/theme/constants/dimens.dart';
import '../../common/widgets/buttons/custom_appbar.dart';
import '../../common/widgets/inputs/custom_searchbar.dart';
import '../../common/widgets/margins/margin_container.dart';
import '../../providers/supplier/supplier_provider.dart';
import 'pages/supplier_page.dart';
import 'widgets/card_item_supplier.dart';

class SuppliersPage extends StatefulWidget {
  const SuppliersPage({
    super.key,
  });

  static const route = '/suppliers_page';

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  final _supplierRep = getIt<SupplierDataImpl>();
  final _supProvider = getIt<SupplierProvider>();
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();

    generateSuppliers();

    _supProvider.addListener(_onProviderStateChanged);
  }

  generateSuppliers() async {
    _supProvider.supplierSearchProvider(await _supplierRep.getAll());
    setState(() {});
  }

  @override
  void dispose() {
    focusNode.dispose();
    _supProvider.removeListener(_onProviderStateChanged);
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
                  controller: _supProvider.searchController,
                  hint: 'Nombre del supplidor',
                  onChanged: _supProvider.search,
                  onClear: () => _supProvider.searchClean(),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: Dimens.maxwidth,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: Dimens.big,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _supProvider.filteredSuppliers.length,
                      itemBuilder: (context, index) {
                        return CardItemSuplier(
                          supplier: _supProvider.filteredSuppliers[index],
                        );
                      },
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
