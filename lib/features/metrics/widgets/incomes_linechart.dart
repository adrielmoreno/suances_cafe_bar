import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/presentation/common/localization/localization_manager.dart';
import '../../balance/domain/entities/income.dart';

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
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey[400]!, width: 1),
                ),
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey[300],
                    strokeWidth: 1,
                  ),
                ),
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
                      reservedSize: 40,
                      getTitlesWidget: (value, _) => Text(
                        text.formattedAmountChart(value),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(drawBelowEverything: false),
                  rightTitles: const AxisTitles(drawBelowEverything: false),
                ),
              ),
            ),
          );
  }
}
