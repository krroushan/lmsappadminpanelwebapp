part of '../kanban_view.dart';

class KanbanCard extends StatefulWidget {
  const KanbanCard({
    super.key,
    required this.taskItem,
    this.onActionSelect,
  });
  final KanbanTaskItem taskItem;
  final void Function(String value)? onActionSelect;

  @override
  State<KanbanCard> createState() => _KanbanCardState();
}

class _KanbanCardState extends State<KanbanCard> {
  bool isHovering = false;
  void changeHoverState(bool value) {
    return setState(() => isHovering = value);
  }

  double calculateTimeElapsedPercentage(DateTime startDate, DateTime endDate) {
    DateTime now = DateTime.now();

    if (now.isBefore(startDate)) now = startDate;
    if (now.isAfter(endDate)) now = endDate;

    Duration totalDuration = endDate.difference(startDate);
    Duration elapsedTime = now.difference(startDate);

    double percentageElapsed =
        elapsedTime.inMilliseconds / totalDuration.inMilliseconds;

    return percentageElapsed.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _completionInPercent = calculateTimeElapsedPercentage(
      widget.taskItem.startDate,
      widget.taskItem.endDate,
    );

    final _hoursDifference =
        widget.taskItem.endDate.difference(DateTime.now()).inHours;
    final _daysLeft =
        (_hoursDifference / 24).floor() + ((_hoursDifference % 24) > 1 ? 1 : 0);

    return MouseRegion(
      onEnter: (event) => changeHoverState(true),
      onExit: (event) => changeHoverState(false),
      cursor: SystemMouseCursors.click,
      child: Material(
        color: _theme.colorScheme.primaryContainer,
        elevation: isHovering ? 4.75 : 0,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Header
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        AvatarWidget(
                          initialsOnly: true,
                          fullName: widget.taskItem.title,
                          avatarShape: AvatarShape.roundedRectangle,
                          backgroundColor:
                              AcnooAppColors.kPrimary600.withOpacity(0.20),
                          foregroundColor: AcnooAppColors.kPrimary600,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          widget.taskItem.title,
                          style: _theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => {
                      // "View": FeatherIcons.eye,
                      // "Edit": FeatherIcons.edit,
                      // "Delete": FeatherIcons.trash2,

                     l.S.of(context).view: FeatherIcons.eye,
                      l.S.of(context).edit: FeatherIcons.edit,
                      l.S.of(context).delete: FeatherIcons.trash2,
                    }
                        .entries
                        .map(
                          (e) => PopupMenuItem(
                            value: e.key,
                            child: Row(
                              children: [
                                Icon(e.value),
                                const SizedBox(width: 8),
                                Text(
                                  e.key,
                                  style: _theme.textTheme.bodyLarge?.copyWith(),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onSelected: widget.onActionSelect,
                    color: _theme.colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),

              // Task Description
              Text(
                widget.taskItem.description,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: _theme.textTheme.labelLarge?.copyWith(
                  color: _theme.colorScheme.onTertiaryContainer,
                ),
              ),
              const SizedBox(height: 16),

              // Dates
              Row(
                children: [
                  Flexible(
                    child: Text.rich(
                      TextSpan(
                        //text: 'Start date\n',
                        text: '${lang.startDate}\n',
                        children: [
                          TextSpan(
                            text:
                                DateFormat(AppDateConfig.appMonthNameDateFormat)
                                    .format(
                              widget.taskItem.startDate,
                            ),
                            style: _theme.textTheme.labelLarge,
                          ),
                        ],
                      ),
                      style: _theme.textTheme.labelLarge?.copyWith(
                        color: _theme.checkboxTheme.side?.color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16 * 2),
                  Flexible(
                    child: Text.rich(
                      TextSpan(
                        //text: 'End date\n',
                        text: '${lang.endDate}\n',
                        children: [
                          TextSpan(
                            text:
                                DateFormat(AppDateConfig.appMonthNameDateFormat)
                                    .format(
                              widget.taskItem.endDate,
                            ),
                            style: _theme.textTheme.labelLarge,
                          ),
                        ],
                      ),
                      style: _theme.textTheme.labelLarge?.copyWith(
                        color: _theme.checkboxTheme.side?.color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Progress Indicator
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${(_completionInPercent * 100).toStringAsFixed(2)}%',
                  style: _theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                minHeight: 10,
                borderRadius: BorderRadius.circular(30),
                value: _completionInPercent,
              ),
              const SizedBox(height: 16),

              // Assigned Employees
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          lang.assignedTo,
                          //'Assigned to',
                          style: _theme.textTheme.bodySmall?.copyWith(
                            color: _theme.checkboxTheme.side?.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 28,
                          width: double.maxFinite,
                          alignment: Alignment.centerRight,
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: List.generate(
                              widget.taskItem.users.length >= 4
                                  ? 4
                                  : widget.taskItem.users.length,
                              (index) {
                                final _image =
                                    widget.taskItem.users[index].imagePath;
                                final _initialOnly = index >= 3;
                                return Positioned(
                                  left: (index * 16).toDouble(),
                                  child: AvatarWidget(
                                    size: const Size.square(28),
                                    avatarShape: AvatarShape.circle,
                                    imagePath: _initialOnly ? null : _image,
                                    fullName: _initialOnly
                                        ? '+ ${widget.taskItem.users.length - 3}'
                                        : null,
                                    initialsOnly: _initialOnly,
                                    backgroundColor:
                                        _initialOnly ? Colors.white : null,
                                    foregroundColor: _initialOnly
                                        ? _theme.checkboxTheme.side?.color
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AcnooAppColors.kWarning.withOpacity(0.20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          IconlyLight.calendar,
                          size: 16,
                          color: AcnooAppColors.kWarning,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          //'$_daysLeft ${_daysLeft <= 1 ? 'day' : 'days'} left',
                          '$_daysLeft ${_daysLeft <= 1 ? lang.day : lang.days} ${lang.left}',
                          style: _theme.textTheme.bodySmall?.copyWith(
                            color: AcnooAppColors.kWarning,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
