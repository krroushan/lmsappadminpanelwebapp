// 🎯 Dart imports:
// ignore_for_file: library_private_types_in_public_api

// 🐦 Flutter imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:iconly/iconly.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../core/helpers/helpers.dart';
import '../../../core/theme/_app_colors.dart';
import '../../../widgets/widgets.dart';
import '../demo_data/demo_data_sell_list.dart';

class POSSaleListView extends StatefulWidget {
  const POSSaleListView({super.key});

  @override
  State<POSSaleListView> createState() => _POSSaleListViewState();
}

class _POSSaleListViewState extends State<POSSaleListView> {
  ///_____________________________________________________________________Variables_______________________________
  late List<DemoData> _filteredData;
  final ScrollController _scrollController = ScrollController();
  final List<DemoData> users = AllSale.allSale;
  int _currentPage = 0;
  int _rowsPerPage = 10;
  String _searchQuery = '';
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _filteredData = List.from(users);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ///_____________________________________________________________________data__________________________________
  List<DemoData> get _currentPageData {
    if (_searchQuery.isNotEmpty) {
      _filteredData = users
          .where(
            (data) =>
                data.customer
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                data.invoice
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                data.warehouse.contains(
                  _searchQuery,
                ),
          )
          .toList();
    } else {
      _filteredData = List.from(users);
    }

    int start = _currentPage * _rowsPerPage;
    int end = start + _rowsPerPage;
    return _filteredData.sublist(
        start, end > _filteredData.length ? _filteredData.length : end);
  }

  ///_____________________________________________________________________Search_query_________________________
  void _setSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _currentPage = 0; // Reset to the first page when searching
    });
  }

  @override
  Widget build(BuildContext context) {
    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 480,
          value: _SizeInfo(
            alertFontSize: 12,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 481,
          end: 576,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 577,
          end: 992,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;

    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: _sizeInfo.padding,
        child: ShadowContainer(
          showHeader: false,
          contentPadding: EdgeInsets.zero,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final isMobile = constraints.maxWidth < 481;
                final isTablet =
                    constraints.maxWidth < 992 && constraints.maxWidth >= 481;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //______________________________________________________________________Header__________________
                    isMobile
                        ? Padding(
                            padding: _sizeInfo.padding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: showingValueDropDown(
                                          isTablet: isTablet,
                                          isMobile: isMobile,
                                          textTheme: textTheme),
                                    ),
                                    const Spacer(),
                                    addSales(textTheme, context),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                searchFormField(textTheme: textTheme),
                              ],
                            ),
                          )
                        : Padding(
                            padding: _sizeInfo.padding,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: showingValueDropDown(
                                      isTablet: isTablet,
                                      isMobile: isMobile,
                                      textTheme: textTheme),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  flex: isTablet || isMobile ? 2 : 3,
                                  child: searchFormField(textTheme: textTheme),
                                ),
                                Spacer(flex: isTablet || isMobile ? 1 : 2),
                                addSales(textTheme, context),
                              ],
                            ),
                          ),

                    //______________________________________________________________________Data_table__________________
                    isMobile || isTablet
                        ? RawScrollbar(
                            padding: const EdgeInsets.only(left: 18),
                            trackBorderColor: theme.colorScheme.surface,
                            trackVisibility: true,
                            scrollbarOrientation: ScrollbarOrientation.bottom,
                            controller: _scrollController,
                            thumbVisibility: true,
                            thickness: 8.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleChildScrollView(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: constraints.maxWidth,
                                    ),
                                    child: userListDataTable(context),
                                  ),
                                ),
                                Padding(
                                  padding: _sizeInfo.padding,
                                  child: Text(
                                    '${l.S.of(context).showing} ${_currentPage * _rowsPerPage + 1} ${l.S.of(context).to} ${_currentPage * _rowsPerPage + _currentPageData.length} ${l.S.of(context).OF} ${_filteredData.length} ${l.S.of(context).entries}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth,
                              ),
                              child: userListDataTable(context),
                            ),
                          ),

                    //______________________________________________________________________footer__________________
                    isTablet || isMobile
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: _sizeInfo.padding,
                            child: paginatedSection(theme, textTheme),
                          ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  ///_____________________________________________________________________add_user_button___________________________
  ElevatedButton addSales(TextTheme textTheme, BuildContext context) {
    final lang = l.S.of(context);
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () {},
      label: Text(
        lang.addSales,
        // 'Add Sales',
        style: textTheme.bodySmall?.copyWith(
          color: AcnooAppColors.kWhiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconAlignment: IconAlignment.start,
      icon: const Icon(
        Icons.add_circle_outline_outlined,
        color: AcnooAppColors.kWhiteColor,
        size: 20.0,
      ),
    );
  }

  ///_____________________________________________________________________pagination_functions_______________________
  int get _totalPages => (_filteredData.length / _rowsPerPage).ceil();

  ///_____________________________________select_dropdown_val_________
  void _setRowsPerPage(int value) {
    setState(() {
      _rowsPerPage = value;
      _currentPage = 0;
    });
  }

  ///_____________________________________go_next_page________________
  void _goToNextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() {
        _currentPage++;
      });
    }
  }

  ///_____________________________________go_previous_page____________
  void _goToPreviousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  ///_______________________________________________________________pagination_footer_______________________________
  Row paginatedSection(ThemeData theme, TextTheme textTheme) {
    final lang = l.S.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '${lang.showing} ${_currentPage * _rowsPerPage + 1} ${lang.to} ${_currentPage * _rowsPerPage + _currentPageData.length} ${lang.OF} ${_filteredData.length} ${lang.entries}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataTablePaginator(
          currentPage: _currentPage + 1,
          totalPages: _totalPages,
          onPreviousTap: _goToPreviousPage,
          onNextTap: _goToNextPage,
        )
      ],
    );
  }

  ///_______________________________________________________________Search_Field___________________________________
  TextFormField searchFormField({required TextTheme textTheme}) {
    final lang = l.S.of(context);
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
        hintText: '${lang.search}...',
        hintStyle: textTheme.bodySmall,
        suffixIcon: Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: AcnooAppColors.kPrimary700,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child:
              const Icon(IconlyLight.search, color: AcnooAppColors.kWhiteColor),
        ),
      ),
      onChanged: (value) {
        _setSearchQuery(value);
      },
    );
  }

  ///_______________________________________________________________DropDownList___________________________________
  Container showingValueDropDown(
      {required bool isTablet,
      required bool isMobile,
      required TextTheme textTheme}) {
    final _dropdownStyle = AcnooDropdownStyle(context);
    //final theme = Theme.of(context);
    final lang = l.S.of(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 100, minWidth: 100),
      child: DropdownButtonFormField2<int>(
        style: _dropdownStyle.textStyle,
        iconStyleData: _dropdownStyle.iconStyle,
        buttonStyleData: _dropdownStyle.buttonStyle,
        dropdownStyleData: _dropdownStyle.dropdownStyle,
        menuItemStyleData: _dropdownStyle.menuItemStyle,
        isExpanded: true,
        value: _rowsPerPage,
        items: [10, 20, 30, 40, 50].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(
              //isTablet || isMobile ? '$value' :
              '${lang.show} $value',
              style: textTheme.bodySmall,
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            _setRowsPerPage(value);
          }
        },
      ),
    );
  }

  ///_______________________________________________________________User_List_Data_Table___________________________
  Theme userListDataTable(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final lang = l.S.of(context);
    final style = theme.textTheme.bodyMedium?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
    final styleColums = theme.textTheme.bodyMedium?.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w400,
    );
    return Theme(
      data: theme.copyWith(
          dividerColor: theme.colorScheme.outline,
          dividerTheme: DividerThemeData(
            color: theme.colorScheme.outline,
          )),
      child: DataTable(
        checkboxHorizontalMargin: 16,
        headingTextStyle: textTheme.titleMedium,
        dataTextStyle: textTheme.bodySmall,
        headingRowColor: WidgetStateProperty.all(theme.colorScheme.surface),
        showBottomBorder: true,
        columns: [
          DataColumn(
            label: Row(
              children: [
                Checkbox(
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -4),
                  value: _selectAll,
                  onChanged: (value) {
                    _selectAllRows(value ?? false);
                  },
                ),
                const SizedBox(width: 12.0),
                Text('${lang.SL}.', style: style),
              ],
            ),
          ),
          DataColumn(
            label: Text(lang.date, style: style),
          ),
          DataColumn(
            label: Text(
              lang.invoice,
              //'Invoice',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              lang.customer,
              // 'Customer',
              style: style,
            ),
          ),
          DataColumn(
            label: Text(
              lang.warehouse,
              //'Warehouse',
              style: style,
            ),
          ),
          DataColumn(
            label: Text(
              lang.grandTotal,
              //'Grand Total',
              style: style,
            ),
          ),
          DataColumn(
            label: Text(
              lang.paid,
              //'Paid',
              style: style,
            ),
          ),
          DataColumn(
            label: Text(
              lang.due,
              //'Due',
              style: style,
            ),
          ),
          DataColumn(
            label: Text(
              lang.paymentType,
              // 'Payment Type',
              style: style,
            ),
          ),
          DataColumn(
            label: Text(
              lang.paymentStatus,
              //'Payment Status',
              style: style,
            ),
          ),
          DataColumn(
            label: Text(
              lang.salesBy,
              //'Sales By',
              style: style,
            ),
          ),
          DataColumn(
              label: Text(
            lang.action,
            // 'Action',
            style: style,
          )),
        ],
        rows: _currentPageData.map(
          (user) {
            return DataRow(
              cells: [
                DataCell(
                  Row(
                    children: [
                      Checkbox(
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                        value: user.isSelected,
                        onChanged: (selected) {
                          setState(() {
                            user.isSelected = selected ?? false;
                            _selectAll =
                                _currentPageData.every((d) => d.isSelected);
                          });
                        },
                      ),
                      const SizedBox(width: 12.0),
                      Text(user.id.toString())
                    ],
                  ),
                ),
                DataCell(
                  Text(
                    user.date,
                    style: styleColums,
                  ),
                ),
                DataCell(
                  Text(
                    user.invoice,
                    style: styleColums,
                  ),
                ),
                DataCell(
                  Text(
                    user.customer,
                    style: styleColums,
                  ),
                ),
                DataCell(
                  Text(
                    user.warehouse,
                    style: styleColums,
                  ),
                ),
                DataCell(
                  Center(
                    child: Text(
                      user.grandTotal,
                      style: styleColums,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    user.paid,
                    style: styleColums,
                  ),
                ),
                DataCell(Text(
                  user.due,
                  style: styleColums,
                )),
                DataCell(
                  Center(
                    child: Text(
                      user.paymentType,
                      style: styleColums,
                    ),
                  ),
                ),
                DataCell(Center(
                  child: Container(
                    height: 24,
                    decoration: BoxDecoration(
                        color: user.paymentStatus == 'Partial'
                            ? const Color(0xffAF52DE)
                            : user.paymentStatus == "Paid"
                                ? const Color(0xff34C759)
                                : const Color(0xffFF9500),
                        borderRadius: BorderRadius.circular(3)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 7, right: 7),
                      child: Text(
                        user.paymentStatus,
                        style: theme.textTheme.titleMedium?.copyWith(
                            color: AcnooAppColors.kWhiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                )),
                DataCell(
                  Center(
                    child: Text(
                      user.salesBy,
                      style: styleColums,
                    ),
                  ),
                ),
                const DataCell(
                  Center(
                    child: Icon(
                      Icons.more_vert,
                    ),
                  ),
                )
              ],
            );
          },
        ).toList(),
      ),
    );
  }

  ///_____________________________________________________________________Selected_datatable_________________________
  void _selectAllRows(bool select) {
    setState(() {
      for (var data in _currentPageData) {
        data.isSelected = select;
      }
      _selectAll = select;
    });
  }
}

class _SizeInfo {
  final double? alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  const _SizeInfo({
    this.alertFontSize = 18,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}
