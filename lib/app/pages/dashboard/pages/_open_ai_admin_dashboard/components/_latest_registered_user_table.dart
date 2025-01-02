// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:intl/intl.dart';

// 🌎 Project imports:
import 'package:acnoo_flutter_admin_panel/app/core/theme/theme.dart';
import '../../../../../../generated/l10n.dart' as l;
import '../../../../../core/static/static.dart';
import '../../../../../models/models.dart' as model;
import '../../../../../widgets/widgets.dart';

class LatestRegisteredUserTable extends StatefulWidget {
  const LatestRegisteredUserTable({super.key});

  @override
  State<LatestRegisteredUserTable> createState() =>
      _LatestRegisteredUserTableState();
}

class _LatestRegisteredUserTableState extends State<LatestRegisteredUserTable> {
  late final scrollController = ScrollController();

  List<(String, String, int)> get _otherDetails => [
        ("simmons@example.com", l.S.current.free, 575),
        ("jennings@example.com", l.S.current.basic, 575),
        ("chambers@example.com", l.S.current.standard, 575),
        ("baker@example.com", l.S.current.business, 575),
        ("lawson@example.com", l.S.current.enterprise, 575),
        ("simmons@example.com", l.S.current.free, 575),
        ("jennings@example.com", l.S.current.basic, 575),
        ("chambers@example.com", l.S.current.standard, 575),
        ("baker@example.com", l.S.current.business, 575),
        ("lawson@example.com", l.S.current.enterprise, 575),
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
      0: 230, //FixedColumnWidth(165), //165,
      1: 120, //FixedColumnWidth(165), //165,
      2: 180, //FixedColumnWidth(275), //275,
      3: 120, //FixedColumnWidth(205), //205,
      4: 60, //FixedColumnWidth(180), //180,
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
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Theme(
                  data: _theme.copyWith(
                    dividerTheme: _theme.dividerTheme.copyWith(
                      color: _theme.colorScheme.outline.withOpacity(0.75),
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
                    dataRowMinHeight: 56,
                    dataRowMaxHeight: 60,
                    border: const TableBorder(
                      horizontalInside: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    columns: [
                      lang.users,
                      lang.registeredOn,
                      // lang.email,
                      lang.plan,
                      lang.status,
                    ].asMap().entries.map((column) {
                      final _width = _columnWidths[column.key];
                      return DataColumn(
                        label: Container(
                          width: _width,
                          alignment: column.key == 0
                              ? AlignmentDirectional.centerStart
                              : AlignmentDirectional.center,
                          child: Text(column.value),
                        ),
                      );
                    }).toList(),
                    rows: model.MaanDemoGig.usersList
                        .take(10)
                        .toList()
                        .asMap()
                        .entries
                        .map(
                      (e) {
                        final _cells = <Widget>[
                          Row(
                            children: [
                              AvatarWidget(
                                imagePath: e.value.influencerImage,
                                size: const Size.square(40),
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      e.value.influencerName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: _cellStyle?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      _otherDetails[e.key].$1,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: _cellStyle?.copyWith(
                                        fontSize: 12,
                                        color: _theme
                                            .colorScheme.onTertiaryContainer,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Text(
                            DateFormat(AppDateConfig.appMonthNameDateFormat)
                                .format(DateTime.now()),
                            style: _cellStyle,
                          ),
                          Text(
                            _otherDetails[e.key].$2,
                            style: _cellStyle,
                          ),
                          Container(
                            padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AcnooAppColors.kSuccess20Op,
                              borderRadius: const BorderRadiusDirectional.all(
                                Radius.circular(16),
                              ),
                            ),
                            child: Text(
                              lang.active,
                              style: _cellStyle?.copyWith(
                                color: AcnooAppColors.kSuccess,
                              ),
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
          ),
        );
      },
    );
  }
}
