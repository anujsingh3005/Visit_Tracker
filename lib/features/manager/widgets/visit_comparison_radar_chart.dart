import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class VisitComparisonRadarChart extends StatelessWidget {
  final String salesperson1;
  final String salesperson2;

  const VisitComparisonRadarChart({
    super.key,
    required this.salesperson1,
    required this.salesperson2,
  });

  // Mock data for visits per day
  final Color person1Color = Colors.cyan;
  final Color person2Color = Colors.purple;
  final List<double> visits1 = const [8, 6, 7, 5, 9]; // Mon-Fri
  final List<double> visits2 = const [7, 8, 6, 7, 7]; // Mon-Fri

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
        // 2. The Chart with value labels overlay
        AspectRatio(
          aspectRatio: 1.5,
          child: Stack(
            children: [
              RadarChart(
                RadarChartData(
                  dataSets: [
                    // Data for Person 1
                    RadarDataSet(
                      fillColor: person1Color.withAlpha(51),
                      borderColor: person1Color,
                      entryRadius: 3,
                      dataEntries: visits1.map((v) => RadarEntry(value: v)).toList(),
                      borderWidth: 2,
                    ),
                    // Data for Person 2
                    RadarDataSet(
                      fillColor: person2Color.withAlpha(51),
                      borderColor: person2Color,
                      entryRadius: 3,
                      dataEntries: visits2.map((v) => RadarEntry(value: v)).toList(),
                      borderWidth: 2,
                    ),
                  ],
                  radarBackgroundColor: Colors.transparent,
                  radarBorderData: const BorderSide(color: Colors.grey, width: 1),
                  titlePositionPercentageOffset: 0.2,
                  titleTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  getTitle: (index, angle) {
                    String title;
                    switch (index) {
                      case 0: title = 'Mon'; break;
                      case 1: title = 'Tue'; break;
                      case 2: title = 'Wed'; break;
                      case 3: title = 'Thu'; break;
                      case 4: title = 'Fri'; break;
                      default: title = ''; break;
                    }
                    return RadarChartTitle(text: title);
                  },
                  tickCount: 5,
                  ticksTextStyle: const TextStyle(color: Colors.grey, fontSize: 10),
                  tickBorderData: const BorderSide(color: Colors.grey, width: 1),
                  gridBorderData: const BorderSide(color: Colors.grey, width: 1),
                ),
              ),
              // Custom value labels overlay
              Positioned.fill(
                child: CustomPaint(
                  painter: _RadarValueLabelPainter(
                    visits1: visits1,
                    visits2: visits2,
                    person1Color: person1Color,
                    person2Color: person2Color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom painter to draw value labels on radar chart
class _RadarValueLabelPainter extends CustomPainter {
  final List<double> visits1;
  final List<double> visits2;
  final Color person1Color;
  final Color person2Color;

  _RadarValueLabelPainter({
    required this.visits1,
    required this.visits2,
    required this.person1Color,
    required this.person2Color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;
    final maxValue = 10.0;

    for (int i = 0; i < visits1.length; i++) {
      final angle = (i * 2 * math.pi / visits1.length) - (math.pi / 2);
      
      // Person 1 value position
      final value1Radius = (visits1[i] / maxValue) * radius;
      final x1 = center.dx + value1Radius * math.cos(angle);
      final y1 = center.dy + value1Radius * math.sin(angle);
      _drawLabel(canvas, '${visits1[i].toInt()}', Offset(x1, y1), person1Color);
      
      // Person 2 value position (slightly offset)
      final value2Radius = (visits2[i] / maxValue) * radius;
      final x2 = center.dx + value2Radius * math.cos(angle);
      final y2 = center.dy + value2Radius * math.sin(angle);
      _drawLabel(canvas, '${visits2[i].toInt()}', Offset(x2, y2 + 12), person2Color);
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset position, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.white.withOpacity(0.8),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      position - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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