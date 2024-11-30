import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/inject.dart';
import '../../../core/presentation/common/localization/localization_manager.dart';
import '../../../core/presentation/common/theme/constants/dimens.dart';
import '../../../core/presentation/common/widgets/buttons/custom_appbar.dart';
import '../../../core/presentation/common/widgets/inputs/custom_searchbar.dart';
import '../../../core/presentation/common/widgets/margins/margin_container.dart';
import 'pages/supplier_page.dart';
import 'view_model/supplier_view_model.dart';
import 'widgets/card_item_supplier.dart';

class SuppliersPage extends StatefulWidget {
  const SuppliersPage({
    super.key,
  });

  static const route = '/suppliers';

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  final _supplierViewModel = getIt<SupplierViewModel>();

  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    _supplierViewModel.addListener(_onUpdate);

    _supplierViewModel.getAll();

    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    _supplierViewModel.dispose();
    _supplierViewModel.removeListener(_onUpdate);
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
              title: text.suppliers,
              actions: [
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert_outlined),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () => context.goNamed(SupplierPage.route),
                      child: Text(text.newSupplier),
                    ),
                  ],
                ),
              ],
            ),
            MarginContainer(
              child: CustomSearchBar(
                  focusNode: focusNode,
                  controller: _supplierViewModel.searchController,
                  hint: text.supplierName,
                  onChanged: (value) => _supplierViewModel.search(
                      value, (suplier) => suplier.name),
                  onClear: () {
                    focusNode.unfocus();
                    _supplierViewModel.searchClean();
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
                  itemCount: _supplierViewModel.filteredItems.length,
                  itemBuilder: (context, index) {
                    return CardItemSuplier(
                      supplier: _supplierViewModel.filteredItems[index],
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
