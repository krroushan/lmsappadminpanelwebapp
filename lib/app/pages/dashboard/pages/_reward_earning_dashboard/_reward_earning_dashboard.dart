// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../widgets/widgets.dart';
import 'components/_components.dart' as comp;

class RewardEarningAdminDashboard extends StatelessWidget {
  const RewardEarningAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;

    final _mqSize = MediaQuery.sizeOf(context);
    final _lang = l.S.of(context);

    final _padding = responsiveValue<double>(context, xs: 16, lg: 24);

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(_padding / 2.5),
        child: Column(
          children: [
            // Overview Tiles
            ResponsiveGridRow(
              rowSegments: 100,
              children: List.generate(
                _overviewCardData.length,
                (index) {
                  final _data = _overviewCardData[index];
                  return ResponsiveGridCol(
                    lg: 20,
                    md: _mqSize.width < 992 ? 50 : 25,
                    xs: 100,
                    child: Padding(
                      padding: EdgeInsetsDirectional.all(_padding / 2.5),
                      child: OverviewTileWidget(
                        value: _data.$1,
                        valueStyle: _theme.textTheme.titleLarge?.copyWith(
                          color: _isDark ? Colors.white : null,
                        ),
                        title: _data.$2,
                        titleStyle: _theme.textTheme.bodyLarge?.copyWith(
                          color: _isDark ? Colors.white : null,
                        ),
                        tileColor: _data.$4.withOpacity(_isDark ? 0.2 : 1),
                        iconRadius: BorderRadius.circular(60),
                        iconBackgroundColor: _data.$3,
                        imagePath: _data.$5,
                      ),
                    ),
                  );
                },
              ),
            ),

            // SMS History Statistics & SMS Report
            ResponsiveGridRow(
              children: [
                ResponsiveGridCol(
                  lg: 8,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(height: 435),
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      //headerText: 'SMS History Statistics',
                      headerText: _lang.sMSHistoryStatistics,
                      trailing: const FilterDropdownButton(),
                      child: const comp.SMSHistoryStatisticsLineChart(),
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

            // Top Users & Latest Quiz
            ResponsiveGridRow(
              children: [
                ResponsiveGridCol(
                  lg: 8,
                  child: ShadowContainer(
                    margin: EdgeInsetsDirectional.all(_padding / 2.5),
                    contentPadding: EdgeInsetsDirectional.zero,
                    //headerText: 'Top Users',
                    headerText: _lang.topUsers,
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
                    child: const comp.TopUsersTable(),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  child: ShadowContainer(
                    margin: EdgeInsetsDirectional.all(_padding / 2.5),
                    contentPadding: EdgeInsetsDirectional.zero,
                    // headerText: 'Latest Quiz',
                    headerText: _lang.latestQuiz,
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
                    child: const comp.LatestQuizTable(),
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

List<(int, String, Color, Color, String)> get _overviewCardData => [
      (
        5,
        // "Total quiz category",
        l.S.current.totalQuizCategory,
        const Color(0xff851EEC),
        const Color(0xffEDD9FF),
        "assets/images/widget_images/dashboard_overview_icon/total_quiz_category.svg",
      ),
      (
        30,
        //"Total Quizzes",
        l.S.current.totalQuizzes,
        const Color(0xffFF6921),
        const Color(0xffFFE5D9),
        "assets/images/widget_images/dashboard_overview_icon/total_quizzes.svg",
      ),
      (
        15,
        // "Total Questions",
        l.S.current.totalQuestions,
        const Color(0xff00AD66),
        const Color(0xffCBFFEB),
        "assets/images/widget_images/dashboard_overview_icon/total_questions.svg",
      ),
      (
        170,
        // "Total Withdraw",
        l.S.current.totalWithdraw,
        const Color(0xff1570EF),
        const Color(0xffDDECFF),
        "assets/images/widget_images/dashboard_overview_icon/total_withdraw.svg",
      ),
      (
        350,
        //"Pending Withdraw",
        l.S.current.pendingWithdraw,
        const Color(0xffEE11E5),
        const Color(0xffFFD7FD),
        "assets/images/widget_images/dashboard_overview_icon/pending_withdraw.svg",
      ),
      (
        870,
        //"Approved Withdraw",
        l.S.current.approvedWithdraw,
        const Color(0xff0469F6),
        const Color(0xffDDECFF),
        "assets/images/widget_images/dashboard_overview_icon/approved_withdraw.svg",
      ),
      (
        500,
        //"Rejected Withdraw",
        l.S.current.rejectedWithdraw,
        const Color(0xffF500EC),
        const Color(0xffFFD7FD),
        "assets/images/widget_images/dashboard_overview_icon/rejected_withdraw.svg",
      ),
      (
        500,
        // "Total User",
        l.S.current.totalUser,
        const Color(0xff7B17DE),
        const Color(0xffEDD9FF),
        "assets/images/widget_images/dashboard_overview_icon/total_user.svg",
      ),
      (
        20,
        // "Total Currency",
        l.S.current.totalCurrency,
        const Color(0xffFF6921),
        const Color(0xffFFE5D9),
        "assets/images/widget_images/dashboard_overview_icon/total_currency.svg",
      ),
      (
        200,
        //"Total Rewards",
        l.S.current.totalRewards,
        const Color(0xff009F5E),
        const Color(0xffCBFFEB),
        "assets/images/widget_images/dashboard_overview_icon/total_rewards.svg",
      ),
    ];
