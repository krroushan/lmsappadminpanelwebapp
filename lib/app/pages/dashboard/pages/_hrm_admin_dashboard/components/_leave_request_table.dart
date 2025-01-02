// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/static/_static_values.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:intl/intl.dart' as intl;

// 🌎 Project imports:
import '../../../../../../generated/l10n.dart' as l;
import '../../../../../core/theme/theme.dart';

class LeaveRequestTable extends StatefulWidget {
  const LeaveRequestTable({super.key});

  @override
  State<LeaveRequestTable> createState() => _LeaveRequestTableState();
}

class _LeaveRequestTableState extends State<LeaveRequestTable> {
  late final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _lang = l.S.of(context);

    const _columnWidths = <int, double>{
      0: 24,
      1: 100,
      2: 165,
      3: 100,
      4: 100,
      5: 100,
      6: 80,
    };
    const _columnAlignments = <int, AlignmentGeometry>{
      0: AlignmentDirectional.centerStart,
      1: AlignmentDirectional.centerStart,
      2: AlignmentDirectional.centerStart,
      3: AlignmentDirectional.centerStart,
      4: AlignmentDirectional.centerStart,
      5: AlignmentDirectional.centerStart,
      6: AlignmentDirectional.centerStart,
    };

    final _cellStyle = _theme.textTheme.bodyMedium;

    return LayoutBuilder(
      builder: (context, constraints) {
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
                    _theme.colorScheme.tertiaryContainer,
                  ),
                  dividerThickness: 0,
                  border: const TableBorder(
                    horizontalInside: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  columns: [
                    "${_lang.SL}.",
                   // "Employee Id",
                    _lang.employeeId,
                    //"Employee Name",
                    _lang.employeeName,
                    //"From",
                    _lang.from,
                    //"To",
                    _lang.to,
                    //"Leave Duration",
                    _lang.leaveDuration,
                    // "Status",
                    _lang.status,
                  ].asMap().entries.map((column) {
                    final _width = _columnWidths[column.key];
                    final _alignment = _columnAlignments[column.key];
                    return DataColumn(
                      label: Container(
                        width: _width,
                        alignment: _alignment,
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
                      intl.DateFormat(AppDateConfig.appMonthNameDateFormat)
                          .format(_row.$3),
                      intl.DateFormat(AppDateConfig.appMonthNameDateFormat)
                          .format(_row.$4),
                      _row.$5,
                      _row.$6,
                    ];

                    return DataRow(
                        cells: List.generate(
                      _cells.length,
                      (index) {
                        final _isLastCol = _cells.length - 1 == index;
                        final _text = _cells[index];
                        final _alignment = _columnAlignments[index];

                        return DataCell(
                          Container(
                            width: _columnWidths[index],
                            alignment: _alignment,
                            child: Text(
                              _text,
                              style: _cellStyle?.copyWith(
                                color: !_isLastCol
                                    ? null
                                    : switch (_text) {
                                        'Approved' => AcnooAppColors.kSuccess,
                                        'Rejected' => AcnooAppColors.kError,
                                        'Pending' => AcnooAppColors.kWarning,
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

List<(String, String, DateTime, DateTime, String, String)> get _data {
  return [
    (
      "#236511",
      "Leslie Alexander",
      DateTime(2023),
      DateTime(2024),
      "2 ${l.S.current.days}",
      //"Pending",
    l.S.current.pending,
    ),
    (
      "#236511",
      "Ralph Edwards",
      DateTime(2023),
      DateTime(2024),
      "3 ${l.S.current.days}",
      //"Approved",
    l.S.current.approved,
    ),
    (
      "#236511",
      "Courtney Henry",
      DateTime(2023),
      DateTime(2024),
      "2 ${l.S.current.days}",
      //"Approved",
    l.S.current.approved,
    ),
    (
      "#236511",
      "Arlene McCoy",
      DateTime(2023),
      DateTime(2024),
      "2 ${l.S.current.days}",
      //"Rejected",
    l.S.current.rejected,
    ),
    (
      "#236511",
      "Kristin Watson",
      DateTime(2023),
      DateTime(2024),
      "2 ${l.S.current.days}",
      //"Approved",
      l.S.current.approved,
    ),
  ];
}
