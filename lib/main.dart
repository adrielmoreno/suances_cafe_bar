import 'package:flutter/material.dart';
import 'package:suances/presentation/common/theme/app_styles.dart';

import 'presentation/views/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suances',
      theme: AppStyles.appLightTheme,
      darkTheme: AppStyles.appDarkTheme,
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Suances App'),
    );
  }
}
