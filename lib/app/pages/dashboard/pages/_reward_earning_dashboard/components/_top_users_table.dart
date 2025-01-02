// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:intl/intl.dart';

// 🌎 Project imports:
import 'package:acnoo_flutter_admin_panel/generated/l10n.dart' as l;
import '../../../../../models/models.dart' as model;
import '../../../../../widgets/widgets.dart';

class TopUsersTable extends StatefulWidget {
  const TopUsersTable({super.key});

  @override
  State<TopUsersTable> createState() => _TopUsersTableState();
}

class _TopUsersTableState extends State<TopUsersTable> {
  late final scrollController = ScrollController();

  final _otherDetails = [
    ("simmons@example.com", "(405) 555-0128", 575),
    ("jennings@example.com", "(207) 555-0119", 575),
    ("chambers@example.com", "(303) 555-0105", 575),
    ("baker@example.com", "(209) 555-0104", 575),
    ("lawson@example.com", "(219) 555-0114", 575),
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
      0: 20, //FixedColumnWidth(60), //60,
      1: 50, //FixedColumnWidth(165), //165,
      2: 120, //FixedColumnWidth(165), //165,
      3: 180, //FixedColumnWidth(275), //275,
      4: 120, //FixedColumnWidth(205), //205,
      5: 60, //FixedColumnWidth(180), //180,
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
                   lang.image,
                   lang.name,
                   lang.email,
                    lang.phone,
                    lang.balance,
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
                        Padding(
                          padding: const EdgeInsetsDirectional.all(8.0),
                          child: AvatarWidget(
                            imagePath: e.value.influencerImage,
                            fit: BoxFit.cover,
                          ),
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
                          NumberFormat.simpleCurrency(
                            decimalDigits: 0,
                          ).format(_otherDetails[e.key].$3),
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
                              alignment: AlignmentDirectional.center,
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
