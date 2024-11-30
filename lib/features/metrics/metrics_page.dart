import 'package:flutter/material.dart';

import '../../app/di/inject.dart';
import '../../core/presentation/common/localization/localization_manager.dart';
import '../../core/presentation/common/theme/constants/dimens.dart';
import '../balance/presentation/viewmodels/expense_view_model.dart';
import '../balance/presentation/viewmodels/income_view_model.dart';
import 'widgets/Incomes_expenses_barchart.dart';
import 'widgets/expenses_distribution_piechart.dart';
import 'widgets/incomes_linechart.dart';
import 'widgets/payment_method_barchart.dart';

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
    if (mounted) {
      setState(() {});
    }
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
            _buildTitle(text.income_trend),
            const SizedBox(height: Dimens.medium),
            IncomesLineChart(
              incomes: _incomeViewModel.allItems,
            ),
            const SizedBox(height: Dimens.medium),
            _buildTitle(text.income_and_expenses_by_month),
            const SizedBox(height: Dimens.semiBig),
            const IncomesExpensesBarChart(),
            const SizedBox(height: Dimens.semiBig),
            _buildTitle(text.expenses_by_category),
            const SizedBox(height: Dimens.medium),
            ExpensesDistributionPieChart(
              expensesByCategory: _expenseViewModel.expensesByCategory,
            ),
            const SizedBox(height: Dimens.semiBig),
            _buildTitle(text.payment_methods_expenses),
            const SizedBox(height: Dimens.medium),
            PaymentMethodBarChart(
              expensesByPaymentMethod:
                  _expenseViewModel.expensesByPaymentMethod,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}
