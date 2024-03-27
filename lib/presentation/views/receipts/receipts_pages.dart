import 'package:flutter/material.dart';

import '../../common/theme/constants/dimens.dart';

class ReceiptsPage extends StatefulWidget {
  const ReceiptsPage({
    super.key,
  });

  static const route = '/receipts_page';

  @override
  State<ReceiptsPage> createState() => _ReceiptsPageState();
}

class _ReceiptsPageState extends State<ReceiptsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ReceiptsPage.route,
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
