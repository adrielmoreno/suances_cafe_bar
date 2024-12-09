import 'package:flutter/material.dart';

import '../../app/di/inject.dart';
import '../../core/presentation/common/theme/constants/dimens.dart';
import '../balance/presentation/viewmodels/expense_view_model.dart';
import '../balance/presentation/viewmodels/income_view_model.dart';
import 'widgets/Incomes_expenses_barchart.dart';
import 'widgets/expenses_distribution_piechart.dart';
import 'widgets/incomes_linechart.dart';
import 'widgets/payment_method_barchart.dart';
import 'widgets/weekly_average_barchart.dart';

class MetricsPage extends StatefulWidget {
  const MetricsPage({
    super.key,
  });

  static const route = '/dashboard';

  @override
  State<MetricsPage> createState() => _MetricsPageState();
}

class _MetricsPageState extends State<MetricsPage> {
  final _expenseViewModel = getIt<ExpenseViewModel>();
  final _incomeViewModel = getIt<IncomeViewModel>();

  @override
  void initState() {
    super.initState();

    _incomeViewModel.addListener(_updateState);
    _expenseViewModel.addListener(_updateState);

    _incomeViewModel.getAll();
    _expenseViewModel.getAll();
  }

  _updateState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _incomeViewModel.removeListener(_updateState);
    _expenseViewModel.removeListener(_updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IncomesLineChart(
              incomes: _incomeViewModel.allItems,
            ),
            const IncomesExpensesBarChart(),
            ExpensesDistributionPieChart(
              expensesByCategory: _expenseViewModel.expensesByCategory,
            ),
            PaymentMethodBarChart(
              expensesByPaymentMethod:
                  _expenseViewModel.expensesByPaymentMethod,
            ),
            WeeklyAverageBarChart(
              averageIncomesByDay: _incomeViewModel.averageIncomesByDay,
              averageExpensesByDay: _expenseViewModel.averageExpensesByDay,
            )
          ],
        ),
      ),
    );
  }
}
