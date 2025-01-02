// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../core/helpers/fuctions/helper_functions.dart';
import '../../core/theme/theme.dart';
import '../../pages/widgets_page/general_data/general_data_model.dart';

class GeneralEarnWidget extends StatelessWidget {
  const GeneralEarnWidget({
    super.key,
    required this.cryptoList,
  });

  final CryptoDataModel cryptoList;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final fontTitle = responsiveValue<double>(
      context,
      xs: 18,
      md: 20,
      lg: 20,
    );
    final subTitle = responsiveValue<double>(
      context,
      xs: 14,
      md: 16,
      lg: 16,
    );
    return Container(
      width: double.maxFinite,
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Section
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (cryptoList.imagePath != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 16),
                    child: getImageType(cryptoList.imagePath)!,
                  ),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Title
                      Text(
                        cryptoList.coinName,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600, fontSize: fontTitle),
                      ),
                      const SizedBox(width: 4),

                      // Top Subtitle

                      Text(
                        cryptoList.shortName.toString(),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        style: textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onTertiaryContainer,
                          fontSize: subTitle,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // Bottom Section
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (cryptoList.price != null)
                        // Bottom Title
                        Text(
                          cryptoList.price!,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600, fontSize: fontTitle),
                        ),

                      // Bottom Subtitle
                      Text(
                        cryptoList.statusPercentage ?? '',
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        style: textTheme.bodyLarge?.copyWith(
                          color: cryptoList.percentageColor,
                          fontSize: subTitle,
                        ),
                      ),
                    ],
                  ),
                ),

                // Graph
                Flexible(
                  flex: 3,
                  child: LineChart(
                    mainData(gradient: cryptoList.chartColor, theme: theme),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  LineChartData mainData({Gradient? gradient, required ThemeData theme}) {
    List<Color> gradientColors = [
      AcnooAppColors.kPrimary600,
      AcnooAppColors.kPrimary600,
    ];
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 100,
      minY: 0,
      maxY: 1000,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => theme.colorScheme.tertiaryContainer,
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 350),
            FlSpot(5, 200),
            FlSpot(10, 270),
            FlSpot(15, 195),
            FlSpot(20, 330),
            FlSpot(22, 520),
            FlSpot(35, 295),
            FlSpot(45, 620),
            FlSpot(57, 300),
            FlSpot(75, 650),
            FlSpot(85, 550),
            FlSpot(95, 750),
            FlSpot(100, 950),
          ],
          isCurved: true,
          gradient: gradient ??
              LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: gradientColors),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: (gradient?.colors ?? gradientColors)
                  .map((color) => color)
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
