// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../../../../generated/l10n.dart' as l;

class SMSReportChart extends StatefulWidget {
  const SMSReportChart({super.key});

  @override
  State<SMSReportChart> createState() => _SMSReportChartState();
}

class _SMSReportChartState extends State<SMSReportChart> {
  int touchedIndex = -1;
  List<PiChartData> get _mockList => [
        PiChartData(
          color: Colors.red,
          label: "${l.S.current.SMSDeliveried}: ",
          value: 300,
        ),
        PiChartData(
          color: Colors.green,
          label: "${l.S.current.SMSFailed}: ",
          value: 200,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final _mqSize = MediaQuery.sizeOf(context);

    final _chartRadius = responsiveValue<double>(
      context,
      xs: _mqSize.width < 480 ? 80 : 120,
      lg: _mqSize.width < 1400
          ? 100
          : _mqSize.width < 1600
              ? 135
              : 130,
    );

    final _innerSpace = responsiveValue<double>(
      context,
      xs: _mqSize.width < 480 ? 24 : 30,
      lg: _mqSize.width < 1400 ? 30 : 34,
    );

    final _content = [
      ConstrainedBox(
        constraints: BoxConstraints.tight(Size.square(_chartRadius)),
        child: _buildProgressIndicator(
          context,
          value: 0.65,
          color: Colors.green,
          backgroundColor: Colors.red,
          strokeWidth: _innerSpace,
        ),
      ),
      Flexible(
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _mockList.length,
              (index) {
                final _data = _mockList[index];
                return Indicator(
                  color: _data.color,
                  text: "${_data.label} ${_data.value}",
                );
              },
            ),
          ),
        ),
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _content,
    );
  }

  Widget _buildProgressIndicator(
    BuildContext context, {
    double value = 1,
    Color? color,
    Color? backgroundColor,
    double strokeWidth = 12,
  }) {
    return Transform.rotate(
      angle: 75 * (3.1416 / 180),
      child: CircularProgressIndicator(
        value: value,
        color: color,
        backgroundColor: backgroundColor,
        strokeCap: StrokeCap.round,
        strokeWidth: strokeWidth,
      ),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
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
