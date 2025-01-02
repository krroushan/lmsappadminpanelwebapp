// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import '../../../../../../generated/l10n.dart' as l;
// 📦 Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class RevenueChart extends StatelessWidget {
  const RevenueChart({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    final _mqSize = MediaQuery.sizeOf(context);

    final _incomingColor = _theme.colorScheme.primary;

    return LineChart(
      LineChartData(
        minX: 1,
        maxX: 31,
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
                  locale: Localizations.localeOf(context).countryCode,
                ).format(item.bar.spots[item.spotIndex].y);

                return LineTooltipItem(
                  "",
                  _theme.textTheme.bodySmall!,
                  textAlign: TextAlign.start,
                  children: [
                    if (item.barIndex <= 0)
                      TextSpan(
                        text:
                            " ${(item.bar.spots[item.spotIndex > 0 ? (item.spotIndex - 1) : item.spotIndex].x).toInt()}-${item.x.toInt()} May 2024\n",
                      ),

                    /// Text Dot Indicator [used for the replacement of a circle widget. due to the limitation of fl_chart package, LineTooltipItem class doesn't support a widget span]
                    TextSpan(
                      text: '● ',
                      style: TextStyle(color: item.bar.color),
                    ),
                    TextSpan(
                     // text: "Revenue: ",
                      text: "${lang.revenue}: ",
                      style: TextStyle(
                        color: _isDark
                            ? _theme.colorScheme.onPrimaryContainer
                            : const Color(0xff667085),
                      ),
                    ),
                    TextSpan(
                      text: _value,
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
              FlSpot(7, 45500),
              FlSpot(13, 28000),
              FlSpot(19, 48500),
              FlSpot(23, 38500),
              FlSpot(27, 62500),
              FlSpot(31, 58500),
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
              if (value.toInt() % 2 == 0) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: 8,
                  end: 24,
                ),
                child: Transform.rotate(
                  angle: _mqSize.width < 480 ? (-45 * (3.1416 / 180)) : 0,
                  child: Text(
                    value.toString(),
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
