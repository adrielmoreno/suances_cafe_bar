import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/presentation/common/localization/localization_manager.dart';
import '../../../core/presentation/common/theme/constants/dimens.dart';

class WeeklyAverageBarChart extends StatelessWidget {
  final Map<String, double> averageIncomesByDay;
  final Map<String, double> averageExpensesByDay;

  const WeeklyAverageBarChart({
    super.key,
    required this.averageIncomesByDay,
    required this.averageExpensesByDay,
  });

  @override
  Widget build(BuildContext context) {
    final daysOfWeek = ["L", "M", "X", "J", "V", "S", "D"];

    final incomes =
        daysOfWeek.map((day) => averageIncomesByDay[day] ?? 0.0).toList();
    final expenses =
        daysOfWeek.map((day) => averageExpensesByDay[day] ?? 0.0).toList();

    final maxIncome =
        incomes.isNotEmpty ? incomes.reduce((a, b) => a > b ? a : b) : 0.0;
    final maxExpense =
        expenses.isNotEmpty ? expenses.reduce((a, b) => a > b ? a : b) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Dimens.medium),
        Text(
          text.average_daily_income_expenses,
          style: const TextStyle(
            fontSize: Dimens.semiBig,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: Dimens.medium),
        Container(
          margin: const EdgeInsets.only(top: Dimens.medium),
          height: Dimens.heightChart,
          child: BarChart(
            BarChartData(
              barGroups: List.generate(daysOfWeek.length, (index) {
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: incomes[index],
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(Dimens.extraSmall),
                      width: Dimens.medium,
                    ),
                    BarChartRodData(
                      toY: expenses[index],
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(Dimens.extraSmall),
                      width: Dimens.medium,
                    ),
                  ],
                );
              }),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey[400]!, width: 1),
              ),
              gridData: FlGridData(
                show: true,
                horizontalInterval:
                    maxIncome > maxExpense ? maxIncome / 5 : maxExpense / 5,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey[300],
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(drawBelowEverything: false),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: Dimens.extraBig,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index >= 0 && index < daysOfWeek.length) {
                        return Text(
                          daysOfWeek[index],
                          style: const TextStyle(
                            fontSize: Dimens.semiMedium,
                            color: Colors.black54,
                          ),
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
                        color: Colors.black54,
                      ),
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
                    final label = rodIndex == 0 ? text.incomes : text.expenses;
                    final amount = text.formattedAmount(rod.toY);
                    return BarTooltipItem(
                      "$label\n",
                      const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Dimens.semiMedium,
                      ),
                      children: [
                        TextSpan(
                          text: amount,
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
        const SizedBox(height: Dimens.medium),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildLegend(text.incomes, Colors.greenAccent),
            _buildLegend(text.expenses, Colors.redAccent),
          ],
        ),
      ],
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: Dimens.semiMedium,
          height: Dimens.semiMedium,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: Dimens.small),
        Text(
          label,
          style:
              const TextStyle(fontSize: Dimens.medium, color: Colors.black54),
        ),
      ],
    );
  }
}
