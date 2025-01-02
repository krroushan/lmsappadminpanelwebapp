// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../core/static/static.dart';

class PieDataIndicator extends StatelessWidget {
  const PieDataIndicator({
    super.key,
    required this.color,
    required this.text,
  });
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final fontSize = rf.ResponsiveValue<double?>(context, conditionalValues: [
      rf.Condition.smallerThan(name: BreakpointName.SM.name, value: 14)
    ]).value;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: textTheme.titleLarge
              ?.copyWith(fontSize: fontSize, fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}
