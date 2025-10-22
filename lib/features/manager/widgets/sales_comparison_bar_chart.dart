import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesComparisonBarChart extends StatelessWidget {
  final String salesperson1;
  final String salesperson2;

  const SalesComparisonBarChart({
    super.key,
    required this.salesperson1,
    required this.salesperson2,
  });

  // --- UPDATED MOCK DATA ---
  // Now represents sales revenue in thousands
  final Color person1Color = Colors.indigo;
  final Color person2Color = Colors.amber;
  final List<double> sales1 = const [5000, 8000, 4000, 7000, 6000];
  final List<double> sales2 = const [6000, 7000, 5000, 8000, 5000];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. The Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Indicator(color: person1Color, text: salesperson1),
            const SizedBox(width: 16),
            _Indicator(color: person2Color, text: salesperson2),
          ],
        ),
        const SizedBox(height: 16),
        // 2. The Chart
        AspectRatio(
          aspectRatio: 1.7,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceBetween,
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                // --- Y-AXIS LABELS ---
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40, // Make space for the labels
                    getTitlesWidget: (value, meta) {
                      // Don't show a label for 0 or the very top of the chart
                      if (value == 0 || value >= 12000) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        // Format the value as '$2k', '$4k', etc.
                        '\$${(value / 1000).toStringAsFixed(0)}k',
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
                      String text;
                      switch (value.toInt()) {
                        case 0: text = 'M'; break;
                        case 1: text = 'T'; break;
                        case 2: text = 'W'; break;
                        case 3: text = 'T'; break;
                        case 4: text = 'F'; break;
                        default: text = ''; break;
                      }
                      // Simply return the Text widget directly
                      return Text(text, style: style);
                    },
                  ),
                ),
              ),
              gridData: const FlGridData(show: false),
              // This is where we define the two bars
              barGroups: List.generate(sales1.length, (index) {
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    // Bar for Person 1
                    BarChartRodData(
                      toY: sales1[index],
                      color: person1Color,
                      width: 15,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    // Bar for Person 2
                    BarChartRodData(
                      toY: sales2[index],
                      color: person2Color,
                      width: 15,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                  // Spacing between the two bars in a group
                  barsSpace: 4,
                );
              }),
              // --- UPDATED MAX Y-AXIS VALUE ---
              maxY: 12000,
            ),
          ),
        ),
      ],
    );
  }
}

// Helper widget for the legend
class _Indicator extends StatelessWidget {
  final Color color;
  final String text;

  const _Indicator({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(text)
      ],
    );
  }
}