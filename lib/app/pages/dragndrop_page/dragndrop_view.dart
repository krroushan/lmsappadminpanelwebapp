// 🐦 Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../core/theme/_app_colors.dart';
import '../../widgets/widgets.dart';

part 'data/mock_table_data.dart';

class DragAndDropView extends StatefulWidget {
  const DragAndDropView({super.key});

  @override
  State<DragAndDropView> createState() => _DragAndDropViewState();
}

class _DragAndDropViewState extends State<DragAndDropView> {
  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _mqSize = MediaQuery.sizeOf(context);
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

    return Scaffold(
      body: Padding(
        padding: _sizeInfo.padding,
        child: ShadowContainer(
          //headerText: 'Table Drag & Drop',
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
                      header: _buildTableHeader(context),
                      scrollDirection: Axis.vertical,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (oldIndex < 0 || oldIndex >= employees.length) {
                            return;
                          }
                          if (newIndex < 0 || newIndex >= employees.length) {
                            return;
                          }

                          // Adjust newIndex if it's greater than oldIndex
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }

                          final Employee item = employees.removeAt(oldIndex);
                          employees.insert(newIndex, item);
                        });
                      },
                      children: [
                        for (int index = 0; index < employees.length; index++)
                          _buildDataRow(employees[index], index),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
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
          color: theme.colorScheme.outline,
        ), // Add border for better separation
      ),
      key: const ValueKey('header'),
      padding: const EdgeInsetsDirectional.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              '#',
              style: textTheme.titleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              lang.registeredOn,
              style: textTheme.titleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              lang.userName,
              style: textTheme.titleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              lang.email,
              style: textTheme.titleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              lang.phone,
              style: textTheme.titleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              lang.position,
              style: textTheme.titleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              lang.status,
              style: textTheme.titleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.center,
              child: Text(
                lang.action,
                style: textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ), // Empty space for alignment
        ],
      ),
    );
  }

  Widget _buildDataRow(Employee e, int index) {
    final theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    final lang = l.S.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline,
        ), // Border for separation
      ),
      key: ValueKey('$index-${e.userName}'),
      padding: const EdgeInsetsDirectional.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
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
            child: Text(
              e.email,
              style: textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              e.phoneNumber,
              style: textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              e.position,
              style: textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 25.0),
              child: Container(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: e.isActive
                      ? AcnooAppColors.kSuccess.withOpacity(0.2)
                      : AcnooAppColors.kError.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Text(
                  //e.isActive ? 'Active' : 'Inactive',
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
              alignment: AlignmentDirectional.center,
              child: Icon(
                Icons.more_vert_rounded,
                color: theme.colorScheme.onTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SizeInfo {
  final double alertFontSize;
  final EdgeInsetsDirectional padding;
  final double innerSpacing;

  const _SizeInfo({
    this.alertFontSize = 16,
    this.padding = const EdgeInsetsDirectional.all(16),
    this.innerSpacing = 16,
  });
}
