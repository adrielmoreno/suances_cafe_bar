import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'firebase_options.dart';
import 'inject/inject.dart';
import 'presentation/common/localization/app_localizations.dart';
import 'presentation/common/localization/localization_manager.dart';
import 'presentation/common/routing/routing.dart';
import 'presentation/common/theme/app_styles.dart';
import 'presentation/common/theme/constants/dimens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Inject().setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
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
