part of '_custom_pi_chart.dart';

class CustomPieChartPainter extends CustomPainter {
  const CustomPieChartPainter(this.chartData);
  final List<CustomPiChartData> chartData;

  @override
  void paint(Canvas canvas, Size size) {
    final double minDimension = math.min(size.width, size.height);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = minDimension * 0.18
      ..strokeCap = StrokeCap.round;

    final total = chartData.fold<double>(0, (p, eV) => p + eV.value);
    double startAngle = 0;

    for (var data in chartData) {
      final sweepAngle = (data.value / total) * 2 * math.pi;

      paint.color = data.color ?? Colors.amber;
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(minDimension / 2, minDimension / 2),
          radius: minDimension / 2.5,
        ),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CustomPiChartData {
  final Color? color;
  final String? label;
  final double value;

  const CustomPiChartData({
    this.color,
    this.label,
    required this.value,
  });
}
