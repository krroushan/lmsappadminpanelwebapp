// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:syncfusion_flutter_charts/charts.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../core/static/static.dart';
import '../../core/theme/theme.dart';

class TransparentChart extends StatefulWidget {
  const TransparentChart({super.key});

  @override
  State<TransparentChart> createState() => _TransparentChartState();
}

class _TransparentChartState extends State<TransparentChart> {
  final List<ChartDatas> chartData = [
    ChartDatas('Jan', 12, 5),
    ChartDatas('Feb', 40, 30),
    ChartDatas('Mar', 30, 20),
    ChartDatas('Apr', 40, 30),
    ChartDatas('May', 20, 13),
    ChartDatas('Jun', 30, 25),
    ChartDatas('July', 40, 25),
    ChartDatas('Agu', 35, 30),
    ChartDatas('Sep', 30, 20),
    ChartDatas('Oct', 26, 16),
    ChartDatas('Nov', 30, 20),
    ChartDatas('Dec', 20, 10),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = l.S.of(context);
    final titleFontSize = rf.ResponsiveValue<double?>(
      context,
      conditionalValues: [
        rf.Condition.smallerThan(name: BreakpointName.SM.name, value: 14)
      ],
    ).value;
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.primaryContainer),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 5),
                child: Text(
                  lang.transparentChart,
                 // 'Transparent Chart',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: titleFontSize,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Divider(
                thickness: 1,
                color: AcnooAppColors.kNeutral300,
                height: 1,
              ),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const CategoryAxis(
                    axisLine: AxisLine(width: 0), // Remove bottom axis line
                    majorGridLines:
                        MajorGridLines(width: 0), // Remove vertical grid lines
                    majorTickLines: MajorTickLines(size: 0),
                  ),
                  primaryYAxis: const NumericAxis(
                    axisLine: AxisLine(width: 0), // Remove left axis line
                    majorGridLines: MajorGridLines(
                      color: Color(0xffD1D5DB),
                      dashArray: [
                        5,
                        5
                      ], // Creates a dotted line pattern for horizontal grid lines
                    ),
                  ),
                  plotAreaBorderWidth: 0,
                  series: <CartesianSeries<ChartDatas, String>>[
                    ColumnSeries<ChartDatas, String>(
                      dataSource: chartData,
                      spacing: 0.3,
                      width: 0.6,
                      xValueMapper: (ChartDatas data, _) => data.x,
                      yValueMapper: (ChartDatas data, _) => data.y,
                      //name: 'Sales',
                      name: lang.sales,
                      onPointTap: (ChartPointDetails details) {
                        _showPopup(context, chartData[details.pointIndex!]);
                      },
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false),
                      color: AcnooAppColors.kPrimary600,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    ColumnSeries<ChartDatas, String>(
                      dataSource: chartData,
                      spacing: 0.3,
                      width: 0.6,
                      xValueMapper: (ChartDatas data, _) => data.x,
                      yValueMapper: (ChartDatas data, _) => data.y1,
                      //name: 'Sales',
                      name: lang.sales,
                      onPointTap: (ChartPointDetails details) {
                        _showPopup(context, chartData[details.pointIndex!]);
                      },
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false),
                      color: AcnooAppColors.kWarning,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showPopup(BuildContext context, ChartDatas data) {
  final lang = l.S.of(context);
  TextTheme textTheme = Theme.of(context).textTheme;
  ColorScheme color = Theme.of(context).colorScheme;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: color.primaryContainer,
        contentPadding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
                text: TextSpan(
                    text: '${lang.date}: ',
                    style: textTheme.titleSmall?.copyWith(fontSize: 12),
                    children: const [
                  TextSpan(
                    text: '13-16 Feb 2024',
                  )
                ])),
            Row(
              children: [
                const Icon(
                  Icons.circle,
                  color: AcnooAppColors.kPrimary500,
                  size: 10,
                ),
                const SizedBox(
                  width: 5,
                ),
                RichText(
                    text: TextSpan(
                        text: '${lang.wordGenerated}: ',
                        style: textTheme.bodySmall?.copyWith(fontSize: 12),
                        children: [
                      TextSpan(
                          text: '7,000',
                          style: textTheme.titleSmall?.copyWith(fontSize: 12))
                    ]))
              ],
            )
          ],
        ),
      );
    },
  );
}

class ChartDatas {
  ChartDatas(this.x, this.y, this.y1);

  final String x;
  final double y;
  final double y1;
}
