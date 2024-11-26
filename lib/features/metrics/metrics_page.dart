import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../app/di/inject.dart';
import '../../core/presentation/common/theme/constants/dimens.dart';
import '../balance/domain/entities/income.dart';
import '../balance/presentation/viewmodels/expense_view_model.dart';
import '../balance/presentation/viewmodels/income_view_model.dart';
import 'widgets/Incomes_expenses_barchart.dart';
import 'widgets/expenses_distribution_piechart.dart';
import 'widgets/payment_method_barchart.dart';

class MetricsPage extends StatefulWidget {
  const MetricsPage({
    super.key,
  });

  static const route = '/metrics-page';

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
            _buildTitle("Ingresos y Gastos Mensuales"),
            const SizedBox(height: Dimens.semiBig),
            const IncomesExpensesBarChart(),
            const SizedBox(height: Dimens.semiBig),
            _buildTitle("Distribución de Gastos por Categoría"),
            const SizedBox(height: Dimens.medium),
            ExpensesDistributionPieChart(
              expensesByCategory: _expenseViewModel.expensesByCategory,
            ),
            const SizedBox(height: Dimens.semiBig),
            _buildTitle("Métodos de Pago - Gastos"),
            const SizedBox(height: Dimens.medium),
            PaymentMethodBarChart(
              expensesByPaymentMethod:
                  _expenseViewModel.expensesByPaymentMethod,
            ),
            const SizedBox(height: Dimens.medium),
            _buildTitle("Ingresos vs Gastos"),
            const SizedBox(height: Dimens.medium),
            IncomesLineChart(
              incomes: _incomeViewModel.allItems,
            )
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

  Widget _buildLineChart() {
    final months = _incomeViewModel.monthlyIncomes.keys.toList();
    final incomes = months
        .map((month) => _incomeViewModel.monthlyIncomes[month] ?? 0.0)
        .toList();
    final expenses = months
        .map((month) => _expenseViewModel.monthlyExpenses[month] ?? 0.0)
        .toList();

    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                incomes.length,
                (index) => FlSpot(index.toDouble(), incomes[index]),
              ),
              isCurved: true,
              color: Colors.green,
              barWidth: 3,
            ),
            LineChartBarData(
              spots: List.generate(
                expenses.length,
                (index) => FlSpot(index.toDouble(), expenses[index]),
              ),
              isCurved: true,
              color: Colors.red,
              barWidth: 3,
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
                getTitlesWidget: (value, _) =>
                    Text(months[value.toInt() % months.length]),
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class IncomesLineChart extends StatelessWidget {
  final List<Income> incomes;

  const IncomesLineChart({super.key, required this.incomes});

  @override
  Widget build(BuildContext context) {
    final sortedIncomes = incomes
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final spots = sortedIncomes.map((income) {
      final index = sortedIncomes.indexOf(income).toDouble();
      return FlSpot(index, income.total);
    }).toList();

    return sortedIncomes.isEmpty
        ? const SizedBox()
        : SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.greenAccent,
                    barWidth: 4,
                    belowBarData: BarAreaData(
                        show: true, color: Colors.greenAccent.withOpacity(0.3)),
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final income = sortedIncomes[value.toInt()];
                        final date = income.createdAt.toDate();
                        return Text(
                          "${date.day}/${date.month}",
                          style: const TextStyle(
                              fontSize: 10, color: Colors.black54),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 10)),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
