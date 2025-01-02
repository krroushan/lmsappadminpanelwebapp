// 🐦 Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../core/theme/_app_colors.dart';
import '../../widgets/avatars/_avatar_widget.dart';
import '../../widgets/shadow_container/_shadow_container.dart';
import '../dragndrop_page/dragndrop_view.dart';
import '../users_page/user_list/demo_model.dart';

class DataTableView extends StatefulWidget {
  const DataTableView({super.key});

  @override
  State<DataTableView> createState() => _DataTableViewState();
}

class _DataTableViewState extends State<DataTableView> {
  bool _selectAll = false;
  final List<UserDataModel> totalUser = AllUsers.allData;

  void _selectAllRows(bool select) {
    setState(() {
      _selectAll = select;
      for (var user in totalUser) {
        user.isSelected = select;
      }
    });
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final theme = Theme.of(context);
    final _mqSize = MediaQuery.sizeOf(context);
    final double _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(_padding),
          child: Column(
            children: [
              _buildTable(
                context,
                lang.defaultTable,
                theme,
                false,
                const BoxDecoration(),
                EdgeInsets.zero,
              ),
              const SizedBox(height: 24),
              _buildTable(
                context,
                lang.borderedTable,
                //'Bordered Table',
                theme,
                true,
                BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: theme.colorScheme.outline,
                    width: 1.0,
                  ),
                ),
                EdgeInsets.all(_padding),
              ),
              const SizedBox(height: 24),
              ShadowContainer(
                contentPadding: EdgeInsets.all(_padding),
                // headerText: 'Table Drag & Drop',
                headerText: lang.tableDragDrop,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final _size = constraints.biggest;
                    return PrimaryScrollController(
                      controller: ScrollController(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints.loose(
                            Size.fromWidth(
                              _mqSize.width <= 1239 ? 1366 : _size.width,
                            ),
                          ),
                          child: ReorderableListView(
                            dragStartBehavior: DragStartBehavior.start,
                            buildDefaultDragHandles: false,
                            shrinkWrap: true,
                            header: _buildTableHeader(),
                            scrollDirection: Axis.vertical,
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                if (oldIndex < 0 ||
                                    oldIndex >= employees.length) return;
                                if (newIndex < 0 ||
                                    newIndex >= employees.length) return;

                                // Adjust newIndex if it's greater than oldIndex
                                if (newIndex > oldIndex) {
                                  newIndex -= 1;
                                }

                                final Employee item =
                                    employees.removeAt(oldIndex);
                                employees.insert(newIndex, item);
                              });
                            },
                            children: [
                              for (int index = 0;
                                  index < employees.length;
                                  index++)
                                _buildDataRow(employees[index], index),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTable(
    BuildContext context,
    String headerText,
    ThemeData theme,
    bool hasBorder,
    BoxDecoration decoration,
    EdgeInsetsGeometry padding,
  ) {
    final textTheme = theme.textTheme;

    return ShadowContainer(
      contentPadding: EdgeInsets.zero,
      headerText: headerText,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
              ),
              child: Padding(
                padding: padding,
                child: Theme(
                  data: ThemeData(
                      dividerColor: theme.colorScheme.outline,
                      checkboxTheme: const CheckboxThemeData(
                        side: BorderSide(
                          color: AcnooAppColors.kNeutral500,
                          width: 1.0,
                        ),
                      ),
                      dividerTheme: DividerThemeData(
                        color: theme.colorScheme.outline,
                      )),
                  child: DataTable(
                    decoration: decoration,
                    dividerThickness: 1,
                    headingTextStyle: textTheme.titleMedium,
                    dataTextStyle: textTheme.bodySmall,
                    horizontalMargin: 16.0,
                    headingRowColor:
                        WidgetStateProperty.all(theme.colorScheme.surface),
                    columns: _buildColumns(),
                    rows: totalUser.take(10).map(
                      (data) {
                        return DataRow(
                          color: WidgetStateColor.transparent,
                          selected: data.isSelected,
                          cells: _buildCells(data, theme),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    final lang = l.S.of(context);
    return [
      DataColumn(
        label: Row(
          children: [
            Checkbox(
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              value: _selectAll,
              onChanged: (value) {
                _selectAllRows(value ?? false);
              },
            ),
            const SizedBox(width: 12.0),
            //Text('Sl.'),
            Text('${lang.SL}.'),
          ],
        ),
      ),
      DataColumn(label: Text(lang.registeredOn)),
      DataColumn(label: Text(lang.userName)),
      DataColumn(label: Text(lang.email)),
      DataColumn(label: Text(lang.phone)),
      DataColumn(label: Text(lang.position)),
      DataColumn(label: Text(lang.status)),
      DataColumn(label: Text(lang.actions)),
    ];
  }

  List<DataCell> _buildCells(UserDataModel data, ThemeData theme) {
    final textTheme = theme.textTheme;

    return [
      DataCell(
        Row(
          children: [
            Checkbox(
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              value: data.isSelected,
              onChanged: (selected) {
                setState(() {
                  data.isSelected = selected ?? false;
                  _selectAll = totalUser.every((d) => d.isSelected);
                });
              },
            ),
            const SizedBox(width: 12.0),
            Text(
              data.id.toString(),
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      DataCell(
        Text(
          DateFormat('d MMM yyyy').format(DateTime.now()),
          style: textTheme.bodyMedium,
        ),
      ),
      DataCell(Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AvatarWidget(
              fit: BoxFit.cover,
              avatarShape: AvatarShape.circle,
              size: const Size(40, 40),
              imagePath: data.imagePath,
            ),
          ),
          const SizedBox(width: 8.0),
          Text(
            data.username,
            style: textTheme.bodyMedium,
          ),
        ],
      )),
      DataCell(
        Text(
          data.email,
          style: textTheme.bodyMedium,
        ),
      ),
      DataCell(
        Text(
          data.phone,
          style: textTheme.bodyMedium,
        ),
      ),
      DataCell(
        Text(
          data.position,
          style: textTheme.bodyMedium,
        ),
      ),
      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: data.status == 'Active'
                ? AcnooAppColors.kSuccess.withOpacity(0.2)
                : AcnooAppColors.kError.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Text(
            data.status,
            style: textTheme.bodyMedium?.copyWith(
              color: data.status == 'Active'
                  ? AcnooAppColors.kSuccess
                  : AcnooAppColors.kError,
            ),
          ),
        ),
      ),
      DataCell(
        PopupMenuButton<String>(
          onSelected: (action) {
            switch (action) {
              case 'Edit':
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('${l.S.of(context).edit} ${data.username}')),
                );
                break;
              case 'View':
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('${l.S.of(context).viewed} ${data.username}')),
                );
                break;
              case 'Delete':
                setState(() {
                  totalUser.remove(data);
                });
                break;
            }
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem<String>(
                value: 'Edit',
                child: Text(l.S.of(context).edit),
              ),
              PopupMenuItem<String>(
                value: 'View',
                child: Text(l.S.of(context).view),
              ),
              PopupMenuItem<String>(
                value: 'Delete',
                child: Text(l.S.of(context).delete),
              ),
            ];
          },
          color: theme.colorScheme.primaryContainer,
        ),
      ),
    ];
  }

  Widget _buildTableHeader() {
    final lang = l.S.of(context);
    final theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12.0),
          topLeft: Radius.circular(12.0),
        ),
        color: theme.colorScheme.surface,
        border: Border.all(
            color:
                theme.colorScheme.outline), // Add border for better separation
      ),
      key: const ValueKey('header'),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Text('#',
                  style: textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis)),
          Expanded(
              child: Text(lang.registeredOn,
                  style: textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis)),
          Expanded(
              child: Text(lang.userName,
                  style: textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis)),
          Expanded(
              child: Text(lang.email,
                  style: textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis)),
          Expanded(
              child: Text(lang.phone,
                  style: textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis)),
          Expanded(
              child: Text(lang.position,
                  style: textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis)),
          Expanded(
              child: Text(lang.status,
                  style: textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis)),
          Expanded(
              child: Align(
                  alignment: Alignment.center,
                  child: Text(lang.action,
                      style: textTheme.titleSmall,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis))), // Empty space for alignment
        ],
      ),
    );
  }

  Widget _buildDataRow(Employee e, int index) {
    final lang = l.S.of(context);
    final theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: theme.colorScheme.outline), // Border for separation
      ),
      key: ValueKey('$index-${e.userName}'),
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: ReorderableDragStartListener(
                index: index,
                child: SvgPicture.asset(
                  'assets/images/sidebar_icons/arrows-move.svg',
                  color: theme.colorScheme.onTertiary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              DateFormat('MMM dd, yyyy').format(e.registeredOn),
              style: textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                AvatarWidget(
                  imagePath: e.imagePath,
                  size: const Size.square(40),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    e.userName,
                    style: textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(e.email,
                style: textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            child: Text(e.phoneNumber,
                style: textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            child: Text(e.position,
                style: textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: e.isActive
                      ? AcnooAppColors.kSuccess.withOpacity(0.2)
                      : AcnooAppColors.kError.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Text(
                  e.isActive ? lang.active : lang.inactive,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: e.isActive
                        ? AcnooAppColors.kSuccess
                        : AcnooAppColors.kError,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.more_vert_rounded,
                  color: theme.colorScheme.onTertiary,
                )),
          ),
        ],
      ),
    );
  }
}
