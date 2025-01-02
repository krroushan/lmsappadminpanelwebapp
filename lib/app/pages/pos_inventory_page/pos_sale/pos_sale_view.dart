import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:intl/intl.dart' as intl;
import '../../../core/theme/theme.dart';
import '../../../widgets/widgets.dart';
import 'components/components.dart';
import '../../../../generated/l10n.dart' as l;

class POSSaleView extends StatefulWidget {
  const POSSaleView({super.key});

  @override
  State<POSSaleView> createState() => _POSSaleViewState();
}

class _POSSaleViewState extends State<POSSaleView> {
  late List<SaleProductModel> _filteredData;
  final ScrollController _scrollController = ScrollController();
  final List<SaleProductModel> sales = allSale;
  final int _currentPage = 0;
  final int _rowsPerPage = 10;
  final String _searchQuery = '';
  final bool _selectAll = false;
  List<SaleProductModel> get _currentPageData {
    if (_searchQuery.isNotEmpty) {
      _filteredData = sales
          .where(
            (data) =>
                data.product
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                data.price.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                data.subtotal.contains(
                  _searchQuery,
                ),
          )
          .toList();
    } else {
      _filteredData = List.from([...sales, ...sales.reversed]);
    }

    int start = _currentPage * _rowsPerPage;
    int end = start + _rowsPerPage;
    return _filteredData.sublist(
      start,
      end > _filteredData.length ? _filteredData.length : end,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _lang = l.S.of(context);
    final _mqSize = MediaQuery.sizeOf(context);
    // bool _showDesktop = _mqSize.width > 992;

    final _padding = responsiveValue<double>(context, xs: 6.4, lg: 9.6);

    return Scaffold(
      body: ShadowContainer(
        margin: EdgeInsets.all(_padding),
        contentPadding: EdgeInsets.zero,
        showHeader: false,
        child: ScrollbarTheme(
          data: const ScrollbarThemeData(),
          child: SingleChildScrollView(
            child: ResponsiveGridRow(
              children: [
                // Product Grid Section
                ResponsiveGridCol(
                  lg: 7,
                  md: _mqSize.width < 1080 ? 12 : 6,
                  child: _buildProductGrid(context, padding: _padding),
                ),

                // Actions
                ResponsiveGridCol(
                  lg: 5,
                  md: _mqSize.width < 1080 ? 12 : 6,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: BorderDirectional(
                        start: BorderSide(color: _theme.colorScheme.outline),
                        bottom: BorderSide(color: _theme.colorScheme.outline),
                      ),
                    ),
                    child: ResponsiveGridRow(
                      children: [
                        // Form
                        ResponsiveGridCol(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: _padding * 0.4,
                              vertical: _padding,
                            ),
                            child: ResponsiveGridRow(
                              children: [
                                ...[
                                  const Calender(),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: '${_lang.invoiceNo}.',
                                    ),
                                  ),
                                  const Customer(),
                                  const SaleWarehouse(),
                                ].map(
                                  (child) {
                                    return ResponsiveGridCol(
                                      md: 6,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: _padding,
                                          vertical: _padding * 0.70,
                                        ),
                                        child: child,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Products Table
                        ResponsiveGridCol(
                          child: Theme(
                            data: _theme.copyWith(
                              dividerTheme: _theme.dividerTheme.copyWith(
                                color: _theme.colorScheme.outline,
                              ),
                            ),
                            child: _buildDataTable(context),
                          ),
                        ),

                        // Overiew & Actions
                        ResponsiveGridCol(
                          child: ResponsiveGridRow(
                            children: [
                              ResponsiveGridCol(
                                child: Divider(
                                  color: _theme.colorScheme.outline,
                                  height: 16,
                                ),
                              ),

                              // Overview
                              ResponsiveGridCol(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: _padding,
                                    vertical: _padding * 1.75,
                                  ),
                                  child: _buildOverviewAction(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context, {double padding = 0}) {
    final _theme = Theme.of(context);

    final _filterWidgets = <ResponsiveGridCol>[
      ResponsiveGridCol(
        md: 9,
        child: Container(
          margin: responsiveValue(
            context,
            xs: const EdgeInsetsDirectional.only(top: 10),
            md: const EdgeInsetsDirectional.only(end: 20),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: l.S.current.scanSearchProductByCodeOrName,
              suffixIconConstraints: const BoxConstraints.tightFor(
                width: 48,
              ),
              suffixIcon: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AcnooAppColors.kPrimary700,
                  padding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.horizontal(
                      end: Radius.circular(6),
                    ),
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ),
      ),
      ResponsiveGridCol(
        md: 3,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Text(l.S.current.category),
        ),
      ),
    ];

    return Column(
      children: [
        // Search & Filter
        Padding(
          padding: EdgeInsets.all(padding),
          child: ResponsiveGridRow(
            children: [
              ...responsiveValue(
                context,
                xs: _filterWidgets.reversed,
                md: _filterWidgets,
              ),
            ],
          ),
        ),
        Divider(height: 0, color: _theme.colorScheme.outline),

        // Product Grid Layout
        Padding(
          padding: EdgeInsets.all(padding),
          child: const ProductGridView(),
        ),
      ],
    );
  }

  Widget _buildDataTable(BuildContext context) {
    final _theme = Theme.of(context);
    return LayoutBuilder(
      builder: (_, constraints) {
        final _styleColums = _theme.textTheme.bodyMedium;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: responsiveValue<double>(context, xs: 280, md: 380),
            ),
            child: DataTable(
              headingTextStyle: _theme.textTheme.titleMedium,
              dataTextStyle: _theme.textTheme.bodySmall,
              headingRowColor: WidgetStateProperty.all(
                _theme.colorScheme.surface,
              ),
              showBottomBorder: true,
              columns: [
                DataColumn(label: Text(l.S.current.product)),
                DataColumn(label: Text(l.S.current.qty)),
                DataColumn(label: Text(l.S.current.price)),
                DataColumn(label: Text(l.S.current.subTotal)),
                DataColumn(label: Text(l.S.current.action)),
              ],
              rows: _currentPageData.map(
                (data) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(data.product, style: _styleColums),
                      ),
                      const DataCell(CounterWidget()),
                      DataCell(
                        Text(data.price, style: _styleColums),
                      ),
                      DataCell(
                        Text(data.subtotal, style: _styleColums),
                      ),
                      DataCell(
                        CloseButton(
                          color: _theme.colorScheme.error,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  );
                },
              ).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOverviewAction(BuildContext context) {
    final _theme = Theme.of(context);
    final _lang = l.S.of(context);

    final _labelStyle = _theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w500,
    );

    return ResponsiveGridRow(
      children: [
        ResponsiveGridCol(
          md: 4,
          child: Text(
            // 'Total Item : 2',
            '${l.S.current.totalItem} : 2',
            style: _theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ResponsiveGridCol(
          md: 8,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                SizedBox(
                  height: responsiveValue<double>(
                    context,
                    xs: 0,
                    lg: 50,
                  ),
                ),

                // Sub Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        //'Sub Total',
                        _lang.subTotal,
                        style: _labelStyle,
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints.tightFor(
                        width: 200,
                        height: 40,
                      ),
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        color: AcnooAppColors.kWarning,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          intl.NumberFormat.simpleCurrency().format(48),
                          style: _theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),

                // Shipping
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        _lang.shipping,
                        // 'Shipping',
                        style: _labelStyle,
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(width: 200),
                      child: TextFormField(
                        textAlign: TextAlign.end,
                        initialValue:
                            intl.NumberFormat.simpleCurrency().format(6),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),

                // Tax
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        _lang.tax,
                        // 'Tax',
                        style: _labelStyle,
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(width: 200),
                      child: TextFormField(
                        textAlign: TextAlign.end,
                        initialValue:
                            intl.NumberFormat.simpleCurrency().format(6),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),

                // Discount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        _lang.discount,
                        // 'Discount',
                        style: _labelStyle,
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(width: 200),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildPillTextField(
                              context,
                              color: AcnooAppColors.kWarning,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildPillTextField(
                              context,
                              color: AcnooAppColors.kSuccess,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        ...[
          // Cancel Button
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: _theme.colorScheme.error),
              foregroundColor: _theme.colorScheme.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Text(_lang.cancel),
          ),

          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AcnooAppColors.kWarning,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Text(_lang.quotation),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Text(_lang.payment),
          ),
        ].asMap().entries.map((entry) {
          return ResponsiveGridCol(
            md: 4,
            xs: entry.key == 0 ? 12 : 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: entry.value,
            ),
          );
        })
      ],
    );
  }

  Widget _buildPillTextField(BuildContext context, {Color? color}) {
    final _border = OutlineInputBorder(
      borderSide: BorderSide(
        color: color ?? Colors.red,
      ),
    );

    final _currencySymbol = intl.NumberFormat.simpleCurrency().currencySymbol;
    return TextFormField(
      textAlign: TextAlign.end,
      decoration: InputDecoration(
        focusedBorder: _border,
        enabledBorder: _border,
        hintText: '0',
        prefixIconConstraints: BoxConstraints.tight(const Size(35, 40)),
        prefixIcon: Container(
          constraints: BoxConstraints.tight(const Size.fromHeight(50)),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadiusDirectional.horizontal(
              start: Radius.circular(6),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            _currencySymbol,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).inputDecorationTheme.hintStyle?.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}

// Mock Model & Data
class SaleProductModel {
  final String product;
  final String price;
  final String subtotal;

  SaleProductModel({
    required this.product,
    required this.price,
    required this.subtotal,
  });

  @override
  String toString() =>
      'DataModel(product: $product, price: $price, subtotal: $subtotal, )';
}

List<SaleProductModel> allSale = [
  SaleProductModel(product: 'Cabbage', price: '\$30.00', subtotal: '\$30.00'),
  SaleProductModel(product: 'Bananas', price: '\$30.00', subtotal: '\$30.00'),
  SaleProductModel(product: 'Bananas', price: '\$30.00', subtotal: '\$30.00'),
  SaleProductModel(product: 'Bananas', price: '\$30.00', subtotal: '\$30.00'),
  SaleProductModel(product: 'Bananas', price: '\$30.00', subtotal: '\$30.00'),
  SaleProductModel(product: 'Bananas', price: '\$30.00', subtotal: '\$30.00'),
  SaleProductModel(product: 'Bananas', price: '\$30.00', subtotal: '\$30.00'),
  SaleProductModel(product: 'Bananas', price: '\$30.00', subtotal: '\$30.00'),
  SaleProductModel(product: 'Bananas', price: '\$30.00', subtotal: '\$30.00'),
  SaleProductModel(product: 'Bananas', price: '\$30.00', subtotal: '\$30.00'),
  SaleProductModel(product: 'Bananas', price: '\$30.00', subtotal: '\$30.00'),
  SaleProductModel(product: 'Bananas', price: '\$30.00', subtotal: '\$30.00'),
];
