// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../core/static/static.dart';
import '../../core/theme/theme.dart';

class SubscriptionStaticsChart extends StatefulWidget {
  const SubscriptionStaticsChart({super.key});

  @override
  State<SubscriptionStaticsChart> createState() =>
      _SubscriptionStaticsChartState();
}

class _SubscriptionStaticsChartState extends State<SubscriptionStaticsChart> {
  List<Color> gradientColors = [
    AcnooAppColors.kPrimary600,
    AcnooAppColors.kPrimary600,
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            right: 18,
            left: 12,
            top: 15,
            bottom: 12,
          ),
          child: LineChart(
            showAvg ? avgData() : mainData(),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              '',
              // 'avg',
              style: TextStyle(
                fontSize: 12,
                color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final fontSize = rf.ResponsiveValue<double?>(context, conditionalValues: [
      rf.Condition.smallerThan(name: BreakpointName.SM.name, value: 10)
    ]).value;
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
        // color: AcnooAppColors.kNeutral700,
        fontSize: fontSize);
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('01', style: style);
        break;
      case 4:
        text = Text('04', style: style);
        break;
      case 7:
        text = Text('07', style: style);
        break;
      case 10:
        text = Text('10', style: style);
        break;
      case 13:
        text = Text('13', style: style);
        break;
      case 16:
        text = Text('16', style: style);
        break;
      case 19:
        text = Text('19', style: style);
        break;
      case 22:
        text = Text('22', style: style);
        break;
      case 25:
        text = Text('25', style: style);
        break;
      case 28:
        text = Text('28', style: style);
        break;
      case 30:
        text = Text('30', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final fontSize = rf.ResponsiveValue<double?>(context, conditionalValues: [
      rf.Condition.smallerThan(name: BreakpointName.SM.name, value: 10)
    ]).value;
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
        // color: AcnooAppColors.kNeutral700,
        fontSize: fontSize);
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      // case 5000:
      //   text = '5k';
      //   break;
      case 10000:
        text = '10k';
        break;
      case 20000:
        text = '20k';
        break;
      case 30000:
        text = '30k';
        break;
      case 40000:
        text = '40k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false, // Remove vertical grid lines
        horizontalInterval: 5000,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AcnooAppColors.kNeutral300,
            strokeWidth: 1,
            dashArray: [3, 3], // Add dash array for dotted line
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 5000,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 1,
      maxX: 30,
      minY: 0,
      maxY: 40005,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(1, 10000),
            FlSpot(4, 5000),
            FlSpot(7, 15000),
            FlSpot(10, 10000),
            FlSpot(13, 30000),
            FlSpot(16, 20000),
            FlSpot(19, 15000),
            FlSpot(22, 25000),
            FlSpot(25, 15000),
            FlSpot(28, 10000),
            FlSpot(30, 20000),
          ],
          isCurved: true,
          gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(colors: [
              const Color(0xff7500FD).withOpacity(0.09),
              const Color(0xffDAC0FE).withOpacity(0.15)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false, // Remove vertical grid lines
        horizontalInterval: 5000,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AcnooAppColors.kNeutral300,
            strokeWidth: 1,
            dashArray: [3, 3], // Add dash array for dotted line
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 5000,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 1,
      maxX: 30,
      minY: 0,
      maxY: 40000,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(1, 15000),
            FlSpot(4, 15000),
            FlSpot(7, 15000),
            FlSpot(10, 15000),
            FlSpot(13, 15000),
            FlSpot(16, 15000),
            FlSpot(19, 15000),
            FlSpot(22, 15000),
            FlSpot(25, 15000),
            FlSpot(28, 15000),
            FlSpot(30, 15000),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!
                  .withOpacity(0.5),
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!
                  .withOpacity(0.5),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
      ],
    );
  }
}
