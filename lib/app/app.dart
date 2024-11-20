import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../presentation/common/localization/app_localizations.dart';
import '../presentation/common/localization/localization_manager.dart';
import '../presentation/common/theme/app_styles.dart';
import '../presentation/common/theme/constants/dimens.dart';
import 'navegation/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      title: 'Suances',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppStyles.appLightTheme,
      darkTheme: AppStyles.appDarkTheme,
      themeMode: ThemeMode.system,
      builder: (context, child) => ResponsiveBreakpoints(
        breakpoints: const [
          Breakpoint(
            start: 0,
            end: Dimens.minTableWidth,
            name: MOBILE,
          ),
          Breakpoint(
            start: Dimens.minTableWidth,
            end: Dimens.minDesktopWidth,
            name: TABLET,
          ),
          Breakpoint(
            start: Dimens.minDesktopWidth,
            end: double.infinity,
            name: DESKTOP,
          ),
        ],
        child: child!,
      ),
      onGenerateTitle: (context) {
        LocalizationManager.init(context: context);
        return text.app_title;
      },
    );
  }
}
