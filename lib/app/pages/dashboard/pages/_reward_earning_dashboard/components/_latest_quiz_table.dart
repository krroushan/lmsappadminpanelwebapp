// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:intl/intl.dart';

// 🌎 Project imports:
import 'package:acnoo_flutter_admin_panel/generated/l10n.dart' as l;
import '../../../../../widgets/widgets.dart';

class LatestQuizTable extends StatefulWidget {
  const LatestQuizTable({super.key});

  @override
  State<LatestQuizTable> createState() => _LatestQuizTableState();
}

class _LatestQuizTableState extends State<LatestQuizTable> {
  late final scrollController = ScrollController();

  List<(String, String, int, DateTime)>get _data => [
    (
      "assets/images/static_images/placeholder_images/random_placeholders/placeholder_01.png",
      //"UPI Pay",
      l.S.current.UPIPay,
      1000,
      DateTime(2024, 09, 05, 15, 15),
    ),
    (
      "assets/images/static_images/placeholder_images/random_placeholders/placeholder_02.png",
      //"Sports",
      l.S.current.sports,
      15,
      DateTime(2024, 09, 05, 15, 15),
    ),
    (
      "assets/images/static_images/placeholder_images/random_placeholders/placeholder_03.png",
      //"Courses",
      l.S.current.courses,
      50,
      DateTime(2024, 09, 05, 15, 15),
    ),
    (
      "assets/images/static_images/placeholder_images/random_placeholders/placeholder_04.png",
      // "Music",
      l.S.current.music,
      40,
      DateTime(2024, 09, 05, 15, 15),
    ),
    (
      "assets/images/static_images/placeholder_images/random_placeholders/placeholder_05.png",
      // "Science ",
      l.S.current.science,
      300,
      DateTime(2024, 09, 05, 15, 15),
    ),
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
      0: 45, //FixedColumnWidth(60), //60,
      1: 65, //FixedColumnWidth(165), //165,
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
                    //"Image",
                    lang.image,
                    //"Quiz Name",
                    lang.quizName,
                    //"Reward Point",
                    lang.rewardPoint,
                    // "Created At",
                    lang.createdAt
                  ].asMap().entries.map((column) {
                    final _width = _columnWidths[column.key];
                    return DataColumn(
                      label: Container(
                        width: _width,
                        alignment: AlignmentDirectional.center,
                        child: Text(column.value),
                      ),
                    );
                  }).toList(),
                  rows: _data.map(
                    (item) {
                      final _cells = [
                        AvatarWidget(imagePath: item.$1, fit: BoxFit.cover),
                        Text(item.$2, style: _cellStyle),
                        Text(item.$3.toString(), style: _cellStyle),
                        Text(
                          DateFormat('dd MMM yyyy - hh:mm a').format(item.$4),
                          textAlign: TextAlign.center,
                          style: _cellStyle,
                        ),
                      ];
                      return DataRow(
                          cells: _cells.asMap().entries.map((x) {
                        return DataCell(
                          Container(
                            alignment: AlignmentDirectional.center,
                            width: _columnWidths[x.key],
                            child: x.value,
                          ),
                        );
                      }).toList());
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
