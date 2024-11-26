import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 50,
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
                  radius: 80,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: expensesByCategory.keys.map((key) {
            final index = expensesByCategory.keys.toList().indexOf(key);
            final color = Colors.primaries[index % Colors.primaries.length];
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  key,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
