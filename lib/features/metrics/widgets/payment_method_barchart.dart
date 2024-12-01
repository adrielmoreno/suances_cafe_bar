import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/presentation/common/localization/localization_manager.dart';

class PaymentMethodBarChart extends StatefulWidget {
  final Map<String, Map<String, double>> expensesByPaymentMethod;

  const PaymentMethodBarChart({
    super.key,
    required this.expensesByPaymentMethod,
  });

  @override
  State<PaymentMethodBarChart> createState() => _PaymentMethodBarChartState();
}

class _PaymentMethodBarChartState extends State<PaymentMethodBarChart> {
  @override
  Widget build(BuildContext context) {
    final months = widget.expensesByPaymentMethod.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: BarChart(
            BarChartData(
              barGroups: months.map((month) {
                final paymentData = widget.expensesByPaymentMethod[month] ?? {};
                final cash = paymentData[text.label_cash]?.truncate() ?? 0;
                final card = paymentData[text.label_card]?.truncate() ?? 0;
                final transfer = paymentData[text.transfer]?.truncate() ?? 0;

                final index = months.indexOf(month);

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: cash * 1.05,
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    BarChartRodData(
                      toY: card * 1.05,
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    BarChartRodData(
                      toY: transfer * 1.05,
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }).toList(),
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
                topTitles: const AxisTitles(drawBelowEverything: false),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index < months.length) {
                        return Text(
                          months[index],
                          style: const TextStyle(
                            fontSize: 12,
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
                rightTitles: const AxisTitles(drawBelowEverything: false),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => Colors.white,
                  tooltipBorder: BorderSide(color: Colors.grey[300]!),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final label = rodIndex == 0
                        ? text.label_cash
                        : rodIndex == 1
                            ? text.label_card
                            : text.transfer;

                    return BarTooltipItem(
                      "$label\n",
                      const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: text.formattedAmount(rod.toY),
                          style: TextStyle(
                            color: rod.color,
                            fontSize: 12,
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
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildLegend(text.label_cash, Colors.greenAccent),
            _buildLegend(text.label_card, Colors.blueAccent),
            _buildLegend(text.transfer, Colors.orangeAccent),
          ],
        ),
      ],
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}
