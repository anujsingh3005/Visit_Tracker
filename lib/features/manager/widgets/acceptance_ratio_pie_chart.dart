import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AcceptanceRatioPieChart extends StatelessWidget {
  final String name;
  final double ratio; // A value between 0.0 and 1.0

  const AcceptanceRatioPieChart({
    super.key,
    required this.name,
    required this.ratio,
  });

  @override
  Widget build(BuildContext context) {
    final int percentage = (ratio * 100).round();
    final Color acceptedColor = Colors.green[400]!;
    final Color remainingColor = Colors.grey[300]!;

    return SizedBox(
      width: 140, // Constrain the size
      child: Column(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            // We use a Stack to put the text in the middle of the chart
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sections: [
                      // The "Accepted" slice
                      PieChartSectionData(
                        color: acceptedColor,
                        value: ratio,
                        title: '', // We show the title in the center
                        radius: 20,
                      ),
                      // The "Remaining" slice
                      PieChartSectionData(
                        color: remainingColor,
                        value: 1.0 - ratio,
                        title: '',
                        radius: 20,
                      ),
                    ],
                    sectionsSpace: 0,
                    centerSpaceRadius: 40, // This creates the donut hole
                  ),
                ),
                // The text in the center
                Center(
                  child: Text(
                    '$percentage%',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}