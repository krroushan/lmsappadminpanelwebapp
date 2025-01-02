// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../widgets/widgets.dart';
import '../../models/models.dart';
import 'components/_components.dart' as comp;

class InfluencerAdminDashboard extends StatelessWidget {
  const InfluencerAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _lang = l.S.of(context);
    final _mqSize = MediaQuery.sizeOf(context);

    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      lg: 24,
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(_padding / 2.5),
        child: Column(
          children: [
            // Overview Tiles
            ResponsiveGridRow(
              children: List.generate(
                _overviewItems.length,
                (index) {
                  final _item = _overviewItems[index];

                  return ResponsiveGridCol(
                    lg: _mqSize.width < 1600 ? 3 : 2,
                    md: _mqSize.width < 768 ? 6 : 4,
                    xs: _mqSize.width < 480 ? 12 : 6,
                    child: Padding(
                      padding: EdgeInsetsDirectional.all(_padding / 2.5),
                      child: OverviewTileWidget(
                        imagePath: _item.iconPath,
                        value: _item.value,
                        title: _item.subtitle,
                        iconBackgroundColor: _item.iconColor,
                        showCurrency: index >= _overviewItems.length - 2,
                        iconAlignment: IconAlignment.end,
                        tileDecoration: BoxDecoration(
                          border: Border.all(
                            color: _theme.colorScheme.outline,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            width: 1.375,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Recent Registered Client & Income Report
            ResponsiveGridRow(
              children: [
                ResponsiveGridCol(
                  lg: 7,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(height: 400),
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      contentPadding: EdgeInsetsDirectional.zero,
                     // headerText: 'Recent Registered Client',
                      headerText: _lang.recentRegisteredClient,
                      trailing: Text.rich(
                        TextSpan(
                          //text: 'View All',
                          text: _lang.viewAll,
                          style: TextStyle(
                            color: _theme.colorScheme.primary,
                          ),
                          mouseCursor: SystemMouseCursors.click,
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Container(
                                margin:
                                    const EdgeInsetsDirectional.only(start: 6),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: _theme.colorScheme.primary,
                                  size: 16,
                                ),
                              ),
                            )
                          ],
                        ),
                        style: _theme.textTheme.bodyMedium,
                      ),
                      child: const comp.RecentRegisteredClientTable(),
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 5,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(height: 400),
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      //headerText: 'Income Report',
                      headerText: _lang.incomeReport,
                      trailing: const FilterDropdownButton(),
                      child: const comp.IncomeReportLineChart(),
                    ),
                  ),
                ),
              ],
            ),

            // Recent Registered Influencer Withdraw Report
            ResponsiveGridRow(
              children: [
                ResponsiveGridCol(
                  lg: 7,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(height: 400),
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      contentPadding: EdgeInsetsDirectional.zero,
                      //headerText: 'Recent Registered Influencer',
                      headerText: _lang.recentRegisteredInfluencer,
                      trailing: Text.rich(
                        TextSpan(
                          //text: 'View All',
                          text: _lang.viewAll,
                          style: TextStyle(
                            color: _theme.colorScheme.primary,
                          ),
                          mouseCursor: SystemMouseCursors.click,
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Container(
                                margin:
                                    const EdgeInsetsDirectional.only(start: 6),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: _theme.colorScheme.primary,
                                  size: 16,
                                ),
                              ),
                            )
                          ],
                        ),
                        style: _theme.textTheme.bodyMedium,
                      ),
                      child: const comp.RecentRegisteredClientTable(),
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 5,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(height: 400),
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      //headerText: 'Withdraw Report',
                      headerText: _lang.withdrawReport,
                      trailing: const FilterDropdownButton(),
                      child: const comp.WithdrawReportChart(),
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

List<OverviewItem> get _overviewItems {
  return <OverviewItem>[
    ...[
      (
        "assets/images/widget_images/dashboard_overview_icon/influencer_admin_icons/total_user.svg",
        500,
        //"Total  User",
        l.S.current.totalUser,
        const Color(0xff4876FF)
      ),
      (
        "assets/images/widget_images/dashboard_overview_icon/influencer_admin_icons/total_client.svg",
        300,
        //"Total Clients",
      l.S.current.totalClients,
        const Color(0xff16A34A)
      ),
      (
        "assets/images/widget_images/dashboard_overview_icon/influencer_admin_icons/active_client.svg",
        250,
       // "Active Clients",
      l.S.current.activeClients,
        const Color(0xff7030F6)
      ),
      (
        "assets/images/widget_images/dashboard_overview_icon/influencer_admin_icons/total_influencer.svg",
        180,
        //"Total Influencer ",
      l.S.current.totalInfluencer,
        const Color(0xffFB48FF)
      ),
      (
        "assets/images/widget_images/dashboard_overview_icon/influencer_admin_icons/active_influencer.svg",
        120,
        //"Active Influencer ",
      l.S.current.activeInfluencer,
        const Color(0xffFF8A48)
      ),
      (
        "assets/images/widget_images/dashboard_overview_icon/influencer_admin_icons/total_service.svg",
        80,
        //"Total Services",
      l.S.current.totalServices,
        const Color(0xff00C9BD)
      ),
      (
        "assets/images/widget_images/dashboard_overview_icon/influencer_admin_icons/total_income.svg",
        700,
        //"Total Income",
      l.S.current.totalIncome,
        const Color(0xff16A34A)
      ),
      (
        "assets/images/widget_images/dashboard_overview_icon/influencer_admin_icons/total_expense.svg",
        600,
        //"Total Expense",
      l.S.current.totalExpense,
        const Color(0xffFB1818)
      ),
    ].map(
      (item) => OverviewItem(
        iconPath: item.$1,
        value: item.$2,
        subtitle: item.$3,
        iconColor: item.$4,
      ),
    )
  ];
}
