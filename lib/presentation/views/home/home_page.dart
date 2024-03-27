import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../common/theme/constants/dimens.dart';
import '../bills/bills_pages.dart';
import '../metrics/metrics.dart';
import '../receipts/receipts_pages.dart';
import '../suppliers/suppliers_pages.dart';
import '../todos/to_dos_pages.dart';

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
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
        title: const Text(HomePage.route),
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
      bottomNavigationBar: getBottomBar(),
    );
  }

  BottomAppBar getBottomBar() {
    return BottomAppBar(
      notchMargin: Dimens.small,
      padding: const EdgeInsets.symmetric(vertical: Dimens.zero),
      height: Dimens.huge,
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          BottomNavItem(
            iconData: Icons.bar_chart,
            onTap: () => context.go(MetricsPage.route),
          ),
          BottomNavItem(
            iconData: Icons.euro_outlined,
            onTap: () => context.go(ReceiptsPage.route),
          ),
          const SizedBox(width: Dimens.big),
          BottomNavItem(
            iconData: Icons.money_off_csred_outlined,
            onTap: () => context.go(BillsPage.route),
          ),
          BottomNavItem(
            iconData: Icons.handshake_outlined,
            onTap: () => context.go(SuppliersPage.route),
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  const BottomNavItem({
    super.key,
    required this.iconData,
    this.onTap,
  });
  final IconData iconData;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        iconData,
        size: Dimens.big,
      ),
    );
  }
}
