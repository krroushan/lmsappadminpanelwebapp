// 🎯 Dart imports:
import 'dart:math' as math;

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:appflowy_board/appflowy_board.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:magicoon_icons/MagicoonIcons_icons.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../core/helpers/field_styles/field_styles.dart';
import '../../core/static/static.dart';
import '../../core/theme/theme.dart';
import '../../widgets/widgets.dart';

part 'components/_kanban_card.dart';
part 'components/_kanban_dialogs.dart';
part 'data/kanban_mock_data.dart';

class KanbanView extends StatefulWidget {
  const KanbanView({super.key});

  @override
  State<KanbanView> createState() => _KanbanViewState();
}

class _KanbanViewState extends State<KanbanView> {
  AppFlowyBoardController boardController = AppFlowyBoardController(
    onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      //debugPrint('Move item from $fromIndex to $toIndex');
      debugPrint(
          '${l.S.current.moveItemFrom} $fromIndex ${l.S.current.to} $toIndex');
    },
    onMoveGroupItem: (groupId, fromIndex, toIndex) {
      debugPrint(
          '${l.S.current.move} $groupId:$fromIndex ${l.S.current.to} $groupId:$toIndex');
    },
    onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint(
          '${l.S.current.move} $fromGroupId:$fromIndex ${l.S.current.to} $toGroupId:$toIndex');
    },
  );
  final boardScrollController = AppFlowyBoardScrollController();

  @override
  void initState() {
    boardController.addGroup(
      AppFlowyGroupData(
        id: generateRandomString(),
        // name: 'In Progress',
        name: l.S.current.InProgress,
        items: [...tasks.take(2)],
      ),
    );

    boardController.addGroup(
      AppFlowyGroupData(
        id: generateRandomString(),
        //name: 'In Review',
        name: l.S.current.InReview,
        items: [...tasks.skip(2)],
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    boardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 480,
          value: _SizeInfo(
            alertFontSize: 12,
            padding: EdgeInsetsDirectional.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 481,
          end: 576,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsetsDirectional.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 577,
          end: 992,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsetsDirectional.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;

    return Padding(
      padding: _sizeInfo.padding,
      child: AppFlowyBoard(
        controller: boardController,
        boardScrollController: boardScrollController,
        cardBuilder: (context, group, _) {
          final item = _ as KanbanTaskItem;
          return AppFlowyGroupCard(
            key: ObjectKey(item),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: KanbanCard(
              taskItem: item,
              onActionSelect: (value) {
                return switch (value) {
                  'View' => _handleViewTask(context, item),
                  'Delete' => _handleDeleteTask(
                      context,
                      group: group,
                      item: item,
                    ),
                  _ => null,
                };
              },
            ),
          );
        },
        groupConstraints: const BoxConstraints.tightFor(width: 375),
        config: AppFlowyBoardConfig(
          groupBackgroundColor:
              _isDark ? AcnooAppColors.kDark3 : AcnooAppColors.kNeutral200,
          groupMargin: const EdgeInsets.symmetric(horizontal: 12),
          cardMargin: const EdgeInsets.all(20),
          groupBodyPadding: const EdgeInsets.all(12),
        ),
        headerBuilder: (context, groupData) => _buildGroupHeader(
          context,
          groupData,
        ),
        trailing: Padding(
          padding: const EdgeInsetsDirectional.only(start: 24),
          child: ElevatedButton.icon(
            onPressed: () async {
              final _result = await showDialog<AppFlowyGroupData<Color>?>(
                context: context,
                builder: (context) => const AddKanbanBoardDialog(),
              );

              if (_result != null) {
                boardController.addGroup(_result);
              }
            },
            icon: const Icon(Icons.add_circle_outline_outlined),
            //label: const Text('Add New Board'),
            label: Text(_lang.addNewBoard),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              fixedSize: const Size.fromWidth(372),
              backgroundColor: _theme.colorScheme.primaryContainer,
              foregroundColor: _isDark
                  ? AcnooAppColors.kPrimary400
                  : AcnooAppColors.kPrimary600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupHeader(
    BuildContext context,
    AppFlowyGroupData groupData,
  ) {
    final _theme = Theme.of(context);
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: _theme.colorScheme.primaryContainer,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: groupData.customData ?? _theme.primaryColor,
              width: 2,
            ),
          ),
        ),
        padding:
            const EdgeInsetsDirectional.symmetric(vertical: 4, horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              groupData.headerData.groupName,
              style: _theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      return boardController.removeGroup(groupData.id);
                    },
                    icon: const Icon(MagicoonIcons.trash),
                    color: _theme.checkboxTheme.side?.color,
                  ),
                  IconButton(
                    onPressed: () async {
                      final _result = await showDialog<KanbanTaskItem?>(
                        context: context,
                        builder: (context) => const AddKanbanProjectDialog(),
                      );

                      if (_result != null) {
                        boardController.addGroupItem(groupData.id, _result);
                      }
                    },
                    icon: const Icon(MagicoonIcons.plus_circle1),
                    color: _theme.checkboxTheme.side?.color,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleViewTask(BuildContext context, KanbanTaskItem item) async {
    await showDialog(
      context: context,
      builder: (context) => KanbanTaskViewerDialog(item: item),
    );
  }

  void _handleDeleteTask(
    BuildContext context, {
    required AppFlowyGroupData group,
    required KanbanTaskItem item,
  }) async {
    return boardController.removeGroupItem(
      group.id,
      item.id,
    );
  }
}

class _SizeInfo {
  final double? alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  const _SizeInfo({
    this.alertFontSize = 18,
    this.padding = const EdgeInsetsDirectional.all(24),
    this.innerSpacing = 24,
  });
}
