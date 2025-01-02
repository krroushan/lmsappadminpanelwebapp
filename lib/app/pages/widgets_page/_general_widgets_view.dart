// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:magicoon_icons/MagicoonIcons_icons.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../core/theme/theme.dart';
import '../../widgets/widgets.dart';
import '../dashboard/models/models.dart';
import 'general_data/general_data_model.dart';

class GeneralWidgetsView extends StatelessWidget {
  const GeneralWidgetsView({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _padding = responsiveValue<double>(
      context,
      xs: 8,
      lg: 12,
    );
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(_padding),
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

            //Crypto Card
            ResponsiveGridRow(
              rowSegments: 100,
              children: [
                ...List.generate(
                  CoinList.cryptoList.length - 1,
                  (index) {
                    final _info = CoinList.cryptoList[index];
                    return ResponsiveGridCol(
                      lg: 22,
                      md: 50,
                      xs: 100,
                      child: Padding(
                        padding: EdgeInsetsDirectional.all(_padding),
                        child: GeneralEarnWidget(
                          cryptoList: _info,
                        ),
                      ),
                    );
                  },
                ),
                ResponsiveGridCol(
                  lg: 34,
                  md: 50,
                  xs: 100,
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(_padding),
                    child: GeneralEarnWidget(
                      cryptoList: CoinList.cryptoList.last,
                    ),
                  ),
                )
              ],
            ),

            // Users Card___&___statistics
            ResponsiveGridRow(
              rowSegments: 100,
              children: [
                ResponsiveGridCol(
                  lg: 34,
                  md: 100,
                  xs: 100,
                  child: Container(
                    constraints: BoxConstraints.tightFor(
                      height: responsiveValue<double?>(
                        context,
                        xs: null,
                        lg: 423,
                      ),
                    ),
                    padding: EdgeInsetsDirectional.all(_padding),
                    child: const GeneralUsagesIncome(),
                  ),
                ),

                //User_info
                ...List.generate(
                  _userInfo.length,
                  (index) {
                    final _user = _userInfo[index];
                    final _cardMargin = responsiveValue<(double, double)>(
                      context,
                      xs: (8, 6),
                      md: (8, 4),
                      lg: (12, 12),
                    );
                    return ResponsiveGridCol(
                      lg: 22,
                      md: 33,
                      xs: 100,
                      child: Container(
                        constraints: BoxConstraints.tightFor(
                          height: responsiveValue<double?>(
                            context,
                            xs: null,
                            lg: 400,
                          ),
                        ),
                        margin: EdgeInsetsDirectional.symmetric(
                          horizontal: _cardMargin.$1,
                          vertical: _cardMargin.$2,
                        ),
                        child: UserProfileCardWidget(
                          imagePath: _user.$3,
                          name: _user.$1,
                          subtitle: _user.$2,
                          onpressed: () {},
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            // Overview Card
            ResponsiveGridRow(
              children: [
                ...List.generate(
                  _overviewCard.length,
                  (index) {
                    final _overview = _overviewCard[index];
                    return ResponsiveGridCol(
                      lg: 3,
                      md: 6,
                      child: Padding(
                        padding: EdgeInsetsDirectional.all(_padding),
                        child: OverviewCardWidget2(
                          containerColor: _overview.$4.withOpacity(0.25),
                          containerIcon: Icon(
                            _overview.$5,
                            color: _overview.$4,
                          ),
                          title: _overview.$1.toString(),
                          subTitle: _overview.$2,
                          text: _overview.$3,
                          bottomIcon: Icon(
                            index == 1 || index == 2
                                ? Icons.arrow_downward_outlined
                                : Icons.arrow_upward_outlined,
                            color: index == 1 || index == 2
                                ? AcnooAppColors.kError
                                : AcnooAppColors.kSuccess,
                            size: 16,
                          ),
                          progressColor: _overview.$4,
                          progressBackgroundColor:
                              _overview.$4.withOpacity(0.25),
                          percentValue: 0.15 * (index + 1),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            // User Card, Social Media Card & Calendar
            ResponsiveGridRow(
              rowSegments: 100,
              children: [
                ResponsiveGridCol(
                  lg: 27,
                  md: 50,
                  xs: 100,
                  child: Container(
                    constraints: BoxConstraints.tightFor(
                      height: responsiveValue<double?>(
                        context,
                        xs: null,
                        md: 410,
                      ),
                    ),
                    margin: EdgeInsetsDirectional.all(_padding),
                    child: const UserGridWidget(
                      imagePath:
                          'assets/images/static_images/avatars/person_images/person_image_05.jpeg',
                      name: 'Jonto Liya',
                      designation: 'UI/UX Designer',
                      followers: '485',
                      following: '187',
                      totalRevenue: '\$27,000',
                      orders: '75',
                      products: '25',
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 27,
                  md: 50,
                  xs: 100,
                  child: Container(
                    constraints: BoxConstraints.tightFor(
                      height: responsiveValue<double?>(
                        context,
                        xs: 360,
                        md: 410,
                      ),
                    ),
                    margin: EdgeInsetsDirectional.all(_padding),
                    child: ShadowContainer(
                      //headerText: 'Social Media Overview',
                      headerText: lang.socialMediaOverview,
                      child: const Align(child: SocialMediaOverviewGrid()),
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 46,
                  xs: 100,
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: responsiveValue(
                        context,
                        xs: 0.0,
                        md: 410,
                      ),
                    ),
                    margin: EdgeInsetsDirectional.all(_padding),
                    child: ShadowContainer(
                      // headerText: 'Calendar',
                      headerText: lang.calendar,
                      contentPadding: EdgeInsetsDirectional.zero,
                      child: const WidgetCalender(),
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

class SocialMediaOverviewGrid extends StatelessWidget {
  const SocialMediaOverviewGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _socialMediaInfo
              .take(3)
              .map(
                (item) => Flexible(
                  flex: 2,
                  child: SocialMediaOverviewCard(
                    platformName: item.$1,
                    platformLogoPath: item.$3,
                    followersCount: item.$2,
                  ),
                ),
              )
              .toList(),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _socialMediaInfo
              .skip(3)
              .map(
                (item) => Flexible(
                  flex: 2,
                  child: SocialMediaOverviewCard(
                    platformName: item.$1,
                    platformLogoPath: item.$3,
                    followersCount: item.$2,
                  ),
                ),
              )
              .toList(),
        )
      ],
    );
  }
}

List<(num, String, String, Color, IconData)> get _overviewCard {
  return [
    (
      20,
      //"This Month Leave Request",
      l.S.current.thisMonthLeaveRequest,
      //"12 Since Last Month Leave Request",
      "12 ${l.S.current.sinceLastMonthLeaveRequest}",
      const Color(0xff0D9AFF),
      MagicoonIcons.user_minus,
    ),
    (
      10000,
      l.S.current.thisMonthSalary,
      //"This Month Salary",
      //"\$8,000 Since Last Month Salary",
      "\$8,000 ${l.S.current.sinceLastMonthSalary}",
      const Color(0xff8B4DFF),
      MagicoonIcons.sack_dollar2,
    ),
    (
      20,
      l.S.current.totalEmployees,
      //"Total Employees",
      // "18 Today Present",
      "18 ${l.S.current.todayPresent}",
      const Color(0xff009F5E),
      MagicoonIcons.users_group1,
    ),
    (
      8000,
      //"This Month Expenses",
      l.S.current.thisMonthExpenses,
      // "\$10,000 Since Last Month Expenses",
      "\$10,000 ${l.S.current.sinceLastMonthExpenses}",
      const Color(0xffE13F3D),
      MagicoonIcons.money_bills,
    ),
  ];
}

List<(String, int, String)> get _socialMediaInfo => [
      (
        l.S.current.Facebook,
        5123,
        "assets/images/widget_images/sm_icon/facebok.png"
      ),
      (
        l.S.current.Twitter,
        5123,
        "assets/images/widget_images/sm_icon/twitter.png"
      ),
      (
        l.S.current.Instagram,
        5123,
        "assets/images/widget_images/sm_icon/instagram.png"
      ),
      (
        l.S.current.Youtube,
        5123,
        "assets/images/widget_images/sm_icon/youtube.png"
      ),
      (
        l.S.current.Linkedin,
        5123,
        "assets/images/widget_images/sm_icon/linkedIn.png"
      ),
      (
        l.S.current.Pinterest,
        5123,
        "assets/images/widget_images/sm_icon/pinterest.png"
      ),
    ];

List<(String, String, String)> get _userInfo => [
      (
        //"Arlene McCoy",
        l.S.current.ArleneMcCoy,
        //"Event planner",
        l.S.current.EventPlanner,
        "assets/images/static_images/avatars/person_images/person_image_11.jpeg"
      ),
      (
        //"Ralph Edwards",
        l.S.current.RalphEdwards,
        l.S.current.LanguageTutor,
        //"Language Tutor",
        "assets/images/static_images/avatars/person_images/person_image_12.jpeg"
      ),
      (
        //"Devon Lane",
        l.S.current.devonLane,
        l.S.current.FitnessTrainer,
        // "Fitness Trainer",
        "assets/images/static_images/avatars/person_images/person_image_13.jpeg"
      ),
    ];

List<OverviewItem> get _overviewItems => <OverviewItem>[
      ...[
        (
          "assets/images/widget_images/dashboard_overview_icon/edit_icon.png",
          500,
          l.S.current.generatedArticle,
          //"Generated Article",
          const Color(0xffAD00FF)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/speech_to_text.png",
          500,
          //"Speech To Text ",
          l.S.current.SpeechToText,
          const Color(0xff00AD66)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/image_icon.png",
          500,
          l.S.current.imagesGenerated,
          // "Images Generated ",
          const Color(0xff4429FF)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/pdf_icon.png",
          500,
          l.S.current.PDFGenerate,
          //"PDF Generate ",
          const Color(0xffEE11E5)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/code_icon.png",
          500,
          l.S.current.codeGenerated,
          //"Code Generated ",
          const Color(0xffFE6921)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/voiceover_icon.png",
          500,
          l.S.current.voiceoverGenerated,
          //"Voiceover Generated ",
          const Color(0xff1570EF)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/document_icon.png",
          500,
          l.S.current.documentGenerated,
          //"Document Generated",
          const Color(0xff00AD66)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/credit_card_icon.png",
          500,
          l.S.current.totalCreditBalance,
          //"Total Credit Balance",
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
