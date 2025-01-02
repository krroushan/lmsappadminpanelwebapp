// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../core/static/static.dart';
import '../../core/theme/theme.dart';
import '_pie_chart_indicator.dart';

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({super.key});

  @override
  State<StatefulWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final lang = l.S.of(context);
        final theme = Theme.of(context);
        final titleFontSize = rf.ResponsiveValue<double?>(
          context,
          conditionalValues: [
            rf.Condition.smallerThan(name: BreakpointName.SM.name, value: 14)
          ],
        ).value;
        double chartSize = constraints.maxWidth * 0.2;
        return Container(
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
                  lang.pieChart,
                  //'Pie Chart',
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Expanded(child: SizedBox()),
                    Expanded(
                      flex: 2,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Center(
                          child: SizedBox(
                            height: 200,
                            width: 200,
                            child: PieChart(
                              PieChartData(
                                centerSpaceRadius: chartSize * 0.5,
                                pieTouchData: PieTouchData(
                                  touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection ==
                                              null) {
                                        touchedIndex = -1;
                                        return;
                                      }
                                      touchedIndex = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                    });
                                  },
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 0,
                                sections: showingSection(chartSize),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                     Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            PieDataIndicator(
                              color: AcnooAppColors.kWarning,
                             // text: 'First',
                              text: lang.first,
                            ),
                            const SizedBox(height: 16),
                            PieDataIndicator(
                              color: AcnooAppColors.kPrimary600,
                              //text: 'Second',
                              text:lang.second,
                            ),
                            const SizedBox(height: 16),
                            PieDataIndicator(
                              color: AcnooAppColors.kSuccess,
                             // text: 'Third',
                              text: lang.third,
                            ),
                            const SizedBox(height: 16),
                            PieDataIndicator(
                              color: AcnooAppColors.kError,
                             // text: 'Fourth',
                              text: lang.fourth,
                            ),
                            const SizedBox(height: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<PieChartSectionData> showingSection(double chartSize) {
    final fontSize = rf.ResponsiveValue<double?>(context, conditionalValues: [
      rf.Condition.smallerThan(name: BreakpointName.SM.name, value: 13)
    ]).value;
    final theme = Theme.of(context);
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? chartSize * 0.6 : chartSize * 0.5;
      final style = theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
          color: AcnooAppColors.kWhiteColor);
      switch (i) {
        case 0:
          return PieChartSectionData(
              color: AcnooAppColors.kWarning,
              radius: radius,
              title: '15%',
              value: 15,
              titleStyle: style);
        case 1:
          return PieChartSectionData(
              color: AcnooAppColors.kSuccess,
              radius: radius,
              title: '50%',
              value: 50,
              titleStyle: style);
        case 2:
          return PieChartSectionData(
              color: AcnooAppColors.kError,
              radius: radius,
              title: '20%',
              value: 30,
              titleStyle: style);
        case 3:
          return PieChartSectionData(
              color: AcnooAppColors.kPrimary600,
              radius: radius,
              title: '15%',
              value: 15,
              titleStyle: style);
        default:
          throw Error();
      }
    });
  }
}
