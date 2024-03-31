import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'inject/inject.dart';
import 'presentation/common/routing/routing.dart';
import 'presentation/common/theme/app_styles.dart';

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
      theme: AppStyles.appLightTheme,
      darkTheme: AppStyles.appDarkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
