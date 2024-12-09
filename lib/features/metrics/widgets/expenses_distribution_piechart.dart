import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/presentation/common/localization/localization_manager.dart';
import '../../../core/presentation/common/theme/constants/dimens.dart';

class ExpensesDistributionPieChart extends StatelessWidget {
  final Map<String, double> expensesByCategory;

  const ExpensesDistributionPieChart({
    super.key,
    required this.expensesByCategory,
  });

  @override
  Widget build(BuildContext context) {
    final totalExpenses =
        expensesByCategory.values.fold(0.0, (sum, value) => sum + value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text.expenses_by_category,
          style: const TextStyle(
            fontSize: Dimens.semiBig,
          ),
        ),
        const SizedBox(height: Dimens.medium),
        Container(
          margin: const EdgeInsets.symmetric(vertical: Dimens.medium),
          height: Dimens.heightChart,
          child: PieChart(
            PieChartData(
              sectionsSpace: Dimens.small,
              centerSpaceRadius: Dimens.huge,
              sections: expensesByCategory.entries.map((entry) {
                final index =
                    expensesByCategory.keys.toList().indexOf(entry.key);
                final color = Colors.primaries[index % Colors.primaries.length];
                final percentage = (entry.value / totalExpenses) * 100;

                return PieChartSectionData(
                  value: percentage,
                  title:
                      percentage > 5 ? "${percentage.toStringAsFixed(1)}%" : "",
                  color: color,
                  radius: 100,
                  titleStyle: const TextStyle(
                    fontSize: Dimens.semiMedium,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(height: Dimens.medium),
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            spacing: Dimens.small,
            children: expensesByCategory.keys.map((key) {
              final index = expensesByCategory.keys.toList().indexOf(key);
              final color = Colors.primaries[index % Colors.primaries.length];
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: Dimens.medium,
                    height: Dimens.medium,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: Dimens.extraSmall),
                  Text(
                    key,
                    style: const TextStyle(
                        fontSize: Dimens.semiMedium, color: Colors.black54),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
