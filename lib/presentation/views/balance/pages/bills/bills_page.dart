import 'package:flutter/material.dart';

class BillsPage extends StatefulWidget {
  const BillsPage({
    super.key,
  });

  static const route = '/bills_page';

  @override
  State<BillsPage> createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBody: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              BillsPage.route,
            ),
          ],
        ),
      ),
    );
  }
}
