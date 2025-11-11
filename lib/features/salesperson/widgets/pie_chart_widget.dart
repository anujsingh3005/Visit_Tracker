import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  const PieChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for the chart
    final List<PieChartSectionData> sections = [
      PieChartSectionData(
        color: Colors.green,
        value: 40,
        title: '40%',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.amber,
        value: 30,
        title: '30%',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.red.shade400,
        value: 15,
        title: '15%',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.grey,
        value: 15,
        title: '15%',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ];

    return AspectRatio(
      aspectRatio: 1.5,
      child: Column(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sections: sections,
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Indicator(color: Colors.green, text: 'Completed'),
              SizedBox(width: 8),
              _Indicator(color: Colors.amber, text: 'Follow-up'),
              SizedBox(width: 8),
              _Indicator(color: Colors.red, text: 'Cancelled'),
            ],
          )
        ],
      ),
    );
  }
}

// A helper widget for the chart legend
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