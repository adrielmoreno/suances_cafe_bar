import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../features/balance/transactions_page.dart';
import '../../../../features/metrics/metrics_page.dart';
import '../../../../features/products/presentation/products_page.dart';
import '../../../../features/suppliers/presentation/suppliers_page.dart';
import '../../../../features/todos/presentation/to_dos_page.dart';
import '../localization/localization_manager.dart';
import '../theme/constants/app_colors.dart';
import '../theme/constants/dimens.dart';
import '../widgets/buttons/custom_icon_button.dart';
import '../widgets/tiles/item_drawer_button.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  final selectedColor = AppColors.onPrimaryLight;
  final unSelectedColor = AppColors.onPrimaryLight.withOpacity(0.5);

  @override
  Widget build(BuildContext context) {
    final breakpoint = ResponsiveBreakpoints.of(context);
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Stack(
            children: [
              Row(
                children: [
                  if (breakpoint.largerThan(MOBILE)) _getSidebar(),
                  Expanded(child: widget.navigationShell),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: breakpoint.isMobile
          ? FloatingActionButton(
              mini: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.big)),
              onPressed: () => goIndex(2),
              tooltip: text.newTask,
              child: const Icon(Icons.shopping_basket_outlined),
            )
          : null,
      bottomNavigationBar: breakpoint.isMobile ? _getBottomBar() : null,
    );
  }

  Widget _getBottomBar() {
    return BottomAppBar(
      notchMargin: Dimens.small,
      padding: const EdgeInsets.symmetric(vertical: Dimens.zero),
      height: Dimens.huge,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomIconButton(
            iconData: Icons.bar_chart,
            color: currentIndex == 0 ? AppColors.primaryLight : null,
            onTap: () => goIndex(0),
          ),
          CustomIconButton(
            iconData: Icons.sync_alt_outlined,
            color: currentIndex == 1 ? AppColors.primaryLight : null,
            onTap: () => goIndex(1),
          ),
          const SizedBox(width: Dimens.big),
          CustomIconButton(
            iconData: Icons.liquor_outlined,
            color: currentIndex == 3 ? AppColors.primaryLight : null,
            onTap: () => goIndex(3),
          ),
          CustomIconButton(
            iconData: Icons.handshake_outlined,
            color: currentIndex == 4 ? AppColors.primaryLight : null,
            onTap: () => goIndex(4),
          ),
        ],
      ),
    );
  }

  void goIndex(int index) {
    setState(() {
      currentIndex = index;
    });

    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  Widget _getSidebar() {
    return Container(
      width: Dimens.sideMenu,
      height: double.infinity,
      decoration: buildBoxDecoration(),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          SvgPicture.asset(
            'assets/images/suances_cafe.svg',
            height: 200,
            colorFilter: ColorFilter.mode(
                AppColors.onPrimaryLight.withOpacity(0.8), BlendMode.srcIn),
          ),
          const SizedBox(height: Dimens.huge),
          ItemDrawerButton(
            text: getTitle(MetricsPage.route),
            iconData: Icons.bar_chart,
            color: currentIndex == 0 ? selectedColor : unSelectedColor,
            onTap: () => goIndex(0),
          ),
          ItemDrawerButton(
            text: getTitle(TransactionsPage.route),
            iconData: Icons.sync_alt_outlined,
            color: currentIndex == 1 ? selectedColor : unSelectedColor,
            onTap: () => goIndex(1),
          ),
          ItemDrawerButton(
            text: getTitle(ToDosPage.route),
            iconData: Icons.shopping_basket_outlined,
            color: currentIndex == 2 ? selectedColor : unSelectedColor,
            onTap: () => goIndex(2),
          ),
          ItemDrawerButton(
            text: getTitle(ProductsPage.route),
            iconData: Icons.liquor_outlined,
            color: currentIndex == 3 ? selectedColor : unSelectedColor,
            onTap: () => goIndex(3),
          ),
          ItemDrawerButton(
            text: getTitle(SuppliersPage.route),
            iconData: Icons.handshake_outlined,
            color: currentIndex == 4 ? selectedColor : unSelectedColor,
            onTap: () => goIndex(4),
          ),
        ],
      ),
    );
  }

  String getTitle(String value) {
    final title = value.replaceFirst('/', '');
    return title;
  }

  BoxDecoration buildBoxDecoration() => const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.onPrimaryDark,
            AppColors.primaryContainerDark,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: Dimens.small,
          )
        ],
      );
}
