// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../../../../generated/l10n.dart' as l;
// 🌎 Project imports:
import '../../../../../core/static/static.dart';
import '../../../../../core/theme/theme.dart';

class SMSHistoryStatisticsChart extends StatelessWidget {
  const SMSHistoryStatisticsChart({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    final _mqSize = MediaQuery.sizeOf(context);
    final lang = l.S.of(context);
    const _incomingColor = AcnooAppColors.kSuccess;
    const _outgoingColor = AcnooAppColors.kWarning;

    final _months = {
      1: lang.Jan,
      2: lang.Feb,
      3: lang.Mar,
      4: lang.Apr,
      5: lang.May,
      6: lang.Jun,
      7: lang.Jul,
      8: lang.Aug,
      9: lang.Sept,
      10: lang.Oct,
      11: lang.Nov,
      12: lang.Dec,
    };

    return Column(
      children: [
        Wrap(
          children: [
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: '● ',
                    style: TextStyle(color: _outgoingColor),
                  ),
                  TextSpan(
                   // text: "Outgoing: ",
                    text: "${lang.outgoing}: ",
                    style: TextStyle(
                      color: _isDark
                          ? _theme.colorScheme.onPrimaryContainer
                          : const Color(0xff667085),
                    ),
                  ),
                  TextSpan(
                    text: "50",
                    style: TextStyle(
                      color: _isDark
                          ? _theme.colorScheme.onPrimaryContainer
                          : const Color(0xff344054),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: '● ',
                    style: TextStyle(color: _incomingColor),
                  ),
                  TextSpan(
                    //text: "Incoming: ",
                    text: "${lang.incoming}: ",
                    style: TextStyle(
                      color: _isDark
                          ? _theme.colorScheme.onPrimaryContainer
                          : const Color(0xff667085),
                    ),
                  ),
                  TextSpan(
                    text: "30",
                    style: TextStyle(
                      color: _isDark
                          ? _theme.colorScheme.onPrimaryContainer
                          : const Color(0xff344054),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              style: _theme.textTheme.bodyMedium?.copyWith(),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Flexible(
          child: LineChart(
            LineChartData(
              minX: 1,
              maxX: 12,
              minY: 0,
              maxY: 80100,
              gridData: FlGridData(
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: _theme.colorScheme.outline,
                  dashArray: [10, 5],
                ),
              ),
              borderData: FlBorderData(show: false),
              lineTouchData: LineTouchData(
                getTouchedSpotIndicator: (barData, spotIndexes) {
                  return spotIndexes
                      .map(
                        (item) => TouchedSpotIndicatorData(
                          const FlLine(color: Colors.transparent),
                          FlDotData(
                            getDotPainter: (p0, p1, p2, p3) {
                              return FlDotCirclePainter(
                                color: p2.color ?? Colors.transparent,
                                strokeWidth: 2.5,
                                strokeColor: Colors.white,
                              );
                            },
                          ),
                        ),
                      )
                      .toList();
                },
                touchTooltipData: LineTouchTooltipData(
                  maxContentWidth: 240,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((item) {
                      final _value = NumberFormat.simpleCurrency(
                        decimalDigits: 0,
                        // symbol: '',
                        locale: AppLocale.defaultLocale.countryCode,
                      ).format(item.bar.spots[item.spotIndex].y);

                      return LineTooltipItem(
                        "",
                        _theme.textTheme.bodySmall!,
                        textAlign: TextAlign.start,
                        children: [
                          if (item.barIndex <= 0)
                            TextSpan(
                              text: " ${_months[item.spotIndex + 1]} 2024\n",
                            ),

                          /// Text Dot Indicator [used for the replacement of a circle widget. due to the limitation of fl_chart package, LineTooltipItem class doesn't support a widget span]
                          TextSpan(
                            text: '● ',
                            style: TextStyle(color: item.bar.color),
                          ),
                          TextSpan(
                            text:
                               // "${item.barIndex == 0 ? 'Outgoing' : 'Incoming'}:",
                                "${item.barIndex == 0 ? lang.outgoing : lang.incoming}:",
                            style: TextStyle(
                              color: _isDark
                                  ? _theme.colorScheme.onPrimaryContainer
                                  : const Color(0xff667085),
                            ),
                          ),
                          TextSpan(
                            text: " $_value",
                            style: TextStyle(
                              color: _isDark
                                  ? _theme.colorScheme.onPrimaryContainer
                                  : const Color(0xff344054),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  },
                  tooltipRoundedRadius: 4,
                  getTooltipColor: (touchedSpot) {
                    return _isDark
                        ? _theme.colorScheme.tertiaryContainer
                        : Colors.white;
                  },
                ),
              ),
              lineBarsData: [
                _getLineChartBarData(
                  color: _incomingColor,
                  spots: const [
                    FlSpot(1, 20000),
                    FlSpot(3.45, 33500),
                    FlSpot(4.75, 20500),
                    FlSpot(6.75, 37500),
                    FlSpot(8.75, 28500),
                    FlSpot(10.75, 75500),
                    FlSpot(12, 65500),
                  ],
                ),
                _getLineChartBarData(
                  color: _outgoingColor,
                  spots: const [
                    FlSpot(1, 5000),
                    FlSpot(4.75, 33500),
                    FlSpot(6.75, 20500),
                    FlSpot(8.75, 22500),
                    FlSpot(10.75, 33500),
                    FlSpot(12, 27500),
                  ],
                ),
              ],
              titlesData: FlTitlesData(
                topTitles: _getTitlesData(context, show: false),
                rightTitles: _getTitlesData(context, show: false),
                leftTitles: _getTitlesData(
                  context,
                  reservedSize: 40,
                  interval: 20000,
                  getTitlesWidget: (value, titleMeta) {
                    const titlesMap = {
                      0: '0',
                      20000: '20k',
                      40000: '40k',
                      60000: '60k',
                      80000: '80k',
                    };

                    return Text(
                      titlesMap[value.toInt()] ?? '',
                      style: _theme.textTheme.bodyMedium?.copyWith(
                        color: _theme.colorScheme.onTertiary,
                      ),
                    );
                  },
                ),
                bottomTitles: _getTitlesData(
                  context,
                  interval: 1,
                  reservedSize: 28,
                  getTitlesWidget: (value, titleMeta) {
                    return Padding(
                      padding: const EdgeInsetsDirectional.only(
                        top: 8,
                        end: 24,
                      ),
                      child: Transform.rotate(
                        angle: _mqSize.width < 480 ? (-45 * (3.1416 / 180)) : 0,
                        child: Text(
                          _months[value.toInt()] ?? '',
                          style: _theme.textTheme.bodyMedium?.copyWith(
                            color: _theme.colorScheme.onTertiary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartBarData _getLineChartBarData({
    Color color = Colors.red,
    List<FlSpot> spots = const [],
  }) {
    return LineChartBarData(
      spots: spots,
      barWidth: 2,
      color: color,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        applyCutOffY: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [100, 80],
          tileMode: TileMode.decal,
          colors: [
            color.withOpacity(0.075),
            Colors.white,
          ],
        ),
      ),
    );
  }

  AxisTitles _getTitlesData(
    BuildContext context, {
    bool show = true,
    Widget Function(double value, TitleMeta titleMeta)? getTitlesWidget,
    double reservedSize = 22,
    double? interval,
  }) {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: show,
        getTitlesWidget: getTitlesWidget ?? defaultGetTitle,
        reservedSize: reservedSize,
        interval: interval,
      ),
    );
  }
}
