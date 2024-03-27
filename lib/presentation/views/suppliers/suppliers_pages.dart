import 'package:flutter/material.dart';

class SuppliersPage extends StatefulWidget {
  const SuppliersPage({
    super.key,
  });

  static const route = '/suppliers_page';

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBody: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              SuppliersPage.route,
            ),
          ],
        ),
      ),
    );
  }
}
