import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../core/helpers/helpers.dart';
import '../../../core/static/static.dart';
import '../../../core/theme/theme.dart';
import '../../../widgets/widgets.dart';
import '../demo_data/demo_purchase.dart';
import 'components/components.dart';
import '../../../../generated/l10n.dart' as l;

class POSPurchaseView extends StatefulWidget {
  const POSPurchaseView({super.key});

  @override
  State<POSPurchaseView> createState() => _POSPurchaseViewState();
}

class _POSPurchaseViewState extends State<POSPurchaseView> {
  late List<Purchase> _filteredData;
  final List<Purchase> users = AllSale.allSale;
  final int _currentPage = 0;
  final int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _filteredData = List.from(users);
  }

  List<Purchase> get _currentPageData {
    _filteredData = List.from(users);

    int start = _currentPage * _rowsPerPage;
    int end = start + _rowsPerPage;
    return _filteredData.sublist(
        start, end > _filteredData.length ? _filteredData.length : end);
  }

  final TextEditingController _dateController = TextEditingController();

  String? selectedProduct;
  List<String> get product => [
        l.S.current.banana,
        l.S.current.mango,
        l.S.current.watch,
        l.S.current.mobile,
        l.S.current.bag
      ];
  String? selectwarehouse;
  List<String> get warehouse => [
        '${l.S.current.warehouse} 1',
        '${l.S.current.warehouse} 2',
        '${l.S.current.warehouse} 3',
        '${l.S.current.warehouse} 4',
        '${l.S.current.warehouse} 5',
        '${l.S.current.warehouse} 6',
        '${l.S.current.warehouse} 7'
      ];
  String? selectedSupplier;
  List<String> get suppliers => [
        '${l.S.current.supplier} 1',
        '${l.S.current.supplier} 2',
        '${l.S.current.supplier} 3'
      ];

  @override
  Widget build(BuildContext context) {
    final _dropdownStyle = AcnooDropdownStyle(context);
    final _innerSpacing = responsiveValue<double>(
      context,
      xs: 16,
      lg: 24,
    );
    final _mqSize = MediaQuery.sizeOf(context);
    final _isDesktop = _mqSize.width >= 992;

    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      md: _isDesktop ? 24 : 16,
      lg: 24,
    );
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final textTheme = _theme.textTheme;
    final style = _theme.textTheme.bodyMedium?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
    final styleColums = _theme.textTheme.bodyMedium?.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w400,
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: ShadowContainer(
          contentPadding: EdgeInsets.zero,
          // headerText: 'Add New Purchase',
          headerText: lang.addNewPurchase,
          margin: EdgeInsets.all(_padding / 2.5),
          child: ResponsiveGridRow(
            children: [
              ResponsiveGridCol(
                child: Builder(
                  builder: (context) {
                    final _content = <ResponsiveGridCol>[
                      ////////////////  Supplier /////////////////

                      ResponsiveGridCol(
                        lg: 4,
                        md: 4,
                        xs: 12,
                        child: Padding(
                          padding: EdgeInsetsDirectional.all(
                            _innerSpacing / 2.5,
                          ),
                          child: DropdownButtonFormField2<String>(
                            style: _dropdownStyle.textStyle,
                            hint: Text(
                              lang.selectASupplier,
                              //'Select a supplier',
                              style: textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            decoration: InputDecoration(
                              suffixIconConstraints:
                                  const BoxConstraints.tightFor(width: 48),
                              suffixIcon: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadiusDirectional.horizontal(
                                      end: Radius.circular(6),
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Center(
                                  child: Icon(
                                    Icons.add,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            iconStyleData: _dropdownStyle.iconStyle,
                            buttonStyleData: _dropdownStyle.buttonStyle,
                            dropdownStyleData: _dropdownStyle.dropdownStyle,
                            menuItemStyleData: _dropdownStyle.menuItemStyle,
                            isExpanded: true,
                            value: selectedSupplier,
                            items: suppliers.map(
                              (supplier) {
                                return DropdownMenuItem(
                                  value: supplier,
                                  child: Text(supplier),
                                );
                              },
                            ).toList(),
                            onChanged: (value) {
                              setState(
                                () {
                                  selectedSupplier = value;
                                },
                              );
                            },
                          ),
                        ),
                      ),

                      ////////////////  Invoice /////////////////

                      ResponsiveGridCol(
                        lg: 4,
                        md: 4,
                        xs: 6,
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.all(_innerSpacing / 2.5),
                          child: TextFormField(
                            decoration: InputDecoration(
                              //hintText: 'Ex:25411',
                              hintText: lang.Ex25411,

                              ///labelText: 'Invoice No.',
                              labelText: '${lang.invoiceNo}.',
                              labelStyle: textTheme.bodySmall?.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      ////////////////  Date  /////////////////

                      ResponsiveGridCol(
                        lg: 4,
                        md: 4,
                        xs: 6,
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.all(_innerSpacing / 2.5),
                          child: TextFormField(
                            controller: _dateController,
                            keyboardType: TextInputType.visiblePassword,
                            readOnly: true,
                            selectionControls: EmptyTextSelectionControls(),
                            decoration: InputDecoration(
                              labelText: l.S.of(context).date,
                              labelStyle: textTheme.bodySmall?.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              hintText: 'mm/dd/yyyy',
                              suffixIcon:
                                  const Icon(IconlyLight.calendar, size: 20),
                            ),
                            onTap: () async {
                              final _result = await showDatePicker(
                                context: context,
                                firstDate: AppDateConfig.appFirstDate,
                                lastDate: AppDateConfig.appLastDate,
                                initialDate: DateTime.now(),
                                builder: (context, child) => Theme(
                                  data: _theme.copyWith(
                                    datePickerTheme: DatePickerThemeData(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                ),
                              );

                              if (_result != null) {
                                _dateController.text = DateFormat(
                                  AppDateConfig.appNumberOnlyDateFormat,
                                ).format(_result);
                              }
                            },
                          ),
                        ),
                      ),
                    ];
                    return ResponsiveGridRow(
                      children: [
                        if (responsiveValue<bool>(context, xs: true, md: false))
                          ..._content.reversed
                        else
                          ..._content
                      ],
                    );
                  },
                ),
              ),
              ResponsiveGridCol(
                child: Builder(
                  builder: (context) {
                    final _content2 = <ResponsiveGridCol>[
                      ////////////////  Product Name /////////////////

                      ResponsiveGridCol(
                        lg: 8,
                        md: 8,
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.all(_innerSpacing / 2.5),
                          child: DropdownButtonFormField2<String>(
                            style: _dropdownStyle.textStyle,
                            hint: Text(
                              lang.searchProductByName,
                              //'Search product by name',
                              style: textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            decoration: InputDecoration(
                              suffixIconConstraints:
                                  const BoxConstraints.tightFor(width: 48),
                              suffixIcon: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadiusDirectional.horizontal(
                                      end: Radius.circular(6),
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Center(
                                  child: Icon(
                                    Icons.add,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            iconStyleData: _dropdownStyle.iconStyle,
                            buttonStyleData: _dropdownStyle.buttonStyle,
                            dropdownStyleData: _dropdownStyle.dropdownStyle,
                            menuItemStyleData: _dropdownStyle.menuItemStyle,
                            isExpanded: true,
                            value: selectedProduct,
                            items: product.map(
                              (product) {
                                return DropdownMenuItem(
                                  value: product,
                                  child: Text(product),
                                );
                              },
                            ).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedProduct = value;
                              });
                            },
                          ),
                        ),
                      ),

                      ////////////////  Warehouse  /////////////////

                      ResponsiveGridCol(
                        lg: 4,
                        md: 4,
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.all(_innerSpacing / 2.5),
                          child: DropdownButtonFormField2<String>(
                            style: _dropdownStyle.textStyle,
                            hint: Text(
                              lang.selectAWarehouse,
                              //'Select a warehouse',
                              style: textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            iconStyleData: _dropdownStyle.iconStyle,
                            buttonStyleData: _dropdownStyle.buttonStyle,
                            dropdownStyleData: _dropdownStyle.dropdownStyle,
                            menuItemStyleData: _dropdownStyle.menuItemStyle,
                            isExpanded: true,
                            value: selectwarehouse,
                            items: warehouse.map(
                              (warehouse) {
                                return DropdownMenuItem(
                                  value: warehouse,
                                  child: Text(warehouse),
                                );
                              },
                            ).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectwarehouse = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ];
                    return ResponsiveGridRow(
                      children: [
                        if (responsiveValue<bool>(context, xs: true, md: false))
                          ..._content2.reversed
                        else
                          ..._content2
                      ],
                    );
                  },
                ),
              ),

              ///////////////// Data Table /////////////////

              ResponsiveGridCol(
                child: Padding(
                  padding: EdgeInsetsDirectional.all(_innerSpacing / 2.5),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                      ),
                      child: Theme(
                        data: _theme.copyWith(
                          dividerColor: _theme.colorScheme.outline,
                          dividerTheme: _theme.dividerTheme.copyWith(
                            color: _theme.colorScheme.outline,
                          ),
                        ),
                        child: DataTable(
                          checkboxHorizontalMargin: 16,
                          dataRowMaxHeight: 60,
                          border: TableBorder(
                            verticalInside: BorderSide(
                              color: _theme.colorScheme.outline,
                            ),
                          ),
                          headingTextStyle: textTheme.titleMedium,
                          dataTextStyle: textTheme.bodySmall,
                          headingRowColor: WidgetStateProperty.all(
                            _theme.colorScheme.surface,
                          ),
                          showBottomBorder: true,
                          columns: [
                            //"Image",
                            lang.image,
                            //"Items",
                            lang.items,
                            //"Code",
                            lang.code,
                            // "Unit",
                            lang.unit,
                            //"Sale Price",
                            lang.salePrice,
                            //"Qty",
                            lang.qty,
                            //"Discount",
                            lang.discount,
                            //"Tax",
                            lang.tax,
                            //"Sub Total",
                            lang.subTotal,
                            //"Action",
                            lang.action,
                          ].map((column) {
                            return DataColumn(
                              label: Text(column, style: style),
                            );
                          }).toList(),
                          rows: _currentPageData.map(
                            (product) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    SizedBox.fromSize(
                                      size: const Size(44, 40),
                                      child: Image.asset(
                                        product.image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      product.items,
                                      style: styleColums,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      product.code,
                                      style: styleColums,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      product.unit,
                                      style: styleColums,
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        product.salePrice,
                                        style: styleColums,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    QuantityButton(product: product),
                                  ),
                                  const DataCell(
                                    DiscountTextField(),
                                  ),
                                  const DataCell(
                                    TaxTextField(),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        product.subTotal,
                                        style: styleColums,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    CloseButton(
                                      color: AcnooAppColors.kPrimary700,
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /////////////// TextField ////////////////

              ResponsiveGridCol(
                lg: 8,
                md: 8,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: responsiveValue(context, xs: 20, md: 20, lg: 118)),
                  child: const Field(),
                ),
              ),

              ///////////////// Total Amount ///////////////

              ResponsiveGridCol(
                lg: 4,
                md: 4,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: responsiveValue<double>(context,
                          xs: 20, md: 28, lg: 126)),
                  child: const Amount(),
                ),
              ),

              /////////////////  Cancel & Submit Button ////////////////

              ResponsiveGridCol(
                child: Container(
                  constraints: BoxConstraints.loose(
                    const Size.fromHeight(48),
                  ),
                  margin: const EdgeInsets.only(top: 36),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 10),
                          child: SizedBox.fromSize(
                            size: const Size(175, double.maxFinite),
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                foregroundColor: AcnooAppColors.kError,
                                side: const BorderSide(
                                  color: AcnooAppColors.kError,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              //child: const Text('Cancel'),
                              child: Text(lang.cancel),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, bottom: 10),
                          child: SizedBox.fromSize(
                            size: const Size(175, double.maxFinite),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              //child: const Text('Submit'),
                              child: Text(lang.submit),
                            ),
                          ),
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
    );
  }
}
