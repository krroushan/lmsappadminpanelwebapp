// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../widgets/widgets.dart';
import '../../models/models.dart';
import 'components/_components.dart' as comp;

class OpenAIDashboardView extends StatelessWidget {
  const OpenAIDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _mqSize = MediaQuery.sizeOf(context);
    final _showTablet = _mqSize.width >= 992 && _mqSize.width <= 1240;
    final lang = l.S.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.all(8),
        child: Column(
          children: [
            // Overview Tiles
            ResponsiveGridRow(
              children: List.generate(
                8,
                (index) {
                  final _item = _overviewItems[index];

                  return ResponsiveGridCol(
                    lg: 3,
                    md: 6,
                    xs: 12,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.all(8),
                      child: OverviewTileWidget(
                        imagePath: _item.iconPath,
                        value: _item.value,
                        title: _item.subtitle,
                        iconBackgroundColor: _item.iconColor,
                      ),
                    ),
                  );
                },
              ),
            ),

            //
            ResponsiveGridRow(
              children: [
                ResponsiveGridCol(
                  lg: 8,
                  md: _showTablet ? 8 : null,
                  child: Container(
                    padding: const EdgeInsetsDirectional.all(8),
                    constraints: BoxConstraints.tight(
                      Size.fromHeight(
                        responsiveValue<double>(
                          context,
                          xs: 255,
                          md: 350,
                          lg: 430,
                        ),
                      ),
                    ),
                    child: ShadowContainer(
                      // headerText: 'Word Generation',
                      headerText: lang.wordGeneration,
                      contentPadding: const EdgeInsetsDirectional.fromSTEB(
                        6,
                        12,
                        6,
                        6,
                      ),
                      trailing: const FilterDropdownButton(),
                      child: const NumericAxisChart(),
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  md: _showTablet ? 4 : null,
                  child: Container(
                    padding: const EdgeInsetsDirectional.all(8),
                    constraints: BoxConstraints.tight(
                      Size.fromHeight(
                        responsiveValue<double>(
                          context,
                          xs: 255,
                          md: 350,
                          lg: 430,
                        ),
                      ),
                    ),
                    child: ShadowContainer(
                      //headerText: 'Contents Overviews',
                      headerText: lang.contentsOverviews,
                      trailing: const FilterDropdownButton(),
                      child: const Align(child: ContentOverViewChart()),
                    ),
                  ),
                )
              ],
            ),

            // Fluctuation overview tile
            ResponsiveGridRow(
              rowSegments: 100,
              children: List.generate(
                _dashboardCalculationItem.length,
                (index) {
                  final _item = _dashboardCalculationItem[index];
                  return ResponsiveGridCol(
                    lg: 20,
                    md: 50,
                    xs: 100,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.all(8),
                      child: OverviewCardWidget(
                        title: _item.title,
                        value: _item.amount,
                        fluctuationAmount: _item.fluctuation,
                        cardColor: _item.tileColor,
                        hasIncreases: index != 2,
                        showCurrency: index > 1,
                        showCompactValue: index > 1,
                        showCompactFluctuation:
                            index + 1 == _dashboardCalculationItem.length,
                        fluctuationBgDecoration: const BoxDecoration(),
                        fluctuationBgPadding: EdgeInsets.zero,
                      ),
                    ),
                  );
                },
              ),
            ),

            //
            ResponsiveGridRow(
              children: [
                ResponsiveGridCol(
                  lg: 8,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tight(
                      Size.fromHeight(
                        responsiveValue<double>(
                          context,
                          xs: 255,
                          md: 350,
                          lg: 430,
                        ),
                      ),
                    ),
                    child: ShadowContainer(
                      margin: const EdgeInsetsDirectional.all(8),
                      //headerText: 'Latest Registered',
                      headerText:lang.latestRegistered,
                      contentPadding: EdgeInsetsDirectional.zero,
                      trailing: Text.rich(
                        TextSpan(
                          text: lang.viewAll,
                          children: [
                            WidgetSpan(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  start: 8,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: _theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                          mouseCursor: SystemMouseCursors.click,
                        ),
                        style: _theme.textTheme.bodyLarge?.copyWith(
                          color: _theme.colorScheme.primary,
                        ),
                      ),
                      child: const comp.LatestRegisteredUserTable(),
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  child: Container(
                    padding: const EdgeInsetsDirectional.all(8),
                    constraints: BoxConstraints.tight(
                      Size.fromHeight(
                        responsiveValue<double>(
                          context,
                          xs: 255,
                          md: 350,
                          lg: 430,
                        ),
                      ),
                    ),
                    child: ShadowContainer(
                      contentPadding: const EdgeInsetsDirectional.fromSTEB(
                        0,
                        12,
                        0,
                        0,
                      ),
                      // headerText: 'Subscribe Statistic',
                      headerText: lang.subscribeStatistic,
                      trailing: const FilterDropdownButton(),
                      child: const Align(
                        alignment: Alignment.bottomLeft,
                        child: SubscriptionStaticsChart(),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

List<_DashboardCalculationItemModel> get _dashboardCalculationItem =>
    <_DashboardCalculationItemModel>[
      ...[
        (
          l.S.current.totalUsers,
          5000,
          200,
          const Color(0xffB9FDEC),
        ),
        (
          l.S.current.totalIncome,
          3000,
          500,
          const Color(0xffC5FDBF),
        ),
        (
          l.S.current.totalSubscription,
          55000,
          15000,
          const Color(0xffC8E6FE),
        ),
        (
          l.S.current.totalExpense,
          20500,
          5000,
          const Color(0xffFFD6E2),
        ),
        (
          l.S.current.totalProfit,
          30500,
          20000,
          const Color(0xffDFDAFF),
        ),
      ].map(
        (item) => _DashboardCalculationItemModel(
          title: item.$1,
          amount: item.$2,
          fluctuation: item.$3,
          tileColor: item.$4,
        ),
      )
    ];

class _DashboardCalculationItemModel {
  final String title;
  final num amount;
  final num fluctuation;
  final String filterType;
  final Color tileColor;

  const _DashboardCalculationItemModel({
    required this.title,
    required this.amount,
    required this.fluctuation,
    this.filterType = 'This Month',
    this.tileColor = Colors.greenAccent,
  });
}

List<OverviewItem> get _overviewItems => <OverviewItem>[
      ...[
        (
          "assets/images/widget_images/dashboard_overview_icon/edit_icon.png",
          500,
          //"Generated Article",
          l.S.current.generatedArticle,
          const Color(0xffAD00FF)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/speech_to_text.png",
          500,
          //"Speech To Text ",
          l.S.current.speechToText,
          const Color(0xff00AD66)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/image_icon.png",
          500,
          //"Images Generated ",
          l.S.current.imagesGenerated,
          const Color(0xff4429FF)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/pdf_icon.png",
          500,
          //"PDF Generate ",
          l.S.current.PDFGenerate,
          const Color(0xffEE11E5)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/code_icon.png",
          500,
          //"Code Generated ",
          l.S.current.codeGenerated,
          const Color(0xffFE6921)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/voiceover_icon.png",
          500,
          //"Voiceover Generated ",
          l.S.current.voiceoverGenerated,
          const Color(0xff1570EF)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/document_icon.png",
          500,
          //"Document Generated",
          l.S.current.documentGenerated,
          const Color(0xff00AD66)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/credit_card_icon.png",
          500,
          //"Total Credit Balance",
          l.S.current.totalCreditBalance,
          const Color(0xff8106FB)
        ),
      ].map(
        (item) => OverviewItem(
          iconPath: item.$1,
          value: item.$2,
          subtitle: item.$3,
          iconColor: item.$4.withOpacity(0.15),
        ),
      )
    ];
