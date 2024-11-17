import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../common/localization/localization_manager.dart';
import '../../common/theme/constants/app_colors.dart';
import '../../common/theme/constants/dimens.dart';
import '../../common/widgets/buttons/custom_icon_button.dart';
import 'widgets/item_drawer_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  static const route = '/home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final breakpoint = ResponsiveBreakpoints.of(context);
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
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
      floatingActionButton: breakpoint.isMobile
          ? FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.big)),
              onPressed: () => goIndex(2),
              tooltip: text.newTask,
              child: const Icon(Icons.shopping_basket_outlined),
            )
          : null,
      drawer: breakpoint.largerOrEqualTo(TABLET) ? _getDrawer() : null,
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

  Widget _getDrawer() {
    return Drawer(
      width: 300,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ItemDrawerButton(
              iconData: Icons.bar_chart,
              color: currentIndex == 0 ? AppColors.primaryLight : null,
              onTap: () => goIndex(0)),
          ItemDrawerButton(
              iconData: Icons.sync_alt_outlined,
              color: currentIndex == 1 ? AppColors.primaryLight : null,
              onTap: () => goIndex(1)),
          ItemDrawerButton(
              iconData: Icons.shopping_basket_outlined,
              color: currentIndex == 2 ? AppColors.primaryLight : null,
              onTap: () => goIndex(2)),
          ItemDrawerButton(
              iconData: Icons.liquor_outlined,
              color: currentIndex == 3 ? AppColors.primaryLight : null,
              onTap: () => goIndex(3)),
          ItemDrawerButton(
              iconData: Icons.handshake_outlined,
              color: currentIndex == 4 ? AppColors.primaryLight : null,
              onTap: () => goIndex(4)),
        ],
      ),
    );
  }
}
