// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart' as intl;

// 🌎 Project imports:
import '../../../../../../generated/l10n.dart' as l;
import '../../../../../core/static/static.dart';

class IncomeReportLineChart extends StatelessWidget {
  const IncomeReportLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    final lang = l.S.of(context);

    final _totalIncomeColor = _theme.colorScheme.primary;

    final _titles = {
      1: '${lang.Jan}.',
      2: '${lang.Feb}.',
      3: '${lang.Mar}.',
      4: '${lang.Apr}.',
      5: '${lang.May}.',
      6: '${lang.Jun}.',
      7: '${lang.Jul}.',
      8: '${lang.Aug}.',
      9: '${lang.Sept}.',
      10: '${lang.Oct}.',
      11: '${lang.Nov}.',
      12: '${lang.Dec}.',
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        final _size = constraints.biggest;
        return Column(
          children: [
            Wrap(
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '● ',
                        style: TextStyle(color: _totalIncomeColor),
                      ),
                      TextSpan(
                        // text: "Withdraw: ",
                        text: "${lang.totalIncome}: ",
                        style: TextStyle(
                          color: _isDark
                              ? _theme.colorScheme.onPrimaryContainer
                              : const Color(0xff667085),
                        ),
                      ),
                      TextSpan(
                        text: " \$900",
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
                          final _value = intl.NumberFormat.compactCurrency(
                            decimalDigits: 4,
                            symbol: '',
                            locale: AppLocale.defaultLocale.countryCode,
                          ).format(item.bar.spots[item.spotIndex].y);

                          return LineTooltipItem(
                            "",
                            _theme.textTheme.bodySmall!,
                            textAlign: TextAlign.start,
                            children: [
                              TextSpan(
                                text: ' ${_titles[item.spotIndex + 1]} 2024\n',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              /// Text Dot Indicator [used for the replacement of a circle widget. due to the limitation of fl_chart package, LineTooltipItem class doesn't support a widget span]
                              TextSpan(
                                text: '● ',
                                style: TextStyle(color: item.bar.color),
                              ),
                              TextSpan(
                                //text: "Withdraw:",
                                text: "${lang.income}:",
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
                    LineChartBarData(
                      spots: const [
                        FlSpot(1, 22000),
                        FlSpot(2, 43000),
                        FlSpot(3.85, 23000),
                        FlSpot(5, 63000),
                        FlSpot(6.25, 28000),
                        FlSpot(8.25, 61000),
                        FlSpot(9.25, 40000),
                        FlSpot(10.35, 68000),
                        FlSpot(12, 48000),
                      ],
                      isCurved: true,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      color: _totalIncomeColor,
                      belowBarData: BarAreaData(
                        show: true,
                        applyCutOffY: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [100, 80],
                          tileMode: TileMode.decal,
                          colors: [
                            _totalIncomeColor.withOpacity(0.075),
                            Colors.white,
                          ],
                        ),
                      ),
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
                          padding: const EdgeInsets.only(top: 8),
                          child: Transform.rotate(
                            angle:
                                _size.width < 400 ? (-45 * (3.1416 / 180)) : 0,
                            child: Text(
                              _titles[value.toInt()] ?? '',
                              textDirection: TextDirection.ltr,
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
      },
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
