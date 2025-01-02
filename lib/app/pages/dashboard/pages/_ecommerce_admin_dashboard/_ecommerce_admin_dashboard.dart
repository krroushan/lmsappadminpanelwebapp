// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/theme/theme.dart';
import '../../../../widgets/widgets.dart';
import 'components/_components.dart' as comp;

class ECommerceAdminDashboardView extends StatelessWidget {
  const ECommerceAdminDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    final _mqSize = MediaQuery.sizeOf(context);
    final _lang = l.S.of(context);

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
            // Overviews
            ResponsiveGridRow(
              rowSegments: 100,
              children: List.generate(
                _overviewItems.length,
                (index) {
                  final _data = _overviewItems[index];

                  return ResponsiveGridCol(
                    lg: _mqSize.width < 1400 ? 33 : 20,
                    md: _mqSize.width < 768 ? 50 : 33,
                    xs: 100,
                    child: Padding(
                      padding: EdgeInsets.all(_padding / 2.5),
                      child: OverviewTileWidget(
                        value: _data.$1,
                        title: _data.$2,
                        imagePath: _data.$3,
                        iconSize: 60,
                        valueStyle: _theme.textTheme.titleLarge?.copyWith(
                          color: _isDark ? Colors.white : null,
                        ),
                        titleStyle: _theme.textTheme.bodyLarge?.copyWith(
                          color: _isDark ? Colors.white : null,
                        ),
                        iconAlignment: IconAlignment.end,
                        tileColor: _data.$4.withOpacity(_isDark ? 0.2 : 1),
                        iconRadius: BorderRadius.zero,
                        iconBackgroundColor: Colors.transparent,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Other Contents
            ResponsiveGridRow(
              children: [
                // Left Side Contents
                ResponsiveGridCol(
                  lg: _mqSize.width < 1700 ? 7 : 8,
                  child: ResponsiveGridRow(
                    children: [
                      // Order Status
                      ResponsiveGridCol(
                        child: ShadowContainer(
                          margin: EdgeInsetsDirectional.all(_padding / 2.5),
                          contentPadding:
                              EdgeInsetsDirectional.all(_padding / 2.5),
                          // headerText: 'Order Status',
                          headerText: _lang.orderStatus,
                          trailing: const FilterDropdownButton(),
                          child: ResponsiveGridRow(
                            children: List.generate(
                              _orderStatus.length,
                              (index) {
                                final _data = _orderStatus[index];
                                return ResponsiveGridCol(
                                  lg: _mqSize.width < 1700 ? 6 : 4,
                                  md: _mqSize.width < 768 ? 6 : 4,
                                  xs: _mqSize.width < 480 ? 12 : 6,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.all(
                                      _padding / 2.5,
                                    ),
                                    child: OverviewTileWidget(
                                      value: _data.$1,
                                      title: _data.$2,
                                      imagePath: _data.$3,
                                      iconBackgroundColor: _data.$4,
                                      tileColor: _data.$5.withOpacity(
                                        _isDark ? 0.20 : 1,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      // Top Customers
                      ResponsiveGridCol(
                        lg: _mqSize.width < 1400 ? 12 : 6,
                        md: _mqSize.width < 768 ? 12 : 6,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(
                            height: 390,
                          ),
                          child: ShadowContainer(
                            margin: EdgeInsets.all(_padding / 2.5),
                            contentPadding: EdgeInsets.zero,
                            // headerText: 'Top Customers',
                            headerText: _lang.topCustomers,
                            trailing: Text.rich(
                              TextSpan(
                                // text: 'View All',
                                text: _lang.viewAll,
                                mouseCursor: SystemMouseCursors.click,
                              ),
                              style: _theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: _theme.colorScheme.primary,
                              ),
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: _customerOfTheMonth.length * 2,
                              itemBuilder: (context, index) {
                                final _item = [
                                  ..._customerOfTheMonth,
                                  ..._customerOfTheMonth.reversed
                                ][index];

                                return comp.ItemListTile(
                                  title: _item.$1,
                                  subtitle: _item.$2,
                                  imagePath: _item.$4,
                                  trailing:
                                      '${_lang.orders}: ${NumberFormat.currency(decimalDigits: 0, symbol: '').format(_item.$3)}',
                                  trailingColor: AcnooAppColors.kSuccess,
                                );
                              },
                              separatorBuilder: (c, i) {
                                return const SizedBox(height: 16);
                              },
                            ),
                          ),
                        ),
                      ),

                      // Top Selling Items
                      ResponsiveGridCol(
                        lg: _mqSize.width < 1400 ? 12 : 6,
                        md: _mqSize.width < 768 ? 12 : 6,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(
                            height: 390,
                          ),
                          child: ShadowContainer(
                            margin: EdgeInsets.all(_padding / 2.5),
                            contentPadding: EdgeInsets.zero,
                            //headerText: 'Top Selling Items',
                            headerText: _lang.topSellingItems,
                            trailing: Text.rich(
                              TextSpan(
                                // text: 'View All',
                                text: _lang.viewAll,
                                mouseCursor: SystemMouseCursors.click,
                              ),
                              style: _theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: _theme.colorScheme.primary,
                              ),
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: _topSellingProduct.length * 2,
                              itemBuilder: (context, index) {
                                final _item = [
                                  ..._topSellingProduct,
                                  ..._topSellingProduct.reversed
                                ][index];

                                return comp.ItemListTile(
                                  title: _item.$1,
                                  subtitle: _item.$2,
                                  imagePath: _item.$4,
                                  trailing:
                                      '${_lang.sales}: ${NumberFormat.currency(decimalDigits: 0, symbol: '').format(_item.$3)}',
                                  trailingColor: AcnooAppColors.kWarning,
                                );
                              },
                              separatorBuilder: (c, i) {
                                return const SizedBox(height: 16);
                              },
                            ),
                          ),
                        ),
                      ),

                      // Earning Reports
                      ResponsiveGridCol(
                        child: ConstrainedBox(
                          constraints: BoxConstraints.tightFor(
                            height: _mqSize.width < 1240 ? 500 : 455,
                          ),
                          child: ShadowContainer(
                            margin: EdgeInsetsDirectional.all(_padding / 2.5),
                            contentPadding:
                                const EdgeInsetsDirectional.fromSTEB(
                              16,
                              16,
                              24,
                              16,
                            ),
                            // headerText: 'Earning Reports',
                            headerText: _lang.earningReports,
                            trailing: const FilterDropdownButton(),
                            child: const comp.EarningReportChart(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right Side Contents
                ResponsiveGridCol(
                  lg: _mqSize.width < 1700 ? 5 : 4,
                  child: ResponsiveGridRow(
                    children: [
                      // Sales Overview
                      ResponsiveGridCol(
                        lg: 12,
                        md: _mqSize.width < 768 ? 12 : 6,
                        child: ShadowContainer(
                          margin: EdgeInsetsDirectional.all(_padding / 2.5),
                          // headerText: 'Sales Overview',
                          headerText: _lang.salesOverview,
                          trailing: const FilterDropdownButton(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.loose(
                              const Size.fromHeight(390),
                            ),
                            child: const comp.SalesOverviewChart(),
                          ),
                        ),
                      ),

                      // Top Brands
                      ResponsiveGridCol(
                        lg: 12,
                        md: _mqSize.width < 768 ? 12 : 6,
                        child: ConstrainedBox(
                          constraints: BoxConstraints.tightFor(
                            height: _mqSize.width < 1240
                                ? 500
                                : _mqSize.width < 1400
                                    ? 650
                                    : _mqSize.width < 1700
                                        ? 400
                                        : 320,
                          ),
                          child: ShadowContainer(
                            margin: EdgeInsetsDirectional.all(
                              _padding / 2.5,
                            ),
                            contentPadding: EdgeInsetsDirectional.zero,
                            //headerText: 'Top Brands',
                            headerText: _lang.topBrands,
                            trailing: Text.rich(
                              TextSpan(
                                //text: 'View All',
                                text: _lang.viewAll,
                                mouseCursor: SystemMouseCursors.click,
                              ),
                              style: _theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: _theme.colorScheme.primary,
                              ),
                            ),
                            child: ListView.separated(
                              padding: EdgeInsetsDirectional.only(
                                start: _padding,
                                end: _padding + 8,
                              ),
                              itemCount: _topBrands.length * 2,
                              itemBuilder: (context, index) {
                                final _data = [
                                  ..._topBrands.entries,
                                  ..._topBrands.entries.toList().reversed
                                ][index];

                                return ListTile(
                                  contentPadding: EdgeInsetsDirectional.zero,
                                  title: Text(_data.key),
                                  trailing: Text(_data.value.toString()),
                                  leadingAndTrailingTextStyle:
                                      _theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              },
                              separatorBuilder: (c, i) {
                                return const SizedBox(height: 6);
                              },
                            ),
                          ),
                        ),
                      ),

                      // User Statistics
                      ResponsiveGridCol(
                        md: 12,
                        child: ConstrainedBox(
                          constraints: BoxConstraints.tightFor(
                            height: _mqSize.width < 1240
                                ? 480
                                : _mqSize.width < 1400
                                    ? 380
                                    : _mqSize.width < 1700
                                        ? 340
                                        : 320,
                          ),
                          child: ShadowContainer(
                            margin: EdgeInsetsDirectional.all(
                              _padding / 2.5,
                            ),
                            contentPadding: EdgeInsetsDirectional.symmetric(
                              horizontal: _padding,
                            ),
                            // headerText: 'User Statistics',
                            headerText: _lang.userStatistics,
                            trailing: const FilterDropdownButton(),
                            child: const Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: comp.UserStatisticsPiChart(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Tables
            ResponsiveGridRow(
              children: [
                ResponsiveGridCol(
                  lg: 7,
                  child: ShadowContainer(
                    margin: EdgeInsetsDirectional.all(_padding / 2.5),
                    contentPadding: EdgeInsetsDirectional.zero,
                    // headerText: 'Top Vendors',
                    headerText: _lang.topVendors,
                    trailing: Text.rich(
                      TextSpan(
                        //text: 'View All',
                        text: _lang.viewAll,
                        style: TextStyle(
                          color: _theme.colorScheme.primary,
                        ),
                        mouseCursor: SystemMouseCursors.click,
                      ),
                      style: _theme.textTheme.bodyMedium,
                    ),
                    child: const comp.TopVendorsTable(),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 5,
                  child: ShadowContainer(
                    margin: EdgeInsetsDirectional.all(_padding / 2.5),
                    contentPadding: EdgeInsetsDirectional.zero,
                    // headerText: 'Top Delivery Man',
                    headerText: _lang.topDeliveryMan,
                    trailing: Text.rich(
                      TextSpan(
                        //text: 'View All',
                        text: _lang.viewAll,
                        style: TextStyle(
                          color: _theme.colorScheme.primary,
                        ),
                        mouseCursor: SystemMouseCursors.click,
                      ),
                      style: _theme.textTheme.bodyMedium,
                    ),
                    child: const comp.TopDeliveryManTable(),
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

List<(int, String, String, Color)> get _overviewItems => [
      (
        27,
        l.S.current.totalOrders,
        // "Total Orders",
        "assets/images/widget_images/dashboard_overview_icon/total_orders.svg",
        const Color(0xffFFD7FD),
      ),
      (
        70,
        l.S.current.totalProducts,
        //"Total Products",
        "assets/images/widget_images/dashboard_overview_icon/total_products.svg",
        const Color(0xffddecff),
      ),
      (
        50,
        l.S.current.totalStores,
        //"Total Stores",
        "assets/images/widget_images/dashboard_overview_icon/total_stores.svg",
        const Color(0xffEDD9FF),
      ),
      (
        8,
        //"Total Delivery Boy",
        l.S.current.totalDeliveryBoy,
        "assets/images/widget_images/dashboard_overview_icon/total_delivery_boy.svg",
        const Color(0xffFFE5D9),
      ),
      (
        500,
        // "Total Revenue",
        l.S.current.totalRevenue,
        "assets/images/widget_images/dashboard_overview_icon/total_revenue.svg",
        const Color(0xffCFFEEC),
      ),
    ];

List<(int, String, String, Color, Color)>get _orderStatus => [
  (
    10,
    //"Pending",
    l.S.current.pending,
    "assets/images/widget_images/dashboard_overview_icon/ecommerce_admin_icons/pending_orders.svg",
    const Color(0xffFF6921),
    const Color(0xffFFF4EF),
  ),
  (
    8,
    // "Processing",
    l.S.current.processing,
    "assets/images/widget_images/dashboard_overview_icon/ecommerce_admin_icons/processing_orders.svg",
    const Color(0xff4429FF),
    const Color(0xffEEEDFF),
  ),
  (
    6,
    //"Cancelled",
    l.S.current.cancelled,
    "assets/images/widget_images/dashboard_overview_icon/ecommerce_admin_icons/cancelled_orders.svg",
    const Color(0xffFA0808),
    const Color(0xffFFF0F0),
  ),
  (
    15,
    //"Shipped",
    l.S.current.shipped,
    "assets/images/widget_images/dashboard_overview_icon/ecommerce_admin_icons/shipped_orders.svg",
    const Color(0xff851EEC),
    const Color(0xffF5EDFD),
  ),
  (
    12,
    //"Out of Delivery",
    l.S.current.outOfDelivery,
    "assets/images/widget_images/dashboard_overview_icon/ecommerce_admin_icons/out_of_delivery_orders.svg",
    const Color(0xffE300CD),
    const Color(0xffFFEEFD),
  ),
  (
    25,
    l.S.current.delivered,
    //"Delivered",
    "assets/images/widget_images/dashboard_overview_icon/ecommerce_admin_icons/delivered_orders.svg",
    const Color(0xff00B293),
    const Color(0xffDCFBF5),
  ),
];

List<(String, String, int, String)> get _customerOfTheMonth => [
      (
        //"Jenny Wilson",
        l.S.current.jennyWilson,
        "01855632145",
        15,
        "assets/images/static_images/avatars/person_images/person_image_09.jpeg",
      ),
      (
        //"Dianne Russell",
        l.S.current.dianneRussell,
        "01855632145",
        15,
        "assets/images/static_images/avatars/person_images/person_image_10.jpeg",
      ),
      (
        //"Wade Warren",
        l.S.current.wadeWarren,
        "01855632145 ",
        15,
        "assets/images/static_images/avatars/person_images/person_image_11.jpeg",
      ),
      (
        //"Darrell Steward",
        l.S.current.darrellSteward,
        "01855632145 ",
        15,
        "assets/images/static_images/avatars/person_images/person_image_12.jpeg",
      ),
      (
        //"Bessie Cooper",
        l.S.current.bessieCooper,
        "01855632145",
        15,
        "assets/images/static_images/avatars/person_images/person_image_13.jpeg",
      ),
    ];
List<(String, String, int, String)> get _topSellingProduct => [
      (
        //"Coca cola",
        l.S.current.cocaCola,
        //"Drinks",
        l.S.current.drinks,

        15,
        "assets/images/static_images/product_images/product_image_05.png",
      ),
      (
        //"Fanta",
        l.S.current.fanta,
        // "Drinks",
        l.S.current.drinks,
        15,
        "assets/images/static_images/product_images/product_image_06.png",
      ),
      (
        //"Potato",
        l.S.current.potato,
        //"Food ",
        l.S.current.food,
        15,
        "assets/images/static_images/product_images/product_image_07.png",
      ),
      (
        //"Banana",
        l.S.current.banana,
        //"Fruits ",
        l.S.current.fruits,
        15,
        "assets/images/static_images/product_images/product_image_08.png",
      ),
      (
        //"Bread",
        l.S.current.bread,
        //"Food",
        l.S.current.food,
        15,
        "assets/images/static_images/product_images/product_image_09.png",
      ),
    ];
Map<String, num> get _topBrands => {
      l.S.current.samsung: 45,
      l.S.current.fashion: 57,
      l.S.current.apple: 30,
      l.S.current.generalMotors: 15,
      l.S.current.foods: 25,
    };
