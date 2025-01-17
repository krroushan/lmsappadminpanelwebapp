// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

// 🌎 Project imports:
import '../../../../../../generated/l10n.dart' as l;
import '../../../../../core/static/static.dart';

class SMSHistoryStatisticsLineChart extends StatelessWidget {
  const SMSHistoryStatisticsLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    final lang = l.S.of(context);
    final _mqSize = MediaQuery.sizeOf(context);

    final _presentColor = _theme.colorScheme.primary;

    final _titles = {
      1: 'Sat',
      2: 'Sun',
      3: 'Mon',
      4: 'Tue',
      5: 'Wed',
      6: 'Thu',
      7: 'Fri',
    };

    return Column(
      children: [
        Wrap(
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '● ',
                    style: TextStyle(color: _presentColor),
                  ),
                  TextSpan(
                    text: "Total Present: ",
                    style: TextStyle(
                      color: _isDark
                          ? _theme.colorScheme.onPrimaryContainer
                          : const Color(0xff667085),
                    ),
                  ),
                  TextSpan(
                    text: " 348",
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
          ],
        ),
        const SizedBox(height: 24),
        Flexible(
          child: LineChart(
            LineChartData(
              minX: 1,
              maxX: 7,
              minY: 0,
              maxY: 100,
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
                                color: Colors.white,
                                strokeWidth: 2.5,
                                strokeColor: p2.color ?? Colors.transparent,
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
                      final _value = NumberFormat.compact(
                        locale: AppLocale.defaultLocale.countryCode,
                      ).format(item.bar.spots[item.spotIndex].y);

                      return LineTooltipItem(
                        "",
                        _theme.textTheme.bodySmall!,
                        textAlign: TextAlign.start,
                        children: [
                          TextSpan(
                            text: ' ${_titles[item.spotIndex + 1]}\n',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: '● ',
                            style: TextStyle(color: item.bar.color),
                          ),
                          TextSpan(
                            text: "Present:",
                            style: TextStyle(
                              color: _isDark
                                  ? _theme.colorScheme.onPrimaryContainer
                                  : const Color(0xff667085),
                            ),
                          ),
                          TextSpan(
                            text: " $_value%",
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
                LineChartBarData(
                  spots: const [
                    FlSpot(1, 85),
                    FlSpot(2, 0),
                    FlSpot(3, 88),
                    FlSpot(4, 92),
                    FlSpot(5, 86),
                    FlSpot(6, 75),
                    FlSpot(7, 90),
                  ],
                  isCurved: true,
                  barWidth: 2,
                  dotData: const FlDotData(show: false),
                  color: _presentColor,
                ),
              ],
              titlesData: FlTitlesData(
                topTitles: _getTitlesData(context, show: false),
                rightTitles: _getTitlesData(context, show: false),
                leftTitles: _getTitlesData(
                  context,
                  reservedSize: 40,
                  interval: 20,
                  getTitlesWidget: (value, titleMeta) {
                    const titlesMap = {
                      0: '0%',
                      20: '20%',
                      40: '40%',
                      60: '60%',
                      80: '80%',
                      100: '100%',
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
                      padding: const EdgeInsets.only(top: 8),
                      child: Transform.rotate(
                        angle: _mqSize.width < 480 ? (-45 * (3.1416 / 180)) : 0,
                        child: Text(
                          _titles[value.toInt()] ?? '',
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
