// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import '../../../../../../generated/l10n.dart' as l;
// 📦 Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:responsive_grid/responsive_grid.dart';

class EmployeeAttendancePiChart extends StatefulWidget {
  const EmployeeAttendancePiChart({super.key});

  @override
  State<EmployeeAttendancePiChart> createState() =>
      _EmployeeAttendancePiChartState();
}

class _EmployeeAttendancePiChartState extends State<EmployeeAttendancePiChart> {
  int touchedIndex = -1;
  List<PiChartData> get _mockList => [
        // PiChartData(color: Color(0xff7500FD), label: "Total Staff: 20", value: 60),
        // PiChartData(color: Color(0xff04C173), label: "Present: 18", value: 40),
        // PiChartData(color: Color(0xffE40F0F), label: "Absent: 2", value: 30),
        // PiChartData(color: Color(0xffFD7F0B), label: "Late User: 3", value: 50),

        PiChartData(
            color: const Color(0xff7500FD),
            label: "${l.S.current.totalStaff}: 20",
            value: 60),
        PiChartData(
            color: const Color(0xff04C173),
            label: "${l.S.current.present}: 18",
            value: 40),
        PiChartData(
            color: const Color(0xffE40F0F),
            label: "${l.S.current.absent}: 2",
            value: 30),
        PiChartData(
            color: const Color(0xffFD7F0B),
            label: "${l.S.current.lateUser}: 3",
            value: 50),
      ];

  @override
  Widget build(BuildContext context) {
    final _mqSize = MediaQuery.sizeOf(context);
    final _theme = Theme.of(context);
    //  final _lang = l.S.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final _size = constraints.biggest;

        final _chartRadius = responsiveValue<double>(
          context,
          xs: _size.height * (_mqSize.width < 420 ? 0.225 : 0.275),
          md: _size.height * 0.30,
          lg: _size.height * 0.35,
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
                    centerSpaceRadius: _chartRadius / 2,
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
                          radius: (_chartRadius / 2) *
                              (index == touchedIndex ? 1.25 : 1),
                          value: _data.value,
                          color: _data.color,
                          title: "${_data.value}",
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
