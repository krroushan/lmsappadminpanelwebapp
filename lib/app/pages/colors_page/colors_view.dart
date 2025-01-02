// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../widgets/widgets.dart';
import 'component/component.dart';

part 'data/_colors_mock_data.dart';

class ColorsView extends StatelessWidget {
  const ColorsView({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 480,
          value: _SizeInfo(
            groupNameFontSize: 16,
            padding: EdgeInsetsDirectional.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 481,
          end: 576,
          value: _SizeInfo(
            groupNameFontSize: 20,
            padding: EdgeInsetsDirectional.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 577,
          end: 992,
          value: _SizeInfo(
            groupNameFontSize: 24,
            padding: EdgeInsetsDirectional.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;
    return Padding(
      padding: _sizeInfo.padding,
      child: ShadowContainer(
        //headerText: 'Colors Options',
        headerText: lang.colorsOptions,
        child: ListView(
          shrinkWrap: true,
          addAutomaticKeepAlives: false,
          children: [
            ..._colorMockData.map(
              (colorGroup) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    colorGroup.groupName,
                    style: _theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: _sizeInfo.groupNameFontSize,
                    ),
                  ),
                  SizedBox(height: _sizeInfo.innerSpacing / 1.5),
                  Flexible(
                    child: Wrap(
                      spacing: _sizeInfo.innerSpacing,
                      runSpacing: _sizeInfo.innerSpacing,
                      children: [
                        ...colorGroup.colors.map(
                          (colorTile) => AcnooColorTile(
                            colorName: colorTile.name,
                            color: colorTile.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: _sizeInfo.innerSpacing * 1.5),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SizeInfo {
  final double? groupNameFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  const _SizeInfo({
    this.groupNameFontSize = 26,
    this.padding = const EdgeInsetsDirectional.all(24),
    this.innerSpacing = 24,
  });
}
