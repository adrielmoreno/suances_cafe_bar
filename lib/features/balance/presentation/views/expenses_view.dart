import 'package:flutter/material.dart';

import '../../domain/entities/montly_expense.dart';
import '../widgets/expense_month_item.dart';

class ExpensesView extends StatelessWidget {
  const ExpensesView({
    super.key,
    required this.items,
  });

  final List<MonthlyExpense> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ExpenseMonthItem(expense: item);
      },
    );
  }
}
