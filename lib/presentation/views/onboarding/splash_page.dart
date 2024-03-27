import 'package:flutter/material.dart';

import '../../common/theme/constants/dimens.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
  });

  static const route = '/splash_page';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              SplashPage.route,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.big)),
        onPressed: () {},
        tooltip: 'Nuevo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
