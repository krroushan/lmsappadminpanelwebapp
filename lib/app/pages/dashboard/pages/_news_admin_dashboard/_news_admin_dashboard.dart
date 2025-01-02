// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../../../generated/l10n.dart' as l;
import '../../../../widgets/widgets.dart';
import 'components/_components.dart' as comp;

class NewsAdminDashboard extends StatelessWidget {
  const NewsAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final _mqSize = MediaQuery.sizeOf(context);
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    final _padding = responsiveValue<double>(context, xs: 16, lg: 24);

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(_padding / 2.5),
        child: Column(
          children: [
            // Overview Cards
            ResponsiveGridRow(
              children: List.generate(
                _overviewData.length,
                (index) {
                  final _data = _overviewData[index];

                  return ResponsiveGridCol(
                    lg: _mqSize.width < 1400 ? 4 : 2,
                    md: _mqSize.width < 768 ? 6 : 4,
                    xs: _mqSize.width < 420 ? 12 : 6,
                    child: Container(
                      margin: EdgeInsetsDirectional.all(_padding / 2),
                      constraints: const BoxConstraints.tightFor(height: 200),
                      child: comp.BorderOverviewCard(
                        iconPath: _data.$4,
                        title: Text(
                          _data.$1,
                          style: _theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          _data.$2,
                          style: _theme.textTheme.bodyMedium?.copyWith(),
                        ),
                        iconBackgroundColor: _data.$3,
                        border: Border(
                          top: BorderSide(
                            color: _data.$3,
                            width: 6,
                          ),
                        ),
                        cardType: comp.BorderOverviewCardType.vertical,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Other Overview Cards & User Statistic
            ResponsiveGridRow(
              children: [
                // Overview Cards
                ResponsiveGridCol(
                  lg: _mqSize.width < 1400 ? 4 : 3,
                  md: _mqSize.width < 992 ? 12 : 4,
                  child: ResponsiveGridRow(
                    children: List.generate(
                      _moreOverviewData.length,
                      (index) {
                        final _data = _moreOverviewData[index];
                        return ResponsiveGridCol(
                          lg: 12,
                          md: _mqSize.width < 992 ? 6 : 12,
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                              top: _mqSize.width < 992
                                  ? (_padding / 2.5)
                                  : (index == 0 ? _padding / 2.5 : 0),
                              bottom: 12,
                              start: _mqSize.width < 992 ? 6 : _padding / 2.5,
                              end: _mqSize.width < 992 ? 6 : _padding / 2.5,
                            ),
                            child: comp.BorderOverviewCard(
                              iconPath: _data.$4,
                              title: Text(
                                _data.$1.toString(),
                                style: _theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                _data.$2,
                                style: _theme.textTheme.bodyMedium?.copyWith(),
                              ),
                              iconBackgroundColor: _data.$3,
                              border: Border(
                                left: BorderSide(color: _data.$3, width: 6),
                              ),
                              cardType: comp.BorderOverviewCardType.horizontal,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // User Statistic Chart
                ResponsiveGridCol(
                  lg: _mqSize.width < 1400 ? 8 : 9,
                  md: _mqSize.width < 992 ? 12 : 8,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(height: 410),
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      //headerText: 'User Statistic',
                      headerText: lang.userStatistic,
                      trailing: const FilterDropdownButton(),
                      child: const comp.UserStatisticChart(),
                    ),
                  ),
                ),
              ],
            ),

            // Category Wise News, Most Viewed News, Latest Comments
            ResponsiveGridRow(
              children: [
                ResponsiveGridCol(
                  lg: _mqSize.width < 1400 ? 6 : 4,
                  md: _mqSize.width < 768 ? 12 : 6,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(
                      height: 430,
                    ),
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                     // headerText: 'Category Wise News',
                      headerText: lang.categoryWiseNews,
                      child: Align(
                        alignment: AlignmentDirectional.center,
                        child: CustomPiChart(
                          chartData: _piChartData,
                        ),
                      ),
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: _mqSize.width < 1400 ? 6 : 4,
                  md: _mqSize.width < 768 ? 12 : 6,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(
                      height: 430,
                    ),
                    child: ShadowContainer(
                     // headerText: 'Most Viewed News',
                      headerText: lang.mostViewedNews,
                      contentPadding: EdgeInsetsDirectional.zero,
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      child: ListView.builder(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          20,
                          18,
                          18,
                          0,
                        ),
                        itemCount: _newsList.length * 2,
                        itemBuilder: (context, index) {
                          final _item = [
                            ..._newsList,
                            ..._newsList.reversed,
                          ][index];

                          return Padding(
                            padding: const EdgeInsetsDirectional.only(
                              bottom: 12,
                            ),
                            child: comp.HorizontalNewsCard(data: _item),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: _mqSize.width < 1400 ? 12 : 4,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(
                      height: 430,
                    ),
                    child: ShadowContainer(
                     /// headerText: 'Latest Comments',
                      headerText:lang.latestComments,
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      contentPadding: EdgeInsetsDirectional.zero,
                      child: ListView.builder(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          20,
                          0,
                          18,
                          0,
                        ),
                        itemCount: _latestComments.length * 2,
                        itemBuilder: (context, index) {
                          final _item = [
                            ..._latestComments,
                            ..._latestComments.reversed,
                          ][index];

                          return Container(
                            padding: const EdgeInsetsDirectional.symmetric(
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              border: BorderDirectional(
                                bottom: BorderSide(
                                  color: _theme.colorScheme.outline,
                                ),
                              ),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsetsDirectional.zero,
                              visualDensity: const VisualDensity(vertical: -4),
                              leading: AvatarWidget(
                                imagePath: _item.$1,
                                avatarShape: AvatarShape.roundedRectangle,
                                size: const Size.square(40),
                                fit: BoxFit.cover,
                                radius: BorderRadius.circular(4),
                              ),
                              title: Text(_item.$2),
                              titleTextStyle: _theme.textTheme.bodyLarge,
                              subtitle: Text(_item.$3),
                              subtitleTextStyle:
                                  _theme.textTheme.bodyMedium?.copyWith(
                                color: _theme.colorScheme.onTertiaryContainer,
                              ),
                              trailing: Text(_item.$4),
                              leadingAndTrailingTextStyle:
                                  _theme.textTheme.bodySmall?.copyWith(
                                color: _theme.colorScheme.onTertiaryContainer,
                              ),
                            ),
                          );
                        },
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

List<(String, String, Color, String)> get _overviewData {
  return [
    (
      "950",
      l.S.current.newsReaders,
      //"News Readers",
      const Color(0xff1D4ED8),
      "assets/images/widget_images/dashboard_overview_icon/news_admin_icons/news_readers.svg",
    ),
    (
      "9+",
      l.S.current.category,
      //"Category",
      const Color(0xff7E00EC),
      "assets/images/widget_images/dashboard_overview_icon/news_admin_icons/category.svg",
    ),
    (
      "40+",
      l.S.current.language,
      //"Language",
      const Color(0xffFF5857),
      "assets/images/widget_images/dashboard_overview_icon/news_admin_icons/language.svg",
    ),
    (
      "8+",
      l.S.current.featuredSection,
      //"Featured Section",
      const Color(0xff067CFF),
      "assets/images/widget_images/dashboard_overview_icon/news_admin_icons/featured_section.svg",
    ),
    (
      "4",
      l.S.current.adSpaces,
      //"Ad Spaces",
      const Color(0xff07B495),
      "assets/images/widget_images/dashboard_overview_icon/news_admin_icons/ad_spaces.svg",
    ),
    (
      "950",
      l.S.current.breakingNews,
      //"Breaking News",
      const Color(0xff1D4ED8),
      "assets/images/widget_images/dashboard_overview_icon/news_admin_icons/breaking_news.svg",
    ),
  ];
}

List<(num, String, Color, String)> get _moreOverviewData {
  return [
    (
      300,
        l.S.current.publishedNews,
     // "Published News",
      const Color(0xff03BB9A),
      "assets/images/widget_images/dashboard_overview_icon/news_admin_icons/published_news.svg",
    ),
    (
      30,
      l.S.current.draftNews,
      //"Draft News",
      const Color(0xff8004ED),
      "assets/images/widget_images/dashboard_overview_icon/news_admin_icons/draft_news.svg",
    ),
    (
      15,
      l.S.current.breakingNews,
      //"Breaking News",
      const Color(0xffFF5A58),
      "assets/images/widget_images/dashboard_overview_icon/news_admin_icons/breaking_news1.svg",
    ),
    (
      40,
      l.S.current.totalBlogs,
      //"Total Blogs",
      const Color(0xffFF8C08),
      "assets/images/widget_images/dashboard_overview_icon/news_admin_icons/total_blogs.svg",
    ),
  ];
}

List<comp.HorizontalNewsCardData> get _newsList {
  return [
    (
      const Color(0xff0F77EB),
        l.S.current.business,
      //"Business",
        l.S.current.uSInflationDeceleratingInBoostToEconomy,
      //"US inflation decelerating in boost to economy",
      7000,
      500,
      "assets/images/static_images/placeholder_images/random_placeholders/placeholder_06.jpeg",
    ),
    (
      const Color(0xff8424FF),
      //"Politics",
    l.S.current.politics,
    l.S.current.uSInflationDeceleratingInBoostToEconomy,
      //"US inflation decelerating in boost to economy",
      7000,
      500,
      "assets/images/static_images/placeholder_images/random_placeholders/placeholder_07.jpeg",
    ),
    (
      const Color(0xff6B6CFF),
        l.S.current.familyS,
      //"Family's",
    l.S.current.uSInflationDeceleratingInBoostToEconomy,
      //"US inflation decelerating in boost to economy",
      7000,
      500,
      "assets/images/static_images/placeholder_images/random_placeholders/placeholder_08.png",
    ),
  ].map(
    (item) {
      return comp.HorizontalNewsCardData(
        categoryColor: item.$1,
        categoryName: item.$2,
        headline: item.$3,
        totalViews: item.$4,
        totalComments: item.$5,
        imageUrl: item.$6,
      );
    },
  ).toList();
}

List<(String, String, String, String)> get _latestComments {
  return [
    (
      "assets/images/static_images/avatars/person_images/person_image_09.jpeg",
      "Jenny Wilson",
      //"Great News",
      l.S.current.greatNews,
      //"2 Mins ago",
    "2 ${ l.S.current.minsAgo}",
    ),
    (
      "assets/images/static_images/avatars/person_images/person_image_10.jpeg",
      "Marvin McKinney",
      //"Great News",
    l.S.current.greatNews,
      //"2 Mins ago",
    "2 ${ l.S.current.minsAgo}",
    ),
    (
      "assets/images/static_images/avatars/person_images/person_image_11.jpeg",
      "Robert Fox",
      //"Great News",
    l.S.current.greatNews,
      //"2 Mins ago",
    "2 ${ l.S.current.minsAgo}",
    ),
    (
      "assets/images/static_images/avatars/person_images/person_image_12.jpeg",
      "Cody Fisher",
      //"Great News",
    l.S.current.greatNews,
      //"2 Mins ago",
    "2 ${ l.S.current.minsAgo}",
    ),
    (
      "assets/images/static_images/avatars/person_images/person_image_13.jpeg",
      "Jane Cooper",
      //"Great News",
    l.S.current.greatNews,
      "2 ${ l.S.current.minsAgo}",
    ),
  ];
}

List<CustomPiChartData> get _piChartData {
  return  [
    CustomPiChartData(color: const Color(0xffF0483F), label: l.S.current.business, value: 10),
    CustomPiChartData(color: const Color(0xff00BF71), label: l.S.current.politics, value: 10),
    CustomPiChartData(color: const Color(0xff0F77EB), label: l.S.current.health, value: 10),
    CustomPiChartData(color: const Color(0xff498DFF), label: l.S.current.sports, value: 10),
    CustomPiChartData(color: const Color(0xff6B6CFF), label: l.S.current.travels, value: 10),
    CustomPiChartData(color: const Color(0xff6BB8FF), label: l.S.current.familyS, value: 10),
    CustomPiChartData(color: const Color(0xff8424FF), label: l.S.current.science, value: 10),
    CustomPiChartData(color: const Color(0xffFF7744), label: l.S.current.technology, value: 10),
    CustomPiChartData(color: const Color(0xffFFC700), label: l.S.current.religion, value: 10),
  ];
}
