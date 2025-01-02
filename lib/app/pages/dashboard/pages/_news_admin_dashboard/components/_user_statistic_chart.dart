// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../../../generated/l10n.dart' as l;
// 🌎 Project imports:
import '../../../../../core/theme/theme.dart';

class UserStatisticChart extends StatelessWidget {
  const UserStatisticChart({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    final lang = l.S.of(context);

    const _freeUsersColor = AcnooAppColors.kPrimary600;
    const _subscribedUsersColor = AcnooAppColors.kWarning;

    final _values = {
      lang.Jan: 60000,
      lang.Feb: 72000,
      lang.Mar: 25000,
      lang.Apr: 67000,
      lang.May: 80000,
      lang.Jun: 38000,
      lang.Jul: 63000,
      lang.Aug: 40000,
      lang.Sept: 75000,
      lang.Oct: 36000,
      lang.Nov: 64000,
      lang.Dec: 45000,
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        final _size = constraints.biggest;
        final _showCompact = _size.width < 400;

        return Column(
          children: [
            Wrap(
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: '● ',
                        style: TextStyle(color: _freeUsersColor),
                      ),
                      TextSpan(
                       // text: "Free Users: ",
                        text: "${lang.freeUsers}: ",
                        style: TextStyle(
                          color: _isDark
                              ? _theme.colorScheme.onPrimaryContainer
                              : const Color(0xff667085),
                        ),
                      ),
                      TextSpan(
                        text: intl.NumberFormat.currency(
                          symbol: '',
                        ).format(20000),
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
                        style: TextStyle(color: _subscribedUsersColor),
                      ),
                      TextSpan(
                        //text: "Subscribed: ",
                        text: "${lang.subscribed}: ",
                        style: TextStyle(
                          color: _isDark
                              ? _theme.colorScheme.onPrimaryContainer
                              : const Color(0xff667085),
                        ),
                      ),
                      TextSpan(
                        text: intl.NumberFormat.currency(
                          symbol: '',
                        ).format(10000),
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
              ],
            ),
            const SizedBox(height: 24),
            Flexible(
              child: BarChart(
                BarChartData(
                  minY: 0,
                  maxY: 80100,
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        dashArray: [5, 3, 0],
                        strokeWidth: 1,
                        color: _theme.colorScheme.outline,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      maxContentWidth: 240,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final _barRods = group.barRods;
                        final lang = l.S.of(context);

                        num _freeUsers =
                            _barRods.isNotEmpty ? _barRods.first.toY : 0;
                        num _subscribedUsers =
                            _barRods.length > 1 ? _barRods[1].toY : 0;

                        String _groupLabel = _values.keys.toList()[groupIndex];

                        return BarTooltipItem(
                          '',
                          textAlign: TextAlign.start,
                          children: [
                            TextSpan(
                              text: "$_groupLabel 2024\n",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: '● ',
                                  style: TextStyle(color: _freeUsersColor),
                                ),
                                 TextSpan(text: '${lang.free}: '),
                                TextSpan(
                                  text:
                                      "${intl.NumberFormat.compact().format(_freeUsers)}\n",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: '● ',
                                  style:
                                      TextStyle(color: _subscribedUsersColor),
                                ),
                                //const TextSpan(text: 'Subscribe: '),
                                 TextSpan(text: '${lang.subscribe}: '),
                                TextSpan(
                                  text: intl.NumberFormat.compact()
                                      .format(_subscribedUsers),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          ],
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
                          _getBarChartRodData(
                            context,
                            toY: _values.values.toList()[index].toDouble(),
                            color: _freeUsersColor,
                          ),
                          _getBarChartRodData(
                            context,
                            toY: (_values.values.toList()[index] - 15000)
                                .toDouble(),
                            color: _subscribedUsersColor,
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
                            angle: _showCompact ? (-55 * (3.1416 / 180)) : 0,
                            child: Text(
                              _values.keys.toList()[value.toInt()],
                              textDirection: TextDirection.ltr,
                              style: _theme.textTheme.bodyMedium?.copyWith(
                                color: _theme.colorScheme.onTertiary,
                                fontSize: _showCompact ? 12 : null,
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

  BarChartRodData _getBarChartRodData(
    BuildContext context, {
    required double toY,
    Color? color,
  }) {
    final _mqSize = MediaQuery.sizeOf(context);

    return BarChartRodData(
      toY: toY,
      color: color,
      width: _mqSize.width < 375
          ? 4
          : _mqSize.width < 480
              ? 6
              : _mqSize.width < 768
                  ? 8
                  : 12,
    );
  }
}
