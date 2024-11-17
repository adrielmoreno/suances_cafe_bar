import 'package:flutter/material.dart';

import '../../../../../domain/entities/income.dart';
import '../../widgets/income_month_item.dart';

class IncomesPage extends StatelessWidget {
  const IncomesPage({
    super.key,
    required this.items,
  });

  final List<Income> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        // TODO: change by provider
        final item = items[index];
        return IncomeMonthItem(income: item);
      },
    );
  }
}
