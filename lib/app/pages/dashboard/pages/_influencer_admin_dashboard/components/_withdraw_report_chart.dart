// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart' as intl;

// 🌎 Project imports:
import '../../../../../../generated/l10n.dart' as l;
import '../../../../../core/theme/theme.dart';

class WithdrawReportChart extends StatelessWidget {
  const WithdrawReportChart({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    final _locale = Localizations.localeOf(context);
    final _lang = l.S.of(context);

    const _totalWithdrawColor = AcnooAppColors.kSuccess;

    final _values = {
      01: 60000,
      03: 72000,
      06: 25000,
      10: 67000,
      13: 80000,
      16: 38000,
      19: 63000,
      22: 40000,
      25: 75000,
      27: 36000,
      30: 64000,
      31: 45000,
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
                      const TextSpan(
                        text: '● ',
                        style: TextStyle(color: _totalWithdrawColor),
                      ),
                      TextSpan(
                        // text: "Withdraw: ",
                        text: "${_lang.totalWithdraw}: ",
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
              child: BarChart(
                BarChartData(
                  minY: 0,
                  maxY: 80100,
                  gridData: const FlGridData(
                    drawVerticalLine: false,
                    drawHorizontalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      maxContentWidth: 240,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final _date = (
                          groupIndex <= 0
                              ? _values.keys.toList()[groupIndex]
                              : _values.keys.toList()[groupIndex - 1],
                          _values.keys.toList()[groupIndex],
                        );

                        final _value = intl.NumberFormat.simpleCurrency(
                          decimalDigits: 0,
                          locale: _locale.countryCode,
                        ).format(rod.toY);

                        return BarTooltipItem(
                          "${_date.$1}-${_date.$2} ${_lang.Jun} 2024\n${l.S.current.withdraw}: $_value",
                          _theme.textTheme.bodyMedium!,
                        );
                      },
                      tooltipRoundedRadius: 4,
                      getTooltipColor: (touchedSpot) {
                        return _isDark
                            ? _theme.colorScheme.tertiaryContainer
                            : Colors.white;
                      },
                    ),
                  ),
                  barGroups: List.generate(
                    _values.length,
                    (index) {
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: _values.values.toList()[index].toDouble(),
                            color: _totalWithdrawColor,
                          ),
                        ],
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    topTitles: _getTitlesData(context, show: false),
                    rightTitles: _getTitlesData(context, show: false),
                    leftTitles: _getTitlesData(
                      context,
                      reservedSize: 34,
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
                          padding: const EdgeInsetsDirectional.only(top: 8),
                          child: Transform.rotate(
                            angle:
                                _size.width < 400 ? (-45 * (3.1416 / 180)) : 0,
                            child: Text(
                              "${_values.keys.toList()[value.toInt()]}",
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
