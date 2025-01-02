// 🎯 Dart imports:
import 'dart:math' as math;

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../core/theme/theme.dart';

class GaugeChart extends StatefulWidget {
  const GaugeChart({super.key});

  @override
  State<GaugeChart> createState() => _GaugeChartState();
}

class _GaugeChartState extends State<GaugeChart> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final gaugeWidth = screenSize.width * 0.6; // Adjust as needed
    final gaugeHeight = gaugeWidth * 0.5; // Fixed ratio for height
    return Center(
      child: AspectRatio(
        aspectRatio: 1.5, // 2:1 ratio for width:height
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Custom gauge chart
            CustomPaint(
              size: Size(gaugeWidth, gaugeHeight),
              painter: GaugeChartPainter(
                value: 60,
                radius: gaugeWidth * 0.5,
              ),
            ),
            // Custom pointer (emoji or image)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AcnooAppColors.kNeutral200,
              ),
              child: Icon(Icons.emoji_emotions,
                  size: gaugeWidth * 0.2, color: AcnooAppColors.kWarning),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}

class GaugeChartPainter extends CustomPainter {
  final double value;
  final double radius;

  GaugeChartPainter({required this.value, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint axisPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.2;

    const double startAngle = -math.pi / 1; // Start from top
    const double sweepAngle = math.pi; // 180 degrees

    final Rect rect =
        Rect.fromCircle(center: size.center(Offset.zero), radius: radius);

    // Draw the axis (background of the gauge)
    canvas.drawArc(rect, startAngle, sweepAngle, false, axisPaint);

    final Paint progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xffFD7F0B), Color(0xffFFCFA4)],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.2;

    final double progressSweepAngle = (value / 100) * sweepAngle;
    // Draw the progress bar with gradient
    canvas.drawArc(rect, startAngle, progressSweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
