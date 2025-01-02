// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../widgets/widgets.dart';

class ChartWidgetsView extends StatelessWidget {
  const ChartWidgetsView({super.key});

  @override
  Widget build(BuildContext context) {
    final _gridConfig = rf.ResponsiveValue<_GridConfig>(
      context,
      conditionalValues: const [
        rf.Condition.between(
          start: 0,
          end: 675,
          value: _GridConfig(
            maxCrossAxisExtent: 675,
            childAspectRatio: 360 / 253,
            padding: EdgeInsets.all(16),
          ),
        ),
        rf.Condition.between(
          start: 676,
          end: 992,
          value: _GridConfig(
            maxCrossAxisExtent: 992,
            childAspectRatio: 712 / 364,
            padding: EdgeInsets.all(16),
          ),
        ),
      ],
      defaultValue: const _GridConfig(
        maxCrossAxisExtent: 774,
        childAspectRatio: 774 / 410,
      ),
    ).value;
    return Scaffold(
      body: GridView.extent(
        padding: _gridConfig.padding,
        maxCrossAxisExtent: _gridConfig.maxCrossAxisExtent,
        childAspectRatio: _gridConfig.childAspectRatio,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        scrollDirection: Axis.vertical,
        children: [
          ...List.generate(
            6,
            (index) => chartWidgetList[index],
          ),
        ],
      ),
    );
  }
}

class _GridConfig {
  final double maxCrossAxisExtent;
  final double childAspectRatio;
  final EdgeInsetsGeometry padding;

  const _GridConfig({
    required this.maxCrossAxisExtent,
    required this.childAspectRatio,
    this.padding = const EdgeInsets.all(24),
  });
}

List<Widget> chartWidgetList = const [
  DefaultLineChart(),
  MultipleLineChart(),
  AreaChart(),
  TransparentChart(),
  MinguuanChart(),
  PieChartWidget()
];
