// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:iconly/iconly.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart' as intl;
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/theme/theme.dart';
import '../../../../widgets/widgets.dart';
import 'components/_components.dart' as comp;

class POSAdminDashboard extends StatelessWidget {
  const POSAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final _locale = Localizations.localeOf(context);
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    final _mqSize = MediaQuery.sizeOf(context);
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
                    lg: 25,
                    md: _mqSize.width < 992 ? 50 : 33,
                    xs: 100,
                    child: Padding(
                      padding: EdgeInsetsDirectional.all(_padding / 2.5),
                      child: OverviewCardWidget(
                        value: _data.$1,
                        title: _data.$2,
                        fluctuationAmount: _data.$3,
                        fluctuationFrequency: _data.$4,
                        cardColor: _data.$5,
                        hasIncreases: _data.$6,
                        showCurrency: index != 0,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Statistics Chart & Stock Value
            ResponsiveGridRow(
              children: [
                ResponsiveGridCol(
                  lg: 8,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(height: 440),
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      contentPadding: const EdgeInsetsDirectional.fromSTEB(
                        16,
                        28,
                        16,
                        20,
                      ),
                      leading: const Padding(
                        padding: EdgeInsetsDirectional.only(
                          end: 8,
                        ),
                        child: Icon(IconlyLight.activity, size: 22),
                      ),
                      //headerText: 'Statistic',
                      headerText: lang.statistic,
                      trailing: const FilterDropdownButton(
                        buttonDecoration: BoxDecoration(),
                      ),
                      child: const comp.StatisticsLineChart(),
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(height: 440),
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      //headerText: 'Stock Value',
                      headerText: lang.stockValue,
                      trailing: Text(
                        intl.NumberFormat.simpleCurrency(
                          locale: _locale.countryCode,
                        ).format(4726793.75),
                        style: _theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AcnooAppColors.kSuccess,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang.lowStock,
                            // 'Low Stock',
                            style: _theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Flexible(
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _theme.colorScheme.outline,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const comp.LowStockListWidget(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Top Selling Product, Customer of the month & Top 5 Purchasing Product
            ResponsiveGridRow(
              children: [
                ResponsiveGridCol(
                  lg: 4,
                  md: 6,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(height: 390),
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      contentPadding: EdgeInsetsDirectional.zero,
                      leading: const Padding(
                        padding: EdgeInsetsDirectional.only(end: 8),
                        child: Icon(IconsaxPlusLinear.box_1, size: 22),
                      ),
                      //headerText: 'Top Selling Product',
                      headerText: lang.topSellingProduct,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _topSellingProduct.length * 2,
                        itemBuilder: (context, index) {
                          final _item = [
                            ..._topSellingProduct,
                            ..._topSellingProduct.reversed
                          ][index];

                          return comp.ProductListTile(
                            title: _item.$1,
                            subtitle: _item.$2,
                            amount: _item.$3,
                            imagePath: _item.$4,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  md: 6,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(height: 390),
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      contentPadding: EdgeInsetsDirectional.zero,
                      leading: const Padding(
                        padding: EdgeInsetsDirectional.only(end: 8),
                        child: Icon(IconlyLight.user_1, size: 22),
                      ),
                      // headerText: 'Customer of the month',
                      headerText: lang.customerOfTheMonth,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _customerOfTheMonth.length * 2,
                        itemBuilder: (context, index) {
                          final _item = [
                            ..._customerOfTheMonth,
                            ..._customerOfTheMonth.reversed
                          ][index];

                          return comp.ProductListTile(
                            title: _item.$1,
                            subtitle: _item.$2,
                            amount: _item.$3,
                            imagePath: _item.$4,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(height: 390),
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      contentPadding: EdgeInsetsDirectional.zero,
                      leading: const Padding(
                        padding: EdgeInsetsDirectional.only(end: 8),
                        child: Icon(IconsaxPlusLinear.box_1, size: 22),
                      ),
                      //headerText: 'Top 5 Purchasing Product',
                      headerText: lang.top5PurchasingProduct,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _top5PurchasingProduct.length * 2,
                        itemBuilder: (context, index) {
                          final _item = [
                            ..._top5PurchasingProduct,
                            ..._top5PurchasingProduct.reversed
                          ][index];

                          return comp.ProductListTile(
                            title: _item.$1,
                            subtitle: _item.$2,
                            amount: _item.$3,
                            imagePath: _item.$4,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Recent Sales Table
            ShadowContainer(
              margin: EdgeInsetsDirectional.all(_padding / 2.5),
              contentPadding: EdgeInsetsDirectional.zero,
              leading: const Padding(
                padding: EdgeInsetsDirectional.only(end: 8),
                child: Icon(IconlyLight.activity, size: 22),
              ),
              //headerText: 'Recent Sales',
              headerText: lang.recentSales,
              trailing: Text.rich(
                TextSpan(
                  children: [
                    //const TextSpan(text: "Show 5 Results - "),
                    TextSpan(text: "${lang.show5Results} - "),
                    TextSpan(
                      //text: 'View All',
                      text: lang.viewAll,
                      style: TextStyle(
                        color: _theme.colorScheme.primary,
                      ),
                      mouseCursor: SystemMouseCursors.click,
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Container(
                            margin: const EdgeInsetsDirectional.only(
                              start: 6,
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: _theme.colorScheme.primary,
                              size: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                style: _theme.textTheme.bodyMedium,
              ),
              child: const comp.RecentSalesTable(),
            ),
          ],
        ),
      ),
    );
  }
}

List<(int, String, int, String, Color, bool)> get _overviewCardData => [
      (
        100,
        //"Total Sales",
        l.S.current.totalSales,
        30,
        //"This Month ",
        l.S.current.thisMonth,
        const Color(0xffB9FDEC),
        true,
      ),
      /*
  (
    500,
    "Sales Amount",
    20000,
    "This Month ",
    const Color(0xffDFDAFF),
    true,
  ),
  */
      (
        300,
        //"Total Profit",
        l.S.current.totalProfit,
        20000,
        l.S.current.thisMonth,
        //"This Month",
        const Color(0xffC8E6FE),
        true,
      ),
      (
        800,
        //"Expense",
        l.S.current.expense,
        15000,
        //"This Month",
        l.S.current.thisMonth,
        const Color(0xffFFD6E2),
        false,
      ),
      (
        900,
        //"Income",
        l.S.current.income,
        20000,
        l.S.current.thisMonth,
        //"This Month",
        const Color(0xffC5FDBF),
        true,
      ),
    ];
List<(String, String, int, String)> get _topSellingProduct => [
      (
        //"Coca cola",
        l.S.current.cocaCola,
        //"Drinks",
        l.S.current.drinks,

        2560,
        "assets/images/static_images/product_images/product_image_05.png",
      ),
      (
        //"Fanta",
        l.S.current.fanta,
        // "Drinks",
        l.S.current.drinks,
        250,
        "assets/images/static_images/product_images/product_image_06.png",
      ),
      (
        //"Potato",
        l.S.current.potato,
        //"Food ",
        l.S.current.food,
        250,
        "assets/images/static_images/product_images/product_image_07.png",
      ),
      (
        //"Banana",
        l.S.current.banana,
        //"Fruits ",
        l.S.current.fruits,
        250,
        "assets/images/static_images/product_images/product_image_08.png",
      ),
      (
        //"Bread",
        l.S.current.bread,
        //"Food",
        l.S.current.food,
        250,
        "assets/images/static_images/product_images/product_image_09.png",
      ),
    ];

List<(String, String, int, String)> get _customerOfTheMonth => [
      (
        //"Jenny Wilson",
        l.S.current.jennyWilson,
        "01855632145",
        250,
        "assets/images/static_images/avatars/person_images/person_image_09.jpeg",
      ),
      (
        //"Dianne Russell",
        l.S.current.dianneRussell,
        "01855632145",
        250,
        "assets/images/static_images/avatars/person_images/person_image_10.jpeg",
      ),
      (
        //"Wade Warren",
        l.S.current.wadeWarren,
        "01855632145 ",
        250,
        "assets/images/static_images/avatars/person_images/person_image_11.jpeg",
      ),
      (
        //"Darrell Steward",
        l.S.current.darrellSteward,
        "01855632145 ",
        250,
        "assets/images/static_images/avatars/person_images/person_image_12.jpeg",
      ),
      (
        //"Bessie Cooper",
        l.S.current.bessieCooper,
        "01855632145",
        250,
        "assets/images/static_images/avatars/person_images/person_image_13.jpeg",
      ),
    ];

List<(String, String, int, String)> get _top5PurchasingProduct => [
      (
        //"Rice",
        l.S.current.rice,
        //"Food",
        l.S.current.food,
        15,
        "assets/images/static_images/product_images/product_image_10.png",
      ),
      (
        // "Fresh Fruits",
        l.S.current.freshFruits,
        //"Fruits",
        l.S.current.fruits,

        20,
        "assets/images/static_images/product_images/product_image_11.png",
      ),
      (
        //"Beef Meat",
        l.S.current.beefMeat,
        //"Food ",
        l.S.current.food,

        15,
        "assets/images/static_images/product_images/product_image_12.png",
      ),
      (
        // "Apple",
        l.S.current.apple,
        l.S.current.fruits,
        //"Fruits ",
        30,
        "assets/images/static_images/product_images/product_image_13.png",
      ),
      (
        l.S.current.mango,
        l.S.current.fruits,
        // "Mango",
        //"Fruits",
        25,
        "assets/images/static_images/product_images/product_image_14.png",
      ),
    ];
