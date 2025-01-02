// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:responsive_grid/responsive_grid.dart';

class SalesByCountryPiChart extends StatefulWidget {
  const SalesByCountryPiChart({super.key});

  @override
  State<SalesByCountryPiChart> createState() => _SalesByCountryPiChartState();
}

class _SalesByCountryPiChartState extends State<SalesByCountryPiChart> {
  int touchedIndex = -1;
  final _mockList = const [
    PiChartData(color: Colors.blue, label: "USA: 60%", value: 60),
    PiChartData(color: Colors.green, label: "Germany: 40%", value: 40),
    PiChartData(color: Colors.red, label: "Spain: 30%", value: 30),
    PiChartData(color: Colors.yellow, label: "Bangladesh: 50%", value: 50),
  ];

  @override
  Widget build(BuildContext context) {
    final _mqSize = MediaQuery.sizeOf(context);
    final _theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final _size = constraints.biggest;

        final _chartRadius = responsiveValue<double>(
          context,
          xs: _size.height * 0.30,
          md: _size.height * 0.30,
          lg: _size.height * (_mqSize.width < 1600 ? 0.225 : 0.25),
        );

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 6,
              fit: FlexFit.loose,
              child: SizedBox.square(
                dimension: _chartRadius,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 0,
                    startDegreeOffset: -90,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, pieTouchResponse) {
                        final isInteractionValid =
                            event.isInterestedForInteractions &&
                                pieTouchResponse?.touchedSection != null;
                        final newIndex = isInteractionValid
                            ? pieTouchResponse!
                                .touchedSection!.touchedSectionIndex
                            : -1;

                        if (newIndex != touchedIndex) {
                          setState(() => touchedIndex = newIndex);
                        }
                      },
                    ),
                    sections: List.generate(
                      _mockList.length,
                      (index) {
                        final _data = _mockList[index];
                        return PieChartSectionData(
                          radius:
                              _chartRadius * (index == touchedIndex ? 1.05 : 1),
                          value: _data.value,
                          color: _data.color,
                          title: "${_data.value}%",
                          showTitle: index == touchedIndex,
                          titleStyle: _theme.textTheme.bodyLarge?.copyWith(
                            color: _theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: _chartRadius - 16),
            Flexible(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  _mockList.length,
                  (index) {
                    final _data = _mockList[index];
                    return Indicator(
                      color: _data.color,
                      text: _data.label,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            constraints: BoxConstraints.tight(const Size.square(12)),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: _theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class PiChartData {
  final Color color;
  final String label;
  final double value;

  const PiChartData({
    required this.color,
    required this.label,
    required this.value,
  });
}
