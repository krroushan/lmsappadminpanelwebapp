// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:intl/intl.dart';

// 🌎 Project imports:
import '../../../../../../generated/l10n.dart' as l;
import '../../../../../models/models.dart' as model;
import '../../../../../widgets/widgets.dart';

class TopDeliveryManTable extends StatefulWidget {
  const TopDeliveryManTable({super.key});

  @override
  State<TopDeliveryManTable> createState() => _TopDeliveryManTableState();
}

class _TopDeliveryManTableState extends State<TopDeliveryManTable> {
  late final scrollController = ScrollController();

  final _otherDetails = [
    ("Leslie Alexander", 50),
    ("Ralph Edwards", 70),
    ("Courtney Henry", 60),
    ("Arlene McCoy", 80),
    ("Kristin Watson", 120),
  ];

  bool _isHovering = false;
  int _hoveringIndex = -1;

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
      0: 56, //FixedColumnWidth(60), //60,
      1: 175, //FixedColumnWidth(165), //165,
      2: 120, //FixedColumnWidth(275), //275,
      3: 50, //FixedColumnWidth(205), //205,
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
                    lang.image,
                    lang.name,
                    lang.orderCompleted,
                    lang.action,
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
                      final _details = _otherDetails[e.key];

                      final _cells = <Widget>[
                        AvatarWidget(
                          imagePath: e.value.influencerImage,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          _details.$1,
                          style: _cellStyle,
                        ),
                        Text(
                          NumberFormat.currency(
                            decimalDigits: 0,
                            symbol: '',
                          ).format(_details.$2),
                          style: _cellStyle,
                        ),
                        Text.rich(
                          TextSpan(
                            text: '${lang.view} >',
                            onEnter: (event) {
                              setState(() {
                                _isHovering = true;
                                _hoveringIndex = e.key;
                              });
                            },
                            onExit: (event) {
                              setState(() {
                                _isHovering = false;
                                _hoveringIndex = -1;
                              });
                            },
                            mouseCursor: SystemMouseCursors.click,
                          ),
                          style: _theme.textTheme.bodyMedium?.copyWith(
                            color: _isHovering && (_hoveringIndex == e.key)
                                ? _theme.colorScheme.primary
                                : _theme.colorScheme.onTertiaryContainer,
                          ),
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
                        ),
                      );
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
