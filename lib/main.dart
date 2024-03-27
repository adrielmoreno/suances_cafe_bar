import 'package:flutter/material.dart';

import 'presentation/common/routing/routing.dart';
import 'presentation/common/theme/app_styles.dart';

void main() {
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
      theme: AppStyles.appLightTheme,
      darkTheme: AppStyles.appDarkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
