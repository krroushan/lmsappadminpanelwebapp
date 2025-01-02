// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../widgets/widgets.dart';
import '../../models/models.dart';
import 'components/_components.dart' as comp;

class ERPAdminDashboardView extends StatelessWidget {
  const ERPAdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    final lang = l.S.of(context);
    final _mqSize = MediaQuery.sizeOf(context);
    // final _showTablet = _mqSize.width >= 992 && _mqSize.width <= 1240;

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
                    constraints: const BoxConstraints.tightFor(height: 440),
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),

                      contentPadding: const EdgeInsetsDirectional.fromSTEB(
                        16,
                        28,
                        16,
                        20,
                      ),
                      // headerText: 'Income VS Expense',
                      headerText: lang.incomeVSExpense,
                      headerBackgroundColor:
                          const Color(0xffFFE3ED).withOpacity(
                        _isDark ? 0.15 : 0.20,
                      ),
                      trailing: const FilterDropdownButton(),
                      child: const comp.IncomeExpenseLineChart(),
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(height: 440),
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      contentPadding: EdgeInsetsDirectional.zero,
                      //headerText: 'New Orders',
                      headerBackgroundColor: const Color(0xffF8FFE0)
                          .withOpacity(_isDark ? 0.15 : 1),
                      headerText: lang.newOrders,
                      trailing: FilterDropdownButton(
                        items: [
                          DropdownMenuItem(
                            value: null,
                            enabled: false,
                            //child: Text('Status'),
                            child: Text(lang.status),
                          ),
                          ...[
                            //"All",
                            lang.all,
                            //"Approved",
                            lang.approved,
                            //"Pending",
                            lang.pending
                          ].map(
                            (item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            ),
                          ),
                        ],
                        onChanged: (value) {},
                      ),
                      child: ListView.separated(
                        padding: EdgeInsetsDirectional.all(_padding / 1.25),
                        itemCount: 10,
                        shrinkWrap: true,
                        itemBuilder: (ctx, idx) {
                          return comp.OrderListTile(
                            orderNumber: '#OID3548712',
                            //orderTitle: 'Black T-Shirt For Man',
                            orderTitle: lang.blackTShirtForMan,
                            orderDate:
                                DateTime.now().subtract(Duration(days: idx)),
                            orderStatus: idx % 2 == 0
                                ? comp.OrderStatus.approved
                                : comp.OrderStatus.pending,
                          );
                        },
                        separatorBuilder: (__, _) {
                          return const SizedBox(height: 20);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),

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
                      //headerText: 'Sales Ratio',
                      headerText: lang.salesRatio,
                      headerBackgroundColor:
                          const Color(0xffAF49FF).withOpacity(0.10),
                      trailing: FilterDropdownButton(
                        items: List.generate(
                          5,
                          (i) => DropdownMenuItem(
                            value: i,
                            child: Text((2021 + i).toString()),
                          ),
                        ),
                      ),
                      child: const comp.SaleRatioChart(),
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  child: Container(
                    constraints: BoxConstraints.tightFor(
                      height: responsiveValue<double?>(
                        context,
                        xs: 320,
                        md: 440,
                      ),
                    ),
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      contentPadding: EdgeInsetsDirectional.symmetric(
                        horizontal: _padding,
                      ),
                      // headerText: 'Sales By Country',
                      headerText: lang.salesByCountry,
                      trailing: const FilterDropdownButton(),
                      headerBackgroundColor: const Color(0xffE2FFE3)
                          .withOpacity(_isDark ? 0.15 : 1),
                      child: const Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: comp.SalesByCountryPiChart(),
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

List<OverviewItem> get _overviewItems => <OverviewItem>[
      ...[
        (
          "assets/images/widget_images/dashboard_overview_icon/edit_icon.png",
          500,
          //"Total Orders",
          l.S.current.totalOrders,
          const Color(0xffAD00FF)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/speech_to_text.png",
          500,
          //"Running Order",
          l.S.current.runningOrder,
          const Color(0xff00AD66)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/image_icon.png",
          500,
          // "Pending Order",
          l.S.current.pendingOrder,
          const Color(0xff4429FF)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/pdf_icon.png",
          200,
          //"Weekly Value",
          l.S.current.weeklyValue,
          const Color(0xffEE11E5)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/code_icon.png",
          170,
          //"Monthly Value",
          l.S.current.monthlyValue,
          const Color(0xffFE6921)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/voiceover_icon.png",
          350,
          //"Yearly Value",
          l.S.current.yearlyValue,
          const Color(0xff1570EF)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/document_icon.png",
          870,
          //"Cash Balance",
          l.S.current.cashBalance,
          const Color(0xff00AD66)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/credit_card_icon.png",
          500,
          l.S.current.bankBalance,
          //"Bank Balance",
          const Color(0xff8106FB)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/edit_icon.png",
          300,
          // "Supplier Due",
          l.S.current.supplierDue,
          const Color(0xffAD00FF)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/speech_to_text.png",
          555,
          //"Monthly Expense",
          l.S.current.monthlyExpense,
          const Color(0xff00AD66)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/image_icon.png",
          700,
          //"Debit Transaction",
          l.S.current.debitTransaction,
          const Color(0xff4429FF)
        ),
        (
          "assets/images/widget_images/dashboard_overview_icon/pdf_icon.png",
          200,
          // "Credit Transaction",
          l.S.current.creditTransaction,
          const Color(0xffEE11E5)
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
