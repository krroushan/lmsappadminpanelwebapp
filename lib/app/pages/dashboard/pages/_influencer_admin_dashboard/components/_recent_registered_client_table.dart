// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:intl/intl.dart';

// 🌎 Project imports:
import '../../../../../../generated/l10n.dart' as l;
import '../../../../../core/static/static.dart';
import '../../../../../models/models.dart' as model;

class RecentRegisteredClientTable extends StatefulWidget {
  const RecentRegisteredClientTable({super.key});

  @override
  State<RecentRegisteredClientTable> createState() =>
      _RecentRegisteredClientTableState();
}

class _RecentRegisteredClientTableState
    extends State<RecentRegisteredClientTable> {
  late final scrollController = ScrollController();

  final _otherDetails = [
    ("simmons@example.com", "United States", 10),
    ("jennings@example.com", "India", 10),
    ("chambers@example.com", "Bangladesh", 10),
    ("baker@example.com", "France", 10),
    ("lawson@example.com", "Italy", 10),
  ];

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    const _columnWidths = <int, double>{
      0: 24, //FixedColumnWidth(60), //60,
      1: 125, //FixedColumnWidth(165), //165,
      2: 120, //FixedColumnWidth(165), //165,
      3: 180, //FixedColumnWidth(275), //275,
      4: 120, //FixedColumnWidth(205), //205,
      5: 80, //FixedColumnWidth(180), //180,
    };

    final _cellStyle = _theme.textTheme.bodyMedium;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scrollbar(
          controller: scrollController,
          child: SingleChildScrollView(
            padding: const EdgeInsetsDirectional.only(bottom: 16),
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
                    "${lang.SL}.",
                   // "Join Date",
                    lang.joinDate,
                    lang.name,
                    lang.email,
                    lang.country,
                    lang.orderDone,
                    //"Order Done",
                  ].asMap().entries.map((column) {
                    final _width = _columnWidths[column.key];
                    return DataColumn(
                      numeric: switch (column.key) {
                        5 || 6 || 7 => true,
                        _ => false,
                      },
                      label: Container(
                        width: _width,
                        alignment: column.key == 5
                            ? AlignmentDirectional.center
                            : AlignmentDirectional.centerStart,
                        child: Text(column.value),
                      ),
                    );
                  }).toList(),
                  rows: model.MaanDemoGig.usersList
                      .take(5)
                      .toList()
                      .asMap()
                      .entries
                      .map(
                    (e) {
                      final _cells = <Widget>[
                        Text(
                          (e.key + 1).toString(),
                          style: _cellStyle,
                        ),
                        Text(
                          DateFormat(AppDateConfig.appMonthNameDateFormat)
                              .format(DateTime.now()),
                          style: _cellStyle,
                        ),
                        Text(
                          e.value.influencerName,
                          style: _cellStyle,
                        ),
                        Text(
                          _otherDetails[e.key].$1,
                          style: _cellStyle,
                        ),
                        Text(
                          _otherDetails[e.key].$2,
                          style: _cellStyle,
                        ),
                        Text(
                          '${_otherDetails[e.key].$3}',
                          style: _cellStyle,
                        ),
                      ];
                      return DataRow(
                          cells: List.generate(
                        _cells.length,
                        (index) {
                          final _child = _cells[index];
                          return DataCell(
                            Container(
                              width: _columnWidths[index],
                              alignment: index == 5
                                  ? AlignmentDirectional.center
                                  : AlignmentDirectional.centerStart,
                              child: _child,
                            ),
                          );
                        },
                      ));
                    },
                  ).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
