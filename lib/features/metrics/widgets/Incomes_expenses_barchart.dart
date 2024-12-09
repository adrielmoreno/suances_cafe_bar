import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../app/di/inject.dart';
import '../../../core/presentation/common/localization/localization_manager.dart';
import '../../../core/presentation/common/theme/constants/dimens.dart';
import '../../balance/presentation/viewmodels/expense_view_model.dart';
import '../../balance/presentation/viewmodels/income_view_model.dart';

class IncomesExpensesBarChart extends StatefulWidget {
  const IncomesExpensesBarChart({
    super.key,
  });

  @override
  State<IncomesExpensesBarChart> createState() =>
      _IncomesExpensesBarChartState();
}

class _IncomesExpensesBarChartState extends State<IncomesExpensesBarChart> {
  final _expenseViewModel = getIt<ExpenseViewModel>();
  final _incomeViewModel = getIt<IncomeViewModel>();
  final _incomesColor = Colors.greenAccent;
  final _expensesColor = Colors.redAccent;
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
    final incomesData = _incomeViewModel.monthlyIncomes;
    final expensesData = _expenseViewModel.monthlyExpenses;
    final months = incomesData.keys.toList()..sort((a, b) => b.compareTo(a));
    final maxIncome = incomesData.values.isNotEmpty
        ? incomesData.values.reduce((a, b) => a > b ? a : b)
        : 0.0;
    final maxExpense = expensesData.values.isNotEmpty
        ? expensesData.values.reduce((a, b) => a > b ? a : b)
        : 0.0;

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text.income_and_expenses_by_month,
              style: const TextStyle(
                fontSize: Dimens.semiBig,
              ),
            ),
            const SizedBox(height: Dimens.medium),
            Container(
              margin: const EdgeInsets.symmetric(vertical: Dimens.medium),
              height: Dimens.heightChart,
              child: BarChart(
                BarChartData(
                  barGroups: months.map((month) {
                    final income = incomesData[month] ?? 0.0;
                    final expense = expensesData[month] ?? 0.0;
                    final index = months.indexOf(month);

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: income,
                          color: _incomesColor,
                          borderRadius:
                              BorderRadius.circular(Dimens.extraSmall),
                          width: Dimens.medium,
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            color: Colors.grey[300],
                            toY: maxIncome * 1.1,
                          ),
                        ),
                        BarChartRodData(
                          toY: expense,
                          color: _expensesColor,
                          borderRadius:
                              BorderRadius.circular(Dimens.extraSmall),
                          width: Dimens.medium,
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            color: Colors.grey[300],
                            toY: maxExpense * 1.1,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[400]!, width: 1),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 1000,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey[300],
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: Dimens.extraBig,
                        getTitlesWidget: (value, _) {
                          final index = value.toInt();

                          if (index < months.length) {
                            return Text(
                              months[index],
                              style: const TextStyle(
                                  fontSize: Dimens.semiMedium,
                                  color: Colors.black54),
                            );
                          }
                          return const Text("");
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: Dimens.extraBig,
                        getTitlesWidget: (value, _) => Text(
                          text.formattedAmountChart(value),
                          style: const TextStyle(
                              fontSize: Dimens.semiSmall,
                              color: Colors.black54),
                        ),
                      ),
                    ),
                    rightTitles: const AxisTitles(drawBelowEverything: false),
                  ),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => Colors.white,
                      tooltipBorder: BorderSide(color: Colors.grey[300]!),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final label =
                            rodIndex == 0 ? text.incomes : text.expenses;

                        return BarTooltipItem(
                          "$label\n",
                          const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Dimens.semiMedium,
                          ),
                          children: [
                            TextSpan(
                              text: text.formattedAmount(rod.toY),
                              style: TextStyle(
                                color: rod.color,
                                fontSize: Dimens.semiMedium,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Caption(text: text.incomes, color: _incomesColor),
            Caption(text: text.expenses, color: _expensesColor),
          ],
        ),
        const SizedBox(height: Dimens.medium),
      ],
    );
  }
}

class Caption extends StatelessWidget {
  const Caption({
    super.key,
    required this.text,
    required this.color,
  });
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: Dimens.medium,
          height: Dimens.medium,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(Dimens.extraSmall),
          ),
        ),
        const SizedBox(width: Dimens.small),
        Text(
          text,
          style:
              const TextStyle(fontSize: Dimens.medium, color: Colors.black54),
        ),
      ],
    );
  }
}
