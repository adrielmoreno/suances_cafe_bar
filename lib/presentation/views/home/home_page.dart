import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../common/theme/constants/dimens.dart';
import '../../common/widgets/buttons/custom_icon_button.dart';
import '../balance/balance_page.dart';
import '../metrics/metrics_page.dart';
import '../products/products_page.dart';
import '../suppliers/suppliers_page.dart';
import '../todos/to_dos_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  static const route = '/home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: widget.navigationShell,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimens.big)),
          onPressed: () => context.go(ToDosPage.route),
          tooltip: 'Nuevo',
          child: const Icon(Icons.shopping_basket_outlined),
        ),
        bottomNavigationBar: _getBottomBar(),
      ),
    );
  }

  Widget _getBottomBar() {
    return BottomAppBar(
      notchMargin: Dimens.small,
      padding: const EdgeInsets.symmetric(vertical: Dimens.zero),
      height: Dimens.huge,
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomIconButton(
            iconData: Icons.bar_chart,
            onTap: () => context.go(MetricsPage.route),
          ),
          CustomIconButton(
            iconData: Icons.sync_alt_outlined,
            onTap: () => context.go(BalancePage.route),
          ),
          const SizedBox(width: Dimens.big),
          CustomIconButton(
            iconData: Icons.liquor_outlined,
            onTap: () => context.go(ProductsPage.route),
          ),
          CustomIconButton(
            iconData: Icons.handshake_outlined,
            onTap: () => context.go(SuppliersPage.route),
          ),
        ],
      ),
    );
  }
}
