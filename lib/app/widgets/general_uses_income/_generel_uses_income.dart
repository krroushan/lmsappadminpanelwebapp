// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import 'package:acnoo_flutter_admin_panel/app/widgets/shadow_container/_shadow_container.dart';
import '../../../generated/l10n.dart' as l;
import '../../core/static/static.dart';
import '../../core/theme/theme.dart';
import '_gauge_chart.dart';

class GeneralUsagesIncome extends StatefulWidget {
  const GeneralUsagesIncome({super.key});

  @override
  State<GeneralUsagesIncome> createState() => _GeneralUsagesIncomeState();
}

class _GeneralUsagesIncomeState extends State<GeneralUsagesIncome> {
  Map<int, double> valueList = {
    0: 26,
    1: 38,
    2: 79,
    3: 38,
    4: 51,
    5: 77,
    6: 52,
  };
  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final titleSize = responsiveValue<double>(
      context,
      xs: 18,
      md: 20,
      lg: 20,
    );
    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );
    // ignore: unused_local_variable
    final boxSize = rf.ResponsiveValue<double?>(context,
        defaultValue: 0,
        conditionalValues: [
          rf.Condition.largerThan(name: BreakpointName.XS.name, value: 24)
        ]).value;
    final theme = Theme.of(context);
    return ShadowContainer(
      contentPadding: EdgeInsets.all(_padding),
      customHeader: Padding(
        padding: EdgeInsets.fromLTRB(_padding, _padding, _padding, 0),
        child: Text(
          lang.Statistic,
          //'Statistic',
          style: theme.textTheme.titleLarge?.copyWith(fontSize: titleSize),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListTile(
            horizontalTitleGap: 0,
            contentPadding: EdgeInsets.symmetric(vertical: _padding),
            title: Text(
              lang.dailyUses,
              //'Daily Uses',
              style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w400,
                  overflow: TextOverflow.ellipsis,
                  color: theme.colorScheme.onTertiary),
            ),
            subtitle: Text(
              '60%',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: titleSize,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: const GaugeChart(),
          ),
          ListTile(
            horizontalTitleGap: 0,
            contentPadding: EdgeInsets.symmetric(vertical: _padding),
            title: Text(
              lang.todayIncome,
              //'Today Income',
              style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w400,
                  overflow: TextOverflow.ellipsis,
                  color: theme.colorScheme.onTertiary),
            ),
            subtitle: Text(
              '\$5.5k',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: titleSize,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: Wrap(
              spacing: 10,
              verticalDirection: VerticalDirection.up,
              children: valueList.entries.map(
                (entry) {
                  Color containerColor = entry.value > 70
                      ? AcnooAppColors.kPrimary600
                      : AcnooAppColors.kNeutral200;
                  return Container(
                    width: 12, // Fixed width for the container
                    height: entry.value, // Variable height based on valueList
                    decoration: BoxDecoration(
                      gradient: entry.value > 70
                          ? const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFC38FFF),
                                Color(0xFF7500FD),
                              ],
                            )
                          : const LinearGradient(
                              colors: [
                                AcnooAppColors.kNeutral200,
                                AcnooAppColors.kNeutral200,
                              ],
                            ),
                      color: containerColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
