import 'package:flutter/material.dart';

import '../../domain/entities/montly_income.dart';
import '../widgets/income_month_item.dart';

class IncomesView extends StatelessWidget {
  const IncomesView({
    super.key,
    required this.items,
  });

  final List<MonthlyIcome> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return IncomeMonthItem(income: item);
      },
    );
  }
}
