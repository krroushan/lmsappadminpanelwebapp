// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:magicoon_icons/MagicoonIcons_icons.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/theme/theme.dart';
import '../../../../widgets/widgets.dart';
import 'components/_components.dart' as comp;

class SMSAdminDashboard extends StatelessWidget {
  const SMSAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final _lang = l.S.of(context);

    final _padding = responsiveValue<double>(context, xs: 16, lg: 24);
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(_padding / 2.5),
        child: Column(
          children: [
            // Overview Tiles
            ResponsiveGridRow(
              children: List.generate(
                _overviewCard.length,
                (index) {
                  final _overview = _overviewCard[index];
                  return ResponsiveGridCol(
                    lg: 3,
                    md: 6,
                    child: Padding(
                      padding: EdgeInsetsDirectional.all(_padding / 2.5),
                      child: OverviewCardWidget2(
                        containerColor: _overview.$4.withOpacity(0.25),
                        containerIcon: Icon(
                          _overview.$5,
                          color: _overview.$4,
                        ),
                        title: _overview.$1.toString(),
                        subTitle: _overview.$2,
                        text: _overview.$3,
                        bottomIcon: index == 2
                            ? null
                            : Icon(
                                index == 0
                                    ? Icons.arrow_downward_outlined
                                    : Icons.arrow_upward_outlined,
                                color: index == 0
                                    ? AcnooAppColors.kError
                                    : AcnooAppColors.kSuccess,
                                size: 16,
                              ),
                        progressColor: _overview.$4,
                        progressBackgroundColor: _overview.$4.withOpacity(0.25),
                        percentValue: 0.20 * (index + 1),
                      ),
                    ),
                  );
                },
              ),
            ),

            // SMS History Statistics & SMS Reports
            ResponsiveGridRow(
              children: [
                ResponsiveGridCol(
                  lg: 8,
                  child: ConstrainedBox(
                    constraints:  const BoxConstraints.tightFor(height: 440),
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      contentPadding: const EdgeInsetsDirectional.fromSTEB(
                        16,
                        28,
                        16,
                        20,
                      ),
                      //headerText: 'SMS History Statistics',
                      headerText: _lang.sMSHistoryStatistics,
                      trailing: const FilterDropdownButton(),
                      child: const comp.SMSHistoryStatisticsChart(),
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      height: responsiveValue<double?>(
                        context,
                        xs: 280,
                        md: 350,
                        lg: 435,
                      ),
                    ),
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      contentPadding: const EdgeInsetsDirectional.all(24),
                      // headerText: 'SMS Report',
                      headerText: _lang.sMSReport,
                      child: const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: comp.SMSReportChart(),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Customers Growth & Revenue
            ResponsiveGridRow(
              children: [
                ResponsiveGridCol(
                  lg: 8,
                  child: ConstrainedBox(
                    constraints:  const BoxConstraints.tightFor(height: 440),
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      contentPadding: const EdgeInsetsDirectional.fromSTEB(
                        16,
                        28,
                        16,
                        20,
                      ),
                      //headerText: 'Customers Growth',
                      headerText: _lang.customersGrowth,
                      trailing: const FilterDropdownButton(),
                      child: const NumericAxisChart(),
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      height: responsiveValue<double?>(
                        context,
                        xs: 280,
                        md: 350,
                        lg: 435,
                      ),
                    ),
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      contentPadding: const EdgeInsetsDirectional.fromSTEB(
                        16,
                        28,
                        16,
                        20,
                      ),
                     // headerText: 'Revenue',
                      headerText: _lang.revenue,
                      child: const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: comp.RevenueChart(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

List<(num, String, String, Color, IconData)> get _overviewCard {
  return [
    (
      20,
      //"Total Customers",
      l.S.current.totalCustomers,
      //"18 This Month Customers",
    l.S.current.thisMonthCustomers,
      const Color(0xff009F5E),
      MagicoonIcons.users_group1,
    ),
    (
      10000,
      //"This Month SMS",
    l.S.current.thisMonthSMS,
      //"12 Today Send SMS",
    l.S.current.todaySendSMS,
      const Color(0xff8B4DFF),
      MagicoonIcons.messages,
    ),
    (
      20,
      //"Total Plan",
    l.S.current.totalPlan,
      //"Basic, Standard, Enterprise",
    l.S.current.basicStandardEnterprise,
      const Color(0xff8B4DFF),
      MagicoonIcons.award_star2,
    ),
    (
      8000,
     // "Total Income",
    l.S.current.totalIncome,
      //"\$10,000 This Month Income",
    l.S.current.thisMonthIncome,
      const Color(0xffE13F3D),
      MagicoonIcons.money_bills,
    ),
  ];
}
