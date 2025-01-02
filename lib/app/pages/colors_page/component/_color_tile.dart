// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;

class AcnooColorTile extends StatelessWidget {
  const AcnooColorTile({
    super.key,
    required this.colorName,
    required this.color,
  });

  final String colorName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 480,
          value: _SizeInfo(
            innerPadding: 5,
            minWidth: 172 * 0.50,
            fontSize: 12,
            maxWidthFactor: 0.55,
          ),
        ),
        const rf.Condition.between(
          start: 481,
          end: 576,
          value: _SizeInfo(
            innerPadding: 6,
            minWidth: 172 * 0.70,
            fontSize: 14,
            maxWidthFactor: 0.60,
          ),
        ),
        const rf.Condition.between(
          start: 577,
          end: 992,
          value: _SizeInfo(
            innerPadding: 8,
            maxWidthFactor: 0.70,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;
    return Container(
      padding: EdgeInsets.fromLTRB(
        _sizeInfo.innerPadding,
        _sizeInfo.innerPadding,
        _sizeInfo.innerPadding * 2,
        _sizeInfo.innerPadding,
      ),
      constraints: BoxConstraints(
        minWidth: _sizeInfo.minWidth,
        maxWidth: double.maxFinite,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: _theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: BoxConstraints(
              minWidth: 75 * _sizeInfo.maxWidthFactor,
              minHeight: 57 * (_sizeInfo.maxWidthFactor - 0.02),
            ),
            decoration: BoxDecoration(
              color: color,
              border: color != Colors.white
                  ? null
                  : Border.all(color: _theme.colorScheme.outline),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: _sizeInfo.minWidth * 0.075),
          Flexible(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  colorName,
                  style: _theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: _sizeInfo.fontSize,
                  ),
                ),
                Text(
                  "#${color.value.toRadixString(16).substring(2)}"
                      .toUpperCase(),
                  style: _theme.textTheme.bodyLarge?.copyWith(
                    fontSize: _sizeInfo.fontSize - 2,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _SizeInfo {
  final double innerPadding;
  final double minWidth;
  final double fontSize;

  final double maxWidthFactor;
  const _SizeInfo({
    this.innerPadding = 8,
    this.minWidth = 172,
    this.fontSize = 16,
    this.maxWidthFactor = 1,
  });
}
