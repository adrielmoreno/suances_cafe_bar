import 'package:flutter/material.dart';

class ExpensesView extends StatefulWidget {
  const ExpensesView({
    super.key,
  });

  static const route = '/expenses-view';

  @override
  State<ExpensesView> createState() => _ExpensesViewState();
}

class _ExpensesViewState extends State<ExpensesView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBody: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ExpensesView.route,
            ),
          ],
        ),
      ),
    );
  }
}
