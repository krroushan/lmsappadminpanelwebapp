// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:intl/intl.dart';

// 🌎 Project imports:
import '../../../../../../generated/l10n.dart' as l;
import '../../../../../core/theme/theme.dart';

class RecentSalesTable extends StatefulWidget {
  const RecentSalesTable({super.key});

  @override
  State<RecentSalesTable> createState() => _RecentSalesTableState();
}

class _RecentSalesTableState extends State<RecentSalesTable> {
  late final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;

    const _columnWidths = <int, double>{
      0: 60 / 1.5, //FixedColumnWidth(60), //60,
      1: 165 / 1.5, //FixedColumnWidth(165), //165,
      2: 165 / 1.5, //FixedColumnWidth(165), //165,
      3: 275 / 1.5, //FixedColumnWidth(275), //275,
      4: 205 / 1.5, //FixedColumnWidth(205), //205,
      5: 180 / 1.5, //FixedColumnWidth(180), //180,
      6: 180 / 1.5, //FixedColumnWidth(180), //180,
      7: 190 / 1.5, //FixedColumnWidth(190), //190,
      8: 150 / 1.5, //FixedColumnWidth(150), //150,
    };

    final _cellStyle = _theme.textTheme.bodyMedium;

    return LayoutBuilder(
      builder: (context, constraints) {
        final lang = l.S.of(context);
        return Scrollbar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Theme(
                data: _theme.copyWith(
                  dividerTheme: _theme.dividerTheme.copyWith(
                    color: _theme.colorScheme.outline,
                  ),
                ),
                child: DataTable(
                  headingTextStyle: _theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  headingRowColor: WidgetStateProperty.all<Color?>(
                    const Color(0xffF8F1FF).withOpacity(_isDark ? 0.15 : 1),
                  ),
                  dividerThickness: 0,
                  border: const TableBorder(
                    horizontalInside: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  columns: [
                    "${lang.SL}.",
                    //"Date",
                    lang.date,
                    //"Invoice",
                    lang.invoice,
                    //"Party Name",
                    lang.partyName,
                    //"Payment Type",
                    lang.paymentType,
                    //"Amount",
                    lang.amount,
                   // "Paid",
                    lang.paid,
                   // "Due",
                    lang.due,
                    //"Status",
                    lang.status,
                  ].asMap().entries.map((column) {
                    final _width = _columnWidths[column.key];
                    return DataColumn(
                      numeric: switch (column.key) {
                        5 || 6 || 7 => true,
                        _ => false,
                      },
                      label: Container(
                        width: _width,
                        alignment: Alignment.center,
                        child: Text(column.value),
                      ),
                    );
                  }).toList(),
                  rows: _data.asMap().entries.map((entry) {
                    final _row = entry.value;

                    final _cells = <String>[
                      (entry.key + 1).toString(),
                      _row.$1,
                      _row.$2,
                      _row.$3,
                      _row.$4,
                      NumberFormat.simpleCurrency().format(_row.$5),
                      NumberFormat.simpleCurrency().format(_row.$6),
                      NumberFormat.simpleCurrency().format(_row.$7),
                      _row.$8,
                    ];

                    return DataRow(
                        cells: List.generate(
                      _cells.length,
                      (index) {
                        final _isLastCol = _cells.length - 1 == index;
                        final _text = _cells[index];
                        return DataCell(
                          Container(
                            width: _columnWidths[index],
                            alignment: Alignment.center,
                            child: Text(
                              _text,
                              style: _cellStyle?.copyWith(
                                color: !_isLastCol
                                    ? null
                                    : switch (_text) {
                                        'Paid' => AcnooAppColors.kSuccess,
                                        'Unpaid' => AcnooAppColors.kError,
                                        _ => null,
                                      },
                              ),
                            ),
                          ),
                        );
                      },
                    ));
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

List<(String, String, String, String, int, double, double, String)>get _data => [
  (
    "25 Jun 2024",
    "52631",
    //"Esther Howard",
  l.S.current.estherHoward,
    //"Cash",
  l.S.current.cash,
  500,
    500.00,
    0.00,
    //"Paid",
  l.S.current.paid,
  ),
  (
    "25 Jun 2024",
    "52632",
    //"Jerome Bell",
  l.S.current.jeromeBell,
   // "Cash",
  l.S.current.cash,
    500,
    0.00,
    500.00,
    //"Unpaid",
  l.S.current.unpaid,
  ),
  (
    "25 Jun 2024",
    "52633",
   // "Marvin McKinney",
  l.S.current.marvinMcKinney,
   l.S.current.cash,
   // "Cash",
    500,
    500.00,
    0.00,
    //"Paid",
  l.S.current.paid,
  ),
  (
    "25 Jun 2024",
    "52634",
    //"Kathryn Murphy",
  l.S.current.kathrynMurphy,
    //"Cash",
  l.S.current.cash,
    500,
    0.00,
    500.00,
    //"Unpaid",
  l.S.current.unpaid,
  ),
  (
    "25 Jun 2024",
    "52635",
    //"Floyd Miles",
  l.S.current.floydMiles,
   // "Cash",
  l.S.current.cash,
    500,
    500.00,
    0.00,
    //"Paid",
  l.S.current.paid,
  ),
];
