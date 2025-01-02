// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

// 🌎 Project imports:
import 'package:acnoo_flutter_admin_panel/app/core/theme/theme.dart';
import '../../../../../../generated/l10n.dart' as l;
import '../../../../../core/static/static.dart';

class SalesOverviewChart extends StatelessWidget {
  const SalesOverviewChart({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Overviews
        _OverviewTile(),
        SizedBox(height: 20),
        // Chart
        Flexible(child: _SalesOverviewLineChart()),
      ],
    );
  }
}

class _OverviewTile extends StatelessWidget {
  const _OverviewTile({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    final _lightGradientColors = [
      const Color(0xffF9F3FF),
      const Color(0xffE8FFF0),
      const Color(0xffF0E3FF),
      const Color(0xffFFF1E3),
      const Color(0xffF9F3FF),
    ];
    final _darkGradientColors = [
      const Color(0xffF9F3FF).withOpacity(0.04),
      const Color(0xff8FFFB9).withOpacity(0.25),
      const Color(0xffC696FF).withOpacity(0.25),
      const Color(0xffFFCC9D).withOpacity(0.25),
      const Color(0xffF9F3FF).withOpacity(0.04),
    ];

    return Container(
      constraints: BoxConstraints.loose(const Size.fromHeight(64)),
      padding: const EdgeInsetsDirectional.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          colors: _isDark ? _darkGradientColors : _lightGradientColors,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: {
          lang.revenue: 800,
          lang.sales: 600,
          lang.products: 20,
        }.entries.map((item) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                NumberFormat.currency(
                  symbol: '',
                  decimalDigits: 0,
                ).format(item.value),
                style: _theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                item.key,
                style: _theme.textTheme.bodyMedium?.copyWith(
                  color: _theme.colorScheme.onTertiaryContainer,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SalesOverviewLineChart extends StatelessWidget {
  const _SalesOverviewLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;

    final _mqSize = MediaQuery.sizeOf(context);

    final _titles = {
      1: '2hr',
      2: '4hr',
      3: '6hr',
      4: '8hr',
      5: '10hr',
      6: '12hr',
      7: '14hr',
      8: '16hr',
      9: '18hr',
      10: '20hr',
      11: '22hr',
      12: '24hr',
    };

    return LineChart(
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
                final _value = NumberFormat.compactCurrency(
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
                      text: "${lang.withdraw}:",
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
          _getData(
            data: const [
              FlSpot(1, 40000),
              FlSpot(2, 45000),
              FlSpot(4, 20000),
              FlSpot(6, 30000),
              FlSpot(8, 35000),
              FlSpot(10, 50000),
              FlSpot(12, 75000),
            ],
            color: AcnooAppColors.kPrimary600,
          ),
          _getData(
            data: const [
              FlSpot(1, 20000),
              FlSpot(2, 25000),
              FlSpot(4, 30000),
              FlSpot(6, 20000),
              FlSpot(8, 40000),
              FlSpot(10, 15000),
              FlSpot(12, 30000),
            ],
            color: AcnooAppColors.kWarning,
          ),
          _getData(
            data: const [
              FlSpot(1, 50000),
              FlSpot(2, 60000),
              FlSpot(4, 30000),
              FlSpot(6, 25000),
              FlSpot(8, 60000),
              FlSpot(10, 35000),
              FlSpot(12, 40000),
            ],
            color: AcnooAppColors.kSuccess,
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

  LineChartBarData _getData({
    required List<FlSpot> data,
    Color? color,
  }) {
    return LineChartBarData(
      spots: data,
      isCurved: true,
      barWidth: 5,
      dotData: const FlDotData(show: false),
      color: color,
    );
  }
}
