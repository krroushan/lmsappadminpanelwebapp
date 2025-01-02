// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:syncfusion_flutter_charts/charts.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../core/theme/theme.dart';

class StaticsNumericChartWidget extends StatefulWidget {
  const StaticsNumericChartWidget({super.key});

  @override
  State<StaticsNumericChartWidget> createState() =>
      _StaticsNumericChartWidgetState();
}

class _StaticsNumericChartWidgetState extends State<StaticsNumericChartWidget> {
  final List<ChartData> chartData = [
    ChartData('01', 3),
    ChartData('02', 4),
    ChartData('03', 10),
    ChartData('07', 8),
    ChartData('10', 4),
    ChartData('13', 6),
    ChartData('16', 3),
  ];

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final theme = Theme.of(context);
    return Center(
      child: Container(
        height: 80,
        width: 194,
        padding: const EdgeInsets.all(16.0),
        color: theme.colorScheme.primaryContainer,
        child: SfCartesianChart(
          primaryXAxis: const CategoryAxis(
            isVisible: false, // Hide x-axis labels
            axisLine: AxisLine(width: 0), // Remove bottom axis line
            majorGridLines:
                MajorGridLines(width: 0), // Remove vertical grid lines
            majorTickLines: MajorTickLines(size: 0),
          ),
          primaryYAxis: const NumericAxis(
            maximum: 10,
            isVisible: false, // Hide y-axis labels
            axisLine: AxisLine(width: 0), // Remove left axis line
            majorGridLines:
                MajorGridLines(width: 0), // Remove vertical grid lines
            majorTickLines: MajorTickLines(size: 0),
          ),
          plotAreaBorderWidth: 0,
          series: <CartesianSeries<ChartData, String>>[
            ColumnSeries<ChartData, String>(
              dataSource: chartData,
              spacing: 0.0,
              width: 0.4,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              //name: 'Sales',
              name: lang.sales,
              dataLabelSettings: const DataLabelSettings(isVisible: false),
              pointColorMapper: (ChartData data, _) {
                if (data.y >= 5) {
                  return AcnooAppColors.kPrimary600;
                } else {
                  return AcnooAppColors.kNeutral200;
                }
              },
              borderRadius: BorderRadius.circular(20),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}

///-------------------------responsive chart--------------------

/*class StaticsNumericChartWidget extends StatefulWidget {
  const StaticsNumericChartWidget({super.key});

  @override
  State<StaticsNumericChartWidget> createState() => _StaticsNumericChartWidgetState();
}

class _StaticsNumericChartWidgetState extends State<StaticsNumericChartWidget> {
  final List<ChartData> chartData = [
    ChartData('01', 3),
    ChartData('02', 4),
    ChartData('03', 6),
    ChartData('07', 3),
    ChartData('10', 4),
    ChartData('13', 6),
    ChartData('16', 3),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double aspectRatio = constraints.maxWidth / constraints.maxHeight;

        // Ensure aspect ratio is greater than 0
        if (aspectRatio <= 0) {
          aspectRatio = 1;
        }

        return Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            color: theme.colorScheme.primaryContainer,
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  isVisible: false, // Hide x-axis labels
                  axisLine: const AxisLine(width: 0), // Remove bottom axis line
                  majorGridLines: const MajorGridLines(width: 0), // Remove vertical grid lines
                  majorTickLines: const MajorTickLines(size: 0),
                ),
                primaryYAxis: NumericAxis(
                  // maximum: 20,
                  isVisible: false, // Hide y-axis labels
                  axisLine: const AxisLine(width: 0), // Remove left axis line
                  majorGridLines: const MajorGridLines(width: 0), // Remove vertical grid lines
                  majorTickLines: const MajorTickLines(size: 0),
                ),
                plotAreaBorderWidth: 0,
                series: <CartesianSeries<ChartData, String>>[
                  ColumnSeries<ChartData, String>(
                    dataSource: chartData,
                    spacing: 0.3,
                    width: 0.6,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    name: 'Sales',
                    dataLabelSettings: const DataLabelSettings(isVisible: false),
                    pointColorMapper: (ChartData data, _) {
                      if (data.y >= 5) {
                        return AcnooAppColors.kPrimary600;
                      }
                       else {
                        return AcnooAppColors.kNeutral200;
                      }
                    },
                    borderRadius:  BorderRadius.circular(20),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
} */
