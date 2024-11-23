import 'package:flutter/material.dart';

import 'green_color_scheme.dart';

class AppStyles {
  // App Theme
  static ThemeData appLightTheme = ThemeData(
    colorScheme: GreenScheme.lightColorScheme,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
  ).copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static ThemeData appDarkTheme = ThemeData(
    colorScheme: GreenScheme.darkColorScheme,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
  ).copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
