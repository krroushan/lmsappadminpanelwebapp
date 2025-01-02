import 'dart:math' as math;

import 'package:flutter/material.dart';

part '_chart_painter.dart';

class CustomPiChart extends StatelessWidget {
  const CustomPiChart({
    super.key,
    required this.chartData,
  });

  final List<CustomPiChartData> chartData;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        double _refSize = 0;
        if (constraints.maxHeight < constraints.maxWidth) {
          _refSize = constraints.maxHeight / 1.5;
        } else {
          _refSize = constraints.maxWidth / 2;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: _refSize,
              child: AspectRatio(
                aspectRatio: 1,
                child: CustomPaint(
                  painter: CustomPieChartPainter(chartData),
                ),
              ),
            ),
            const SizedBox(width: 24),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: chartData.map(
                  (item) {
                    return Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        vertical: 6,
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '● ',
                              style: TextStyle(
                                color: item.color,
                              ),
                            ),
                            TextSpan(
                              text: item.label,
                            )
                          ],
                        ),
                        style: _theme.textTheme.bodyMedium?.copyWith(),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
