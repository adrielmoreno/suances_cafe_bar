import 'package:flutter/material.dart';

import '../../common/theme/constants/dimens.dart';

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
    return Scaffold(
      extendBody: true,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              BillsPage.route,
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
