import 'package:flutter/material.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({
    super.key,
  });

  static const route = '/balance_page';

  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBody: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              BalancePage.route,
            ),
          ],
        ),
      ),
    );
  }
}
